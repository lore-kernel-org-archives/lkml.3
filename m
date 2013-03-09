Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab3CIEbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 23:31:52 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:57918 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431Ab3CIEbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 23:31:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130309035053.GA1396@redhat.com>
References: <20130309003617.GB6743@redhat.com>
	<CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
	<20130309020318.GA11449@redhat.com>
	<CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com>
	<20130309022623.GB11449@redhat.com>
	<20130309025631.GA13188@redhat.com>
	<20130309025752.GA13913@redhat.com>
	<CA+55aFxyOYXnzDoWr7Utr1QLjjMUCON5EGH3FMvGBHxnxMJmQQ@mail.gmail.com>
	<20130309032530.GA19839@redhat.com>
	<CA+55aFweyfew3VU79ZQV4otJcWiF0=xKXxDtADXcccNxGaqMwA@mail.gmail.com>
	<20130309035053.GA1396@redhat.com>
Date: Fri, 8 Mar 2013 20:31:48 -0800
X-Google-Sender-Auth: uLMPvSIheLaLFpi38jnWmgIGr4E
Message-ID: <CA+55aFz9d70DCixqNdmit=OHmUi3kB9p14TDVyEvO_yRZ=2FTg@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 7:50 PM, Dave Jones <davej@redhat.com> wrote:
>  > >
>  > > I have a feeling there were some sysfs ones that may still be unfixed.
>
> I was right..
>
> [  425.836722] general protection fault: 0000 [#1] PREEMPT SMP

You forgot to enable DEBUG_PAGE_ALLOC again, but I don't think it much
matters. It's another slab free poison thing.

The faulting instruction is

    mov    0x28(%rbx),%ecx

with %rbx having the value 6b6b6b6b6b6b6b6b.

> [  425.847859] RIP: 0010:[<ffffffff8123f657>]  [<ffffffff8123f657>] sysfs_find_dirent+0x47/0xf0

That seems to be

    if (hash != sd->s_hash)

from sysfs_name_compare() that has been inlined into
sysfs_find_dirent(). And where "sd" is the corrupted value. If I read
things right.

So it looks like the sysfs rbtree is corrupted or something. Adding
Greg to the cc.

            Linus
