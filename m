Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaAQWJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:09:07 -0500
Received: from fieldses.org ([174.143.236.118]:33870 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaAQWJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:09:04 -0500
Date: Fri, 17 Jan 2014 17:08:58 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Message-ID: <20140117220858.GA31416@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-12-git-send-email-miklos@szeredi.hu>
 <20140113122517.GA10366@quack.suse.cz>
 <20140115182347.GB5715@fieldses.org>
 <CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
 <20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
 <52D90B93.5010209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D90B93.5010209@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 11:53:07PM +1300, Michael Kerrisk (man-pages) wrote:
> Hi Miklos,
> 
> A few comments below, including one piece in the code that really must be fixed.
> 
> On 01/16/2014 11:54 PM, Miklos Szeredi wrote:
> >> On Wed, Jan 15, 2014 at 7:23 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> >>> Do you have a man page update somewhere for the two new flags?
> > 
> > Here's the updated man page (and attached the patch)
> > 
> > Michael, could you please review the interface?
> > 
> > I forgot to CC you when posing the patch series.  I can resend it if you want,
> > or you can fetch the latest version of the cross-rename series from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename
> 
> [...]
> 
> >        renameat2()  has an additional flags argument.  renameat2() call with a
> >        zero flags argument is equivalent to renameat().
> > 
> >        The flags argument is a bitfield consisting of zero or more of the fol-
> >        lowing constants defined in <linux/fs.h>:
> > 
> >        RENAME_NOREPLACE
> >               Don't  overwrite  the  target of the rename.  Return an error if
> >               the target would be overwritten.
> > 
> >        RENAME_EXCHANGE
> >               Atomically exchange the source and destination.  Both must exist
> >               but  may  be of a different type (e.g. one a non-empty directory
> >               and the other a symbolic link).
> 
> Somewhere here it would be good to explain the consequences if
> 
>    (flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)) == 
>                    (RENAME_NOREPLACE | RENAME_EXCHANGE)
> 
> Okay -- it's EINVAL, but here the man page text should say something like
> "these two flags can't be specified together", right?
> 
> > RETURN VALUE
> >        On success, renameat() and renameat2()  return  0.   On  error,  -1  is
> >        returned and errno is set to indicate the error.
> > 
> > ERRORS
> >        The  same errors that occur for rename(2) can also occur for renameat()
> >        and  renameat2().   The  following  additional  errors  can  occur  for
> >        renameat() and renameat2():
> > 
> >        EBADF  olddirfd or newdirfd is not a valid file descriptor.
> > 
> >        ENOTDIR
> >               oldpath  is relative and olddirfd is a file descriptor referring
> >               to a file other than a directory; or  similar  for  newpath  and
> >               newdirfd
> > 
> >        The following additional errors are defined for renameat2():
> > 
> >        EOPNOTSUPP
> >               The filesystem does not support a flag in flags
> 
> This is not the usual error for an invalid bit flag. Please make it EINVAL.

I agree that EINVAL makes sense for an invalid bit flag.
 
But renameat2() can also fail when the caller passes a perfectly valid
flags field but the paths resolve to a filesystem that doesn't support
the RENAME_EXCHANGE operation.  EOPNOTSUPP looks more appropriate in
that case.

> (See the man pages for the *at() calls that have a 'flags" argument.)

Aren't those flags mostly handled in the vfs?  In which case they work
everywhere, so there isn't the same distinction between "flag is
defined" and "behavior requested by flag is unsupported for the given
objects".

--b.

> >        EINVAL Invalid combination of flags
> 
> (This is okay.)
> 
> Looks otherwise okay to me (and I agree with Bruce's comments).
> 
> Cheers,
> 
> Michael
> 
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
