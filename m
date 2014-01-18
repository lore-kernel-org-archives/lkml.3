Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaARQ2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 11:28:11 -0500
Received: from fieldses.org ([174.143.236.118]:50539 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaARQ2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 11:28:07 -0500
Date: Sat, 18 Jan 2014 11:27:58 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
Message-ID: <20140118162758.GA11174@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-12-git-send-email-miklos@szeredi.hu>
 <20140113122517.GA10366@quack.suse.cz>
 <20140115182347.GB5715@fieldses.org>
 <CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
 <20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
 <52D90B93.5010209@gmail.com>
 <20140117220858.GA31416@fieldses.org>
 <CAJfpegsW+zTvZZ_k+Wd=FOi0VqANGQHdS_2qSPWWLiXA0K_JJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsW+zTvZZ_k+Wd=FOi0VqANGQHdS_2qSPWWLiXA0K_JJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 07:49:29AM +0100, Miklos Szeredi wrote:
> On Fri, Jan 17, 2014 at 11:08 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > On Fri, Jan 17, 2014 at 11:53:07PM +1300, Michael Kerrisk (man-pages) wrote:
> >> >        The following additional errors are defined for renameat2():
> >> >
> >> >        EOPNOTSUPP
> >> >               The filesystem does not support a flag in flags
> >>
> >> This is not the usual error for an invalid bit flag. Please make it EINVAL.
> >
> > I agree that EINVAL makes sense for an invalid bit flag.
> >
> > But renameat2() can also fail when the caller passes a perfectly valid
> > flags field but the paths resolve to a filesystem that doesn't support
> > the RENAME_EXCHANGE operation.  EOPNOTSUPP looks more appropriate in
> > that case.
> 
> OTOH, from the app's perspective, it makes little difference whether a
> particular kernel doesn't support the reanameat2 syscall, or it
> doesn't support RENAME_FOO flag or if it does support RENAME_FOO but
> not in all filesystems.  In all those cases it has to just fall back
> to something supported and it doesn't matter *why* it wasn't
> supported.

Well, in theory it could allow an optimization:

	if (kernel_has_foo) {
		ret = rename(.,.,.,.,RENAME_FOO);
		if (ret && errno == EINVAL)
			kernel_has_foo = 0;
	}
	if (!kernel_has_foo)
		fallback...

or maybe even:

	if (kernel_has_foo && fs_has_foo[fsid])
		ret = rename(.,.,.,.,RENAME_FOO);
		if (ret && errno == EINVAL)
			kernel_has_foo = 0;
		if (ret && errno == EOPNOTSUPP)
			fs_has_foo[fsid] = 0;
	}
	if (!kernel_has_foo || !fs_has_foo[fsid])
		fallback...

which may both be of dubious value--unless, say, you're implementing a
network protocol and making this distinction to your client allows it to
save server round trips.

That may not be *totally* farfetched--if for example we added rename2 to
the nfs protocol then servers probably will be required to make this
sort of distinction per filesystem, exactly to allow client logic like
the above.

And as long as we can, I'd just rather give the caller more information
than less.

As for precedent for EOPNOTSUPP: grepping through man-pages the one
documented use of EOPNOTSUPP I see for filesystems is fallocate, for a
similar "filesystem doesn't support this operation" case.  "git grep
EOPNOTSUPP fs/" in the kernel repo suggests there are many more such,
but I haven't tried to figure out what any of them are.

--b.
