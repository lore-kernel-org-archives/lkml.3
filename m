Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbaC0Tav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:30:51 -0400
Received: from static-209-166-131-148.expedient.com ([209.166.131.148]:60931
	"EHLO natasha.panasas.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbaC0Tap convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:30:45 -0400
From: Jim Lieb <jlieb@panasas.com>
To: Jeremy Allison <jra@samba.org>
CC: Jeff Layton <jlayton@redhat.com>, Florian Weimer <fweimer@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <bfields@redhat.com>
Subject: Re: Re: Thoughts on credential switching
Date: Thu, 27 Mar 2014 12:30:04 -0700
Message-ID: <2487921.a0QJrtikX0@jlieb-e6410>
Organization: Panasas Inc.
User-Agent: KMail/4.11.5 (Linux/3.13.6-100.fc19.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140327182617.GC2526@jeremy-laptop>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com> <20140327070126.41ac75ac@ipyr.poochiereds.net> <20140327182617.GC2526@jeremy-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than inline, I'm responding in the context of Jeremy's comments but I 
have to answer others as well.  It is Jeremy after all who said my baby was 
ugly ;).

Jeremy is right about overloading "fd".  Maybe I can call it something else 
but an fd (in implementation) has merit because a creds struct hangs off of 
either/or/both task_struct and file but nothing else.  Coming up with a creds 
token struct adds/intros another struct to the kernel that has to justify its 
existence.  This fd points to an anon inode so the resource consumption is 
pretty low and all the paths for managing it are well known and *work*.  I'm 
trying to get across the swamp, not build a new Golden Gate bridge...

As for POSIX, all of the pthreads API was based on CDE threads whose initial 
implementation was on Ultrix (BSD 4.2).  Process wide was assumed because 
utheeads was a user space hack and setuid was process wide because a proc was 
a just that.  Good grief, that kernel was UP...  When OSF/1 appeared, the Mach 
2.5 kernel just carried that forward with its proc + thread(s) model to be 
compatible with the old world.  In other words, we incrementally backed 
ourselves into a corner.  Declaring POSIX now avoids admitting that we didn't 
see all that far into the future.  Enough said.  These calls are *outside* 
POSIX.  Pthreads in 2014 is broken/obsolete.

For the interface, I changed it from what is in the cited lkml below.   It is 
now:

   int switch_creds(struct user_creds *creds);

Behavior is the same except the mux'd syscall idea is gone.  Adding a flags arg 
to this is a useful idea both for current use and future proofing the API.  But 
this requires a second call

   int use_creds(int fd);

This call does the "use an fd" case but adds -1 to revert to real creds.  Its 
guts are either an override_creds(fd->file->creds) or a revert_creds().  Nice 
and quick.  Note that use_creds(fd) is used if I have cached the fd/token from 
switch_creds().  Also nice and quick.

Given that I've done the checking in switch_creds and I don't pass anything 
back other than the token/fd and this token/fd is/will be confined to the 
thread group, use_creds(fd) only needs to validate that it is a switch_creds 
one, not from an arbitrary open().  I do this.

I have focused this down to "fsuid" because I intend this for ops that file 
perms.  Other stuff is out of scope unless someone can come up with a use case 
and add flag defs...  The other variations on the theme uid, euid, and that 
other one I don't understand the use for, are for long lasting creds change, 
i.e. become user "bob" and go off an fork a shell...  I am wrapping I/O.

I do not like the idea of spinning off a separate proc to do creds work.  It 
doesn't buy anything in performance (everybody is a task to the kernel) but it 
does open a door to scary places.  Jeremy and I agree that this token/fd must 
stay within the thread group, aka, process.  I have already (in the newer 
patchset) tied off inheritance by opening the anon fd with close-on-exec.  I 
think I tied off passing the fd thru a unix socket but if not, I will in my 
next submission.  This fd/token should stay within the thread group, period.

As to the "get an fd and then do set*id", you have to do this twice because 
that fd gets the creds at the time of open, not after fooling around.  I am 
trying to avoid multiple RCU cycles, not add more.  Second, the above path 
makes the creds switch atomic because I use the creds swapping infrastructure. 
Popping back up to user space before that *all* happens opens all kinds of 
ptrace+signal+??? holes.

Note also that I mask caps as well in the override creds including the caps to 
do things like set*id.  That is intentional.  This whole idea is to constrain 
the thread, not open a door *but* still provide a way to get back home 
(safely).  That is via use_creds(-1).

Some have proposed that we personalize a worker thread (the rpc op processor) 
to the creds of the client user right off.  Ganesha only needs to do this user 
creds work for VFS (kernel local) filesystems.  Most of our cluster filesystems 
have apis that allow us to pass creds directly on calls.  We only need this 
for that local mounted namespace.  The server core owns rpc and ops, the 
backend (FSAL) owns the shim layer.  User creds are backend...  Having a 
personalized thread complicates the core.

As I mentioned at LSF, I have another set pending that needs a bit more polish 
to answer issues from the last cycle.  I need to fix the issue of handling 
syscalls that would do their own creds swapping inside the switch_creds ... 
use_creds(-1) region.  The patch causes these syscalls, e.g. setuid() to 
EPERM.  Again, I like this because I want the client creds impersonating 
thread to only be able to do I/O, not escape into the wild.

Jim
On Thursday, March 27, 2014 11:26:17 Jeremy Allison wrote:
> On Thu, Mar 27, 2014 at 07:01:26AM -0700, Jeff Layton wrote:
> > On Thu, 27 Mar 2014 14:06:32 +0100
> > 
> > Florian Weimer <fweimer@redhat.com> wrote:
> > > On 03/27/2014 02:02 PM, Jeff Layton wrote:
> > > >> This interface does not address the long-term lack of POSIX
> > > >> compliance in setuid and friends, which are required to be
> > > >> process-global and not thread-specific (as they are on the kernel
> > > >> side).
> > > >> 
> > > >> glibc works around this by reserving a signal and running set*id on
> > > >> every thread in a special signal handler.  This is just crass, and
> > > >> it is likely impossible to restore the original process state in
> > > >> case of partial failure.  We really need kernel support to perform
> > > >> the process-wide switch in an all-or-nothing manner.
> > > > 
> > > > I disagree. We're treading new ground here with this syscall. It's
> > > > not defined by POSIX so we're under no obligation to follow its
> > > > silly directives in this regard. Per-process cred switching doesn't
> > > > really make much sense in this day and age, IMO. Wasn't part of the
> > > > spec was written before threading existed
> > > 
> > > Okay, then we need to add a separate set of system calls.
> > > 
> > > I really, really want to get rid of that signal handler mess in
> > > glibc, with its partial failures.
> > 
> > I agree, it's a hack, but hardly anyone these days really wants to
> > switch creds on a per-process basis. It's just that we're saddled with
> > a spec for those calls that was written before threads really existed.
> > 
> > The kernel syscalls already do the right thing as far as I'm concerned.
> > What would be nice however is a blessed glibc interface to them
> > that didn't involve all of the signal handling stuff. Then samba et. al.
> > wouldn't need to call syscall() directly to get at them.
> 
> Amen to that :-).
> 
> However, after talking with Jeff and Jim at CollabSummit,
> I was 'encouraged' to make my opinions known on the list.
> 
> To me, calling the creds handle a file descriptor just
> feels wrong. IT *isn't* an fd, you can't read/write/poll
> on it, and it's only done as a convenience to get the
> close-on-exec semantics and the fact that the creds are
> already hung off the fd's in kernel space.
> 
> I'd rather any creads call use a different type, even if
> it's a typedef of 'int -> creds_handle_t', just to make
> it really clear it's *NOT* an fd.
> 
> That way we can also make it clear this thing only has
> meaning to a thread group, and SHOULD NOT (and indeed
> preferably CAN NOT) be passed between processes.
> 
> Cheers,
> 
> 	Jeremy.

-- 
Jim Lieb
Linux Systems Engineer
Panasas Inc.

"If ease of use was the only requirement, we would all be riding tricycles"
- Douglas Engelbart 1925–2013
