Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbaKCGQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 01:16:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36243 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaKCGQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 01:16:33 -0500
Date: Mon, 3 Nov 2014 06:16:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [RFC] dupfs semantics
Message-ID: <20141103061632.GY7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	FWIW, now it can be done - with fairly limited changes we *can*
implement something similar to Plan 9 dupfs (#d) and *BSD fdescfs.  I.e.
a filesystem with one directory, with contents depending on which process
is looking there, files corresponding to opened descriptors of the process
in question.  So far it looks like our /proc/self/fd (or /dev/fd), but
there's one really important difference - open("/fd/0", 0) on Plan 9 doesn't
reopen your stdin, it is equivalent to dup(0).  In other words, you get
an extra reference to the corresponding file, not fresh open of the same
underlying object.

	In a lot of situations it makes for better semantics.  Example:
; cat >a.sh <<'EOF'
read i
diff -u "$i" /dev/stdin
EOF
; (echo a.sh; cat a.sh) > data
; cat data |sh a.sh
; <data sh a.sh
--- a.sh        2014-11-02 23:31:03.000000000 -0500
+++ /dev/stdin  2014-11-02 23:32:41.000000000 -0500
@@ -1,2 +1,3 @@
+a.sh
 read i 
 diff -u "$i" /dev/stdin
;

... and we have a different behaviour when fed from pipe and when redirected
from file.  Similar to that,
; cat >a.sh <<'EOF'
read i
grep "$i" -
EOF
; cat >b.sh <<'EOF'
read i
grep "$i" /dev/stdin
EOF
; cat >data <<'EOF'
a
a
b
EOF
; cat data | sh a.sh
a
; cat data | sh b.sh

So far, so good - "-" in grep arguments means stdin, so we could expect to get
the same behaviour.  Except that it breaks on redirects -
; sh a.sh <data
a
; sh b.sh <data
a
a
;

In other words, in situation when you have a program that expects a filename
and want to feed it to/from a preexisting descriptor, our semantics is bloody
inconvenient.  Worse, it simply fails when descriptor in question happens to
be something like a socket, eventfd, etc. - regular files, devices, directories
and pipes work, everything else is SOL.  We *can't* reopen a socket - a lot
of logics in net/* assumes that there's only one struct file over given socket.

The reason why we really couldn't do it with dup-style semantics was that
our ->open() takes struct file and returns 0 on success and -E<something>
on error.  There's no way to return a different file *and* we have too many
instances of ->open() to change the method's signature.

FWIW, FreeBSD got away with a horrible hack - they stash the descriptor
number in their equivalent of task_struct and pull off rather brittle and
ugly trick to pick in their kern_openat().  ->open() side is
        /*
         * XXX Kludge: set td->td_proc->p_dupfd to contain the value of the file
         * descriptor being sought for duplication. The error return ensures
         * that the vnode for this device will be released by vn_open. Open
         * will detect this special error and take the actions in dupfdopen.
         * Other callers of vn_open or VOP_OPEN will simply report the
         * error.
         */
        ap->a_td->td_dupfd = VTOFDESC(vp)->fd_fd;       /* XXX */
        return (ENODEV);
and the other end is
                /*
                 * Handle special fdopen() case. bleh.
                 *
                 * Don't do this for relative (capability) lookups; we don't
                 * understand exactly what would happen, and we don't think
                 * that it ever should.
                 */
                if (nd.ni_strictrelative == 0 &&
                    (error == ENODEV || error == ENXIO) &&
                    td->td_dupfd >= 0) {
                        error = dupfdopen(td, fdp, td->td_dupfd, flags, error,
                            &indx);
                        if (error == 0)
                                goto success;
                }
 
                goto bad;
Bleh, indeed...

I hadn't looked at Solaris source.  Plan 9 probably has it the easiest way -
their ->open() does, in our terms, take a pointer to struct file (Chan * for
them) and return another such pointer, normally the one it had been given.
If it decides to return a different one - no problem, just drop what you've
got, grab an extra reference to something else and return that.  End of
story.

Now, changing our ->open() is obviously far too much churn.  Fortunately,
we have ->atomic_open() with only 8 instances in the entire tree, none
of them in drivers.  That can be changed without too much PITA.  There are
several possible calling conventions; my preference would be
	old	new
	0	file it has been given
	1	NULL
	-E...	ERR_PTR(-E...)
	-----	an extra reference to preexisting file
letting the caller deal with freeing the unused one in the last case, but
that's not particulary interesting - whichever variant ends up with the
best code in callers (path_openat->do_last->lookup_open->atomic_open).

Getting open() to hit ->atomic_open() is also pretty easy - just don't hash
those dentries and that's it.  Considering that different processes are
going to see different things in that directory, that's the only sane variant
anyway.  They won't live for long anyway - the normal way to pin dentry down
for a long time is open(), and in this case open will *not* do that.  FWIW,
they can all share the same inode - it won't be accessed, anyway (we just
need to supply ->getattr(), which takes a dentry).

IOW, it's quite doable - I'm putting together a branch with minimal variant
of that thing and so far it shapes out reasonably well.  The interesting
part is what should be done in corner cases.

Everyone agrees that read/write access should be a subset of what the existing
file has been opened for; that much is obvious.  However, what about the
other bits?  Everyone appears to agree upon ignoring O_TRUNC.  FreeBSD ignores
O_APPEND as well (and Plan 9 doesn't have it at all); we might do the same,
or we might fail on mismatches.  I'd rather ignore it completely - if our
stdout is opened with O_APPEND | O_WRONLY, I would expect opening /fd/1
(or wherever it might be mounted) with O_WRONLY to succeed.
O_DIRECT is another one - should we ignore mismatches?

Another interesting question is what to do with chmod, etc. on those suckers.
Plan 9 EPERMs on that; FreeBSD in effect turns it into chmod of the target
file.   Note that stat() is *not* forwarded to the target file in either
of those, so chmod() hitting the target is inconsistent (and possibly risky
as well).

A minor twist is statfs() behaviour on that one - FreeBSD is putting rlimit
in f_files and the number of descriptors you could open until you run afoul
of rlimit into f_ffree.  Cute, but not too interesting, IMO...

A really interesting bit is ctl files on Plan 9 - /fd/<n>ctl there is a mix
of our readlink /proc/self/fd/<n> and /proc/self/fdinfo/<n>.  Fairly easy
to implement, the question is what should layout of their contents be...

Any permission checks ought to be skipped in case when a preexisting file gets
returned by ->atomic_open(), IMO - all checks ought to be done in the method
itself (and in this case they are limited to "don't ask for more than it's
already opened for").

Comments?
