Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043Ab3FDHWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:22:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42297 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355Ab3FDHWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:22:15 -0400
From: Frank Mehnert <frank.mehnert@oracle.com>
Organization: Oracle Corporation
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Handling NUMA page migration
Date: Tue, 4 Jun 2013 09:22:10 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.4; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201306040922.10235.frank.mehnert@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

our memory management on Linux hosts conflicts with NUMA page migration.
I assume this problem existed for a longer time but Linux 3.8 introduced
automatic NUMA page balancing which makes the problem visible on
multi-node hosts leading to kernel oopses.

NUMA page migration means that the physical address of a page changes.
This is fatal if the application assumes that this never happens for
that page as it was supposed to be pinned.

We have two kind of pinned memory:

A) 1. allocate memory in userland with mmap()
   2. madvise(MADV_DONTFORK)
   3. pin with get_user_pages().
   4. flush dcache_page()
   5. vm_flags |= (VM_DONTCOPY | VM_LOCKED)
      (resulting flags are VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND |
       VM_DONTCOPY | VM_LOCKED | 0xff)

B) 1. allocate memory with alloc_pages()
   2. SetPageReserved()
   3. vm_mmap() to allocate a userspace mapping
   4. vm_insert_page()
   5. vm_flags |= (VM_DONTEXPAND | VM_DONTDUMP)
      (resulting flags are VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND | 0xff)

At least the memory allocated like B) is affected by automatic NUMA page
migration. I'm not sure about A).

1. How can I prevent automatic NUMA page migration on this memory?
2. Can NUMA page migration also be handled on such kind of memory without
   preventing migration?

Thanks,

Frank
-- 
Dr.-Ing. Frank Mehnert | Software Development Director, VirtualBox
ORACLE Deutschland B.V. & Co. KG | Werkstr. 24 | 71384 Weinstadt, Germany

Hauptverwaltung: Riesstr. 25, D-80992 München
Registergericht: Amtsgericht München, HRA 95603
Geschäftsführer: Jürgen Kunz

Komplementärin: ORACLE Deutschland Verwaltung B.V.
Hertogswetering 163/167, 3543 AS Utrecht, Niederlande
Handelsregister der Handelskammer Midden-Niederlande, Nr. 30143697
Geschäftsführer: Alexander van der Ven, Astrid Kepper, Val Maher
