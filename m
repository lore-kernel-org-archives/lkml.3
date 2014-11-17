Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaKQO5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:57:33 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:58864 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaKQO5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:57:31 -0500
MIME-Version: 1.0
Date: Mon, 17 Nov 2014 22:57:30 +0800
Message-ID: <CAHkaATRnQtn+yu3aScsL-E-EYBTmZ7xSzWOQ7Z6pj0VYwGM+iA@mail.gmail.com>
Subject: Does kernel assume PHYS_OFFSET must be SECTION_SIZE aligned?
From: Min-Hua Chen <orca.chen@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a problem about kernel_x_start and kernel_x_end in map_lowmem.
If the start address of DRAM is 0x20000000 and PHYS_OFFSET is 0x20100000 (1MB)
and _start is 0xc0008000 and SECTION_SIZE is 0x200000 (2MB).
Let's say the memory between 0x20000000 and 0x20100000 is used by some H/W,
and not available for kernel.

According to current implementation:

unsigned long kernel_x_start = round_down(__pa(_stext), SECTION_SIZE);
unsigned long kernel_x_end = round_up(__pa(__init_end), SECTION_SIZE);

Than we'll get kernel_x_start = round_down(__pa(0xc0008000), SECTION_SIZE)
                  = round_down(0x20008000, SECTION_SIZE)
                  = 0x20000000

In this case, 0x20000000 is not available for kernel memory.

Does kernel assume PHYS_OFFSET must be SECTION_SIZE aligned or we
should get kernel_x_start by rounding down _start first then convert
the virtual address to physical address.

phys_addr_t kernel_x_start = __pa(round_down(_stext, SECTION_SIZE));
phys_addr_t kernel_x_end = __pa(round_up(__init_end, SECTION_SIZE));

get kernel_x_start = __pa(round_down(0xc0008000, SECTION_SIZE))
           = __pa(round_down(0xc0008000, SECTION_SIZE))
           = __pa(0xc0000000)
           = 0x20100000

thanks,
Min-Hua
