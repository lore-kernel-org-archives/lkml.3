Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718Ab3JOTPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:15:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57675 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab3JOTP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:15:29 -0400
MIME-Version: 1.0
Date: Tue, 15 Oct 2013 21:15:28 +0200
X-Google-Sender-Auth: WifySC2iAtJj_Y7uyviphGNgvVM
Message-ID: <CAMuHMdU_UcWfwceM_R8XcW3nv4wnAwMyBzpkUNEazf2wDSh2zQ@mail.gmail.com>
Subject: m68k discontigmem bug
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Linux/m68k" <linux-m68k@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When trying to debug kexec with a non-zero m68k_memoffset on ARAnyM, I
modified the bootinfo to remove the first 2 MiB of ST-RAM.
However, this failed with:

  | m68k_memoffset = 0x00200000
  | m68k_virt_to_node_shift = 23
  | m68k_setup_node: node = 0 (start 0x00200000 size 0x00c00000)
  |     i = 0, end = 1
  | m68k_setup_node: node = 1 (start 0x01000000 size 0x10000000)
  |     i = 1, end = 33
    overlap at 1 for chunk 1
    On node 0 totalpages: 3072
    free_area_init_node: node 0, pgdat 00371100, node_mem_map 00410800
      DMA zone: 27 pages used for memmap
      DMA zone: 0 pages reserved
      DMA zone: 3072 pages, LIFO batch:0
    kernel BUG at linux-m68k/mm/mm_init.c:138!

Apparently the value of "phys_to_virt(addr) >> __virt_to_node_shift()" is the
same for the end of the first node and the start of the second node, causing an
overlap warning to be printed, and a BUG() later.

Hence after dropping the 256 MiB of FastRAM it does work:

  | m68k_memoffset = 0x00200000
  | m68k_virt_to_node_shift = 18
  | m68k_setup_node: node = 0 (start 0x00200000 size 0x00c00000)
  |     i = 0, end = 47
    On node 0 totalpages: 3072
    free_area_init_node: node 0, pgdat 00371100, node_mem_map 003cc800
      DMA zone: 27 pages used for memmap
      DMA zone: 0 pages reserved
      DMA zone: 3072 pages, LIFO batch:0

It also works when removing the first 2 MiB of FastRAM instead, as this
sufficiently increases the start address of the second node:

  | m68k_memoffset = 0x00200000
  | m68k_virt_to_node_shift = 23
  | m68k_setup_node: node = 0 (start 0x00200000 size 0x00c00000)
  |     i = 0, end = 1
  | m68k_setup_node: node = 1 (start 0x01200000 size 0x0fe00000)
  |     i = 2, end = 33
    On node 0 totalpages: 3072
    free_area_init_node: node 0, pgdat 00371100, node_mem_map 0040f800
      DMA zone: 27 pages used for memmap
      DMA zone: 0 pages reserved
      DMA zone: 3072 pages, LIFO batch:0
    On node 1 totalpages: 65024
    free_area_init_node: node 1, pgdat 003719b8, node_mem_map 00433890
      DMA zone: 572 pages used for memmap
      DMA zone: 0 pages reserved
      DMA zone: 65024 pages, LIFO batch:15

For reference, with the standard 14 MiB of ST-RAM and 256 MiB of FastRAM,
you get:

  | m68k_memoffset = 0x00000000
  | m68k_virt_to_node_shift = 23
  | m68k_setup_node: node = 0 (start 0x00000000 size 0x00e00000)
  |     i = 0, end = 1
  | m68k_setup_node: node = 1 (start 0x01000000 size 0x10000000)
  |     i = 2, end = 33
    On node 0 totalpages: 3584
    free_area_init_node: node 0, pgdat 00371100, node_mem_map 0040c000
      DMA zone: 32 pages used for memmap
      DMA zone: 0 pages reserved
      DMA zone: 3584 pages, LIFO batch:0
    On node 1 totalpages: 65536
    free_area_init_node: node 1, pgdat 003719b8, node_mem_map 00430090
      DMA zone: 576 pages used for memmap
      DMA zone: 0 pages reserved
      DMA zone: 65536 pages, LIFO batch:15

P.S. Booting with ST-RAM starting at a non-zero address requires the
following (gmail-whitespace-damaged) patch:

--- a/arch/m68k/atari/stram.c
+++ b/arch/m68k/atari/stram.c
@@ -75,6 +75,7 @@ void __init atari_stram_init(void)
         */
        stram_start = phys_to_virt(0);
        kernel_in_stram = (stram_start == 0);
+return;

        for (i = 0; i < m68k_num_memory; ++i) {
                if (m68k_memory[i].addr == 0) {

P.S.2. There still seems to be a virt/phys mismatch in the NatFeat code too,
       as nfeth doesn't work when m68k_memoffset is non-zero.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
