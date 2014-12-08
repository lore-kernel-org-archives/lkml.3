Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbaLHSOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:14:21 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55536 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaLHSOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:14:18 -0500
MIME-Version: 1.0
In-Reply-To: <20141208180824.GC22149@ZenIV.linux.org.uk>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
	<20141208164650.GB29028@node.dhcp.inet.fi>
	<20141208175805.GB22149@ZenIV.linux.org.uk>
	<20141208180824.GC22149@ZenIV.linux.org.uk>
Date: Mon, 8 Dec 2014 10:14:13 -0800
X-Google-Sender-Auth: J7FDR8TOkle0j_Td6LwEDZIkkCQ
Message-ID: <CA+55aFxwrH4vsyw2ix=HqDK9Z=fw98xtOL8=57prm8qgVmAFfA@mail.gmail.com>
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 10:08 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, virt_to_page() is probably not OK to call on an address in the
> middle of vmalloc'ed area, is it?

See my email that crossed yours. No it is not.

>  Would
>                 for (end = addr + len; addr < end; addr += PAGE_SIZE) {
>                         if (is_vmalloc_addr(addr))
>                                 ACCESS_ONCE(*(char *)addr);
>                         get_page(*pages++ = virt_to_page(addr));
>                 }
> be a safe replacement for the loop in the above?

No. That "ACCESS_ONCE()" does nothing. It reads a byte from 'addr' in
the vmalloc space, and might cause a page fault to make sure it's
mapped, but that is still a no-op.

You can't do "virt_to_page()" on anything but the normal 1:1 kernel
mappings (and only for non-highmem pages at that).

For a vmalloc() address, you'd have to actually walk the page tables.
Which is a f*cking horrible idea. Don't do it. We do have a
"vmalloc_to_page()" that does it, but the basic issue is that you damn
well shouldn't do IO on vmalloc'ed addresses.  vmalloc'ed addresses
only exist in the first place to give a linear *virtual* mapping, if
you want physical pages you shouldn't have mixed it up with vmalloc in
the first place!

Where the hell does this crop up, and who does this insane thing
anyway? It's wrong. How did it ever work before?

                     Linus
