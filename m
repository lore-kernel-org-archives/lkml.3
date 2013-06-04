Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3FDL6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:58:11 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42384 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753261Ab3FDL6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:58:08 -0400
Date: Tue, 4 Jun 2013 06:58:07 -0500
From: Robin Holt <holt@sgi.com>
To: Frank Mehnert <frank.mehnert@oracle.com>, linux-mm@kvack.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: Handling NUMA page migration
Message-ID: <20130604115807.GF3672@sgi.com>
References: <201306040922.10235.frank.mehnert@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306040922.10235.frank.mehnert@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably more appropriate to be directed at the linux-mm
mailing list.

On Tue, Jun 04, 2013 at 09:22:10AM +0200, Frank Mehnert wrote:
> Hi,
> 
> our memory management on Linux hosts conflicts with NUMA page migration.
> I assume this problem existed for a longer time but Linux 3.8 introduced
> automatic NUMA page balancing which makes the problem visible on
> multi-node hosts leading to kernel oopses.
> 
> NUMA page migration means that the physical address of a page changes.
> This is fatal if the application assumes that this never happens for
> that page as it was supposed to be pinned.
> 
> We have two kind of pinned memory:
> 
> A) 1. allocate memory in userland with mmap()
>    2. madvise(MADV_DONTFORK)
>    3. pin with get_user_pages().
>    4. flush dcache_page()
>    5. vm_flags |= (VM_DONTCOPY | VM_LOCKED)
>       (resulting flags are VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND |
>        VM_DONTCOPY | VM_LOCKED | 0xff)

I don't think this type of allocation should be affected.  The
get_user_pages() call should elevate the pages reference count which
should prevent migration from completing.  I would, however, wait for
a more definitive answer.

> B) 1. allocate memory with alloc_pages()
>    2. SetPageReserved()
>    3. vm_mmap() to allocate a userspace mapping
>    4. vm_insert_page()
>    5. vm_flags |= (VM_DONTEXPAND | VM_DONTDUMP)
>       (resulting flags are VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND | 0xff)
> 
> At least the memory allocated like B) is affected by automatic NUMA page
> migration. I'm not sure about A).
> 
> 1. How can I prevent automatic NUMA page migration on this memory?
> 2. Can NUMA page migration also be handled on such kind of memory without
>    preventing migration?
> 
> Thanks,
> 
> Frank
> -- 
> Dr.-Ing. Frank Mehnert | Software Development Director, VirtualBox
> ORACLE Deutschland B.V. & Co. KG | Werkstr. 24 | 71384 Weinstadt, Germany
> 
> Hauptverwaltung: Riesstr. 25, D-80992 München
> Registergericht: Amtsgericht München, HRA 95603
> Geschäftsführer: Jürgen Kunz
> 
> Komplementärin: ORACLE Deutschland Verwaltung B.V.
> Hertogswetering 163/167, 3543 AS Utrecht, Niederlande
> Handelsregister der Handelskammer Midden-Niederlande, Nr. 30143697
> Geschäftsführer: Alexander van der Ven, Astrid Kepper, Val Maher
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
