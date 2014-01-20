Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaATLkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:40:06 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:59630 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaATLj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:39:57 -0500
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20140118162758.GA11174@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<1389219015-10980-12-git-send-email-miklos@szeredi.hu>
	<20140113122517.GA10366@quack.suse.cz>
	<20140115182347.GB5715@fieldses.org>
	<CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
	<20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
	<52D90B93.5010209@gmail.com>
	<20140117220858.GA31416@fieldses.org>
	<CAJfpegsW+zTvZZ_k+Wd=FOi0VqANGQHdS_2qSPWWLiXA0K_JJw@mail.gmail.com>
	<20140118162758.GA11174@fieldses.org>
Date: Mon, 20 Jan 2014 12:39:55 +0100
Message-ID: <CAJfpegsScMkTHbeg4xqyBw+C5fu7pHcfz6_1KfZ_t7X8UA3Uvw@mail.gmail.com>
Subject: Re: [PATCH 11/11] ext4: add cross rename support
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 5:27 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Sat, Jan 18, 2014 at 07:49:29AM +0100, Miklos Szeredi wrote:
>> On Fri, Jan 17, 2014 at 11:08 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
>> > On Fri, Jan 17, 2014 at 11:53:07PM +1300, Michael Kerrisk (man-pages) wrote:
>> >> >        The following additional errors are defined for renameat2():
>> >> >
>> >> >        EOPNOTSUPP
>> >> >               The filesystem does not support a flag in flags
>> >>
>> >> This is not the usual error for an invalid bit flag. Please make it EINVAL.
>> >
>> > I agree that EINVAL makes sense for an invalid bit flag.
>> >
>> > But renameat2() can also fail when the caller passes a perfectly valid
>> > flags field but the paths resolve to a filesystem that doesn't support
>> > the RENAME_EXCHANGE operation.  EOPNOTSUPP looks more appropriate in
>> > that case.
>>
>> OTOH, from the app's perspective, it makes little difference whether a
>> particular kernel doesn't support the reanameat2 syscall, or it
>> doesn't support RENAME_FOO flag or if it does support RENAME_FOO but
>> not in all filesystems.  In all those cases it has to just fall back
>> to something supported and it doesn't matter *why* it wasn't
>> supported.
>
> Well, in theory it could allow an optimization:
>
>         if (kernel_has_foo) {
>                 ret = rename(.,.,.,.,RENAME_FOO);
>                 if (ret && errno == EINVAL)
>                         kernel_has_foo = 0;
>         }
>         if (!kernel_has_foo)
>                 fallback...
>
> or maybe even:
>
>         if (kernel_has_foo && fs_has_foo[fsid])
>                 ret = rename(.,.,.,.,RENAME_FOO);
>                 if (ret && errno == EINVAL)
>                         kernel_has_foo = 0;
>                 if (ret && errno == EOPNOTSUPP)
>                         fs_has_foo[fsid] = 0;
>         }
>         if (!kernel_has_foo || !fs_has_foo[fsid])
>                 fallback...
>
> which may both be of dubious value--unless, say, you're implementing a
> network protocol and making this distinction to your client allows it to
> save server round trips.
>
> That may not be *totally* farfetched--if for example we added rename2 to
> the nfs protocol then servers probably will be required to make this
> sort of distinction per filesystem, exactly to allow client logic like
> the above.

I understand, but that's a protocol issue, not a filesystem issue.
The server will need to determine per-filesystem if the operation is
supported or not, but that doesn't depend on the error value returned
by the filesystem.

> And as long as we can, I'd just rather give the caller more information
> than less.
>
> As for precedent for EOPNOTSUPP: grepping through man-pages the one
> documented use of EOPNOTSUPP I see for filesystems is fallocate, for a
> similar "filesystem doesn't support this operation" case.  "git grep
> EOPNOTSUPP fs/" in the kernel repo suggests there are many more such,
> but I haven't tried to figure out what any of them are.

The reason I chose EOPNOTSUPP is because it has the specific meaning:
"this operation is not supported, try to fall back to something else".
 EINVAL just means "something" is invalid.  That would most likely be
the "flags" argument in this specific case, and hence it works for
renameat2().

And differentiating between the "per-filesystem supported" and the
"per kernel supported" thing based on the error value would also work.
  I don't really have a preference and I don't think it's a big deal.

Michael?

Thanks,
Miklos
