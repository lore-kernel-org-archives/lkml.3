Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3BDGYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:24:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45502 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3BDGYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:24:48 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 0/4] kdump: make saved_max_pfn exlusive
To: ralf@linux-mips.org, michael@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, vgoyal@in.ibm.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Feb 2013 15:24:45 +0900
Message-ID: <20130204062349.13161.29478.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, there are two kinds of notation to represent a map: inclusive
and exclusive. Here are the examples:
    
  1)  [mem 0x0000000100000000-0x000000013fffffff]
  2)  [mem 0x0000000100000000-0x0000000140000000]
    
1) is inclusive and 2) is exclusive. In case of 1), the pfn calculated
from the end address belongs to the map, while in case of 2), it
doesn't.

Currently, saved_max_pfn is used in read_oldmem() as inclusive for a
check to see if a given request is to within kernel's memory mapping
regions.
    
	while (count) {
		pfn = *ppos / PAGE_SIZE;
		if (pfn > saved_max_pfn)
		   	return read;
    
Unfortunately, on x86 and ia64, there are bugs below:
    
- On the 1st kernel, saved_max_pfn is not initialized so 0. Then, read
  to pfn 0 is not guarded by the condition and the execution goes into
  ioremap path.
    
- On the 2nd kernel, x86 and ia64 wrongly initializes saved_max_pfn by
  exclusive value, on x86 as:
    
	saved_max_pfn = e820_end_of_ram_pfn();
    
  by which via /dev/oldmem we can read max_pfn that is not kernel's
  memory.
    
To fix this, fixing x86 and ia64 part needs smaller change, but
max_pfn is originally treated as exclusive so saved_max_pfn should
normally be exclusive. Also, the memory map information passed from
kexec is all exclusive on every architectures; it's possible to make
saved_max_pfn exclusive now.

However, ppc and ppc64 on kexec doesn't increment end address now and
this should be done as an insurance when map passed from firmware is
inclusive, for which I'll post a patch later.

---

HATAYAMA Daisuke (4):
      kdump, oldmem: compare with saved_max_pfn exclusively
      kdump, s390: make saved_max_pfn exclusive
      kdump, ppc: make saved_max_pfn exclusive
      kdump, mips: make saved_max_pfn exclusive


 arch/mips/kernel/crash_dump.c    |    2 +-
 arch/powerpc/kernel/crash_dump.c |    2 +-
 arch/s390/kernel/setup.c         |    4 ++--
 drivers/char/mem.c               |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

-- 

Thanks.
HATAYAMA, Daisuke
