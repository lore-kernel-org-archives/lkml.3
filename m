Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343Ab3GLTNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:13:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36869 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965136Ab3GLTNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:13:23 -0400
Date: Fri, 12 Jul 2013 20:13:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] vfs.git part 2
Message-ID: <20130712191321.GB4165@ZenIV.linux.org.uk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
 <CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
 <20130712054817.GY4165@ZenIV.linux.org.uk>
 <8738rk9eai.fsf@rasmusvillemoes.dk>
 <20130712154833.GA4165@ZenIV.linux.org.uk>
 <87wqovviyy.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqovviyy.fsf@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 04:30:45PM +0000, Rasmus Villemoes wrote:
> >> Just thinking out loud, and please tell me to shut up if it doesn't make
> >> sense: The documentation for O_DIRECTORY seems to imply that one could
> >> require O_DIRECTORY to be given when using O_TMPFILE. The "If pathname
> >> is not a directory, cause the open to fail" certainly seems to make
> >> sense when O_TMPFILE is used, and older kernels should complain when
> >> seeing the O_CREAT|O_DIRECTORY combination. It is a hack, though.
> >
> > They should, but they won't ;-/
> 
> I see; I should test before I post, but...
> 
> > It's the same problem - we do *not* validate the flags argument.
> > We'll get to do_last(), hit lookup_open(), which will create the
> > sucker and go to finish_open_created.  Which is past the logics
> > checking for LOOKUP_DIRECTORY trying to return a non-directory and it
> > would've been too late to fail anyway - the file has already been
> > created.  IOW, O_DIRECTORY is ignored when O_CREAT is present *and*
> > file didn't exist already.  In that case we almost certainly can treat
> > that as a bug (i.e. start failing open() on O_CREAT | O_DIRECTORY in
> > all cases - I'd be _very_ surprised if somebody called open() with
> > such combination of flags), but that doesn't help with older
> > kernels...
> 
> ... it seems that if one then omits O_CREAT, things work out ok, as long
> as one uses O_RDWR (which is the only sane thing to do with O_TMPFILE, I
> guess):
> 
> open("/tmp/test/dir", O_DIRECTORY | O_RDWR, 0666) -> -1; Is a directory
> open("/tmp/test/dir", O_DIRECTORY | O_RDONLY, 0666) -> 3; Success
> open("/tmp/test/file", O_DIRECTORY | O_RDWR, 0666) -> -1; Not a directory
> open("/tmp/test/link_to_file", O_DIRECTORY | O_RDWR, 0666) -> -1; Not a directory
> open("/tmp/test/link_to_nowhere", O_DIRECTORY | O_RDWR, 0666) -> -1; No such file or directory
> open("/tmp/test/link_to_dir", O_DIRECTORY | O_RDWR, 0666) -> -1; Is a directory
> open("/tmp/test/link_to_dir", O_DIRECTORY | O_RDONLY, 0666) -> 3; Success
> open("/tmp/test/link_to_dir", O_NOFOLLOW | O_DIRECTORY | O_RDWR, 0666) -> -1; Too many levels of symbolic links
> open("/tmp/test/link_to_dir", O_NOFOLLOW | O_DIRECTORY | O_RDONLY, 0666) -> -1; Too many levels of symbolic links
> 
> (The above flags are what an old kernel would effectively see with or
> without O_TMPFILE present, I suppose.)
> 
> How about simply making O_TMPFILE == O_DIRECTORY | O_RDWR |
> O_TMPFILE_INTERNAL, and letting the correct use be 
> 
> open("/some/dir", O_TMPFILE) [with or without a mode argument]
> 
> Using O_DIRECTORY when we don't want to open a directory, and omitting
> O_CREAT when we do want to create something new, is somewhat
> counter-intuitive, but I think this would solve the problem with old
> kernels.

Hrm...  I can't say I like it, but it's almost OK; the only problem here
is the bug fixed by commit bc77daa78 - on some of the old kernels (including
3.10, BTW) we used to allow opening /proc/self/fd/0 with O_DIRECTORY|O_RDWR ;-/

Said that, I think it's more tolerable than the kludge I came up with -
one would need to pass it a procfs symlink as argument to hit that.
Linus, your opinion?
