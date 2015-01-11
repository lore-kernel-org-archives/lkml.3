Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbbAKVJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:09:07 -0500
Received: from nupi.pair.com ([209.68.5.149]:63032 "EHLO nupi.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbbAKVJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:09:04 -0500
Message-ID: <54B2E66A.7060907@flaterco.com>
Date: Sun, 11 Jan 2015 16:08:58 -0500
From: David Flater <vger@flaterco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
        Alsa Devel <alsa-devel@alsa-project.org>
Subject: [PATCHv3 1/2] ALSA: fix emu8000 DRAM sizing for AWE64 Value
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applicable to any kernel since 2013:

The special case added in commit 1338fc97d07a did not handle the possibility
that the address space on an AWE64 Value would wrap around at 512 KiB.  That
is what it does, so the memory is still not detected on those cards.

Fix that with a logic clean-up that eliminates the need for a special case.

Signed-off-by: David Flater <dave@flaterco.com>
---
History:
2015-01-11  v3: In response to feedback from Takashi Iwai,
              Patch 1: Repeat code to avoid goto middle of loop.
              Patch 2: Use pr_info not printk.
            Retested on CT4390 (4 MiB) and CT4380 (512 KiB).
2015-01-09  v2: In response to feedback from Takashi Iwai,
               1. Optimize for diff size.
                 1a. Use goto to avoid indenting and repeating code.
                 1b. Jettison new debugging printouts.
               2. Split printk into second patch.
            Retested on CT4390 (4 MiB) and CT4380 (512 KiB).
2015-01-08  v1 patch sent to LKML, Alsa Devel and maintainers.  Tested on
            unexpanded CT4390 (4 MiB), CT4520 (512 KiB), and CT4380 (512
            KiB).

 sound/isa/sb/emu8000.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/sound/isa/sb/emu8000.c b/sound/isa/sb/emu8000.c
index 45fcdff..d25e384 100644
--- a/sound/isa/sb/emu8000.c
+++ b/sound/isa/sb/emu8000.c
@@ -378,13 +378,12 @@ init_arrays(struct snd_emu8000 *emu)
 static void
 size_dram(struct snd_emu8000 *emu)
 {
-	int i, size, detected_size;
+	int i, size;
 
 	if (emu->dram_checked)
 		return;
 
 	size = 0;
-	detected_size = 0;
 
 	/* write out a magic number */
 	snd_emu8000_dma_chan(emu, 0, EMU8000_RAM_WRITE);
@@ -392,10 +391,19 @@ size_dram(struct snd_emu8000 *emu)
 	EMU8000_SMALW_WRITE(emu, EMU8000_DRAM_OFFSET);
 	EMU8000_SMLD_WRITE(emu, UNIQUE_ID1);
 	snd_emu8000_init_fm(emu); /* This must really be here and not 2 lines back even */
+	snd_emu8000_write_wait(emu);
 
-	while (size < EMU8000_MAX_DRAM) {
+	/*
+	 * Detect first 512 KiB.  If a write succeeds at the beginning of a
+	 * 512 KiB page we assume that the whole page is there.
+	 */
+	EMU8000_SMALR_WRITE(emu, EMU8000_DRAM_OFFSET);
+	EMU8000_SMLD_READ(emu); /* discard stale data  */
+	if (EMU8000_SMLD_READ(emu) != UNIQUE_ID1)
+		goto skip_detect;   /* No RAM */
+	snd_emu8000_read_wait(emu);
 
-		size += 512 * 1024;  /* increment 512kbytes */
+	for (size = 512 * 1024; size < EMU8000_MAX_DRAM; size += 512 * 1024) {
 
 		/* Write a unique data on the test address.
 		 * if the address is out of range, the data is written on
@@ -431,18 +439,9 @@ size_dram(struct snd_emu8000 *emu)
 		snd_emu8000_read_wait(emu);
 
 		/* Otherwise, it's valid memory. */
-		detected_size = size + 512 * 1024;
-	}
-
-	/* Distinguish 512 KiB from 0. */
-	if (detected_size == 0) {
-		snd_emu8000_read_wait(emu);
-		EMU8000_SMALR_WRITE(emu, EMU8000_DRAM_OFFSET);
-		EMU8000_SMLD_READ(emu); /* discard stale data  */
-		if (EMU8000_SMLD_READ(emu) == UNIQUE_ID1)
-			detected_size = 512 * 1024;
 	}
 
+skip_detect:
 	/* wait until FULL bit in SMAxW register is false */
 	for (i = 0; i < 10000; i++) {
 		if ((EMU8000_SMALW_READ(emu) & 0x80000000) == 0)
@@ -455,9 +454,9 @@ size_dram(struct snd_emu8000 *emu)
 	snd_emu8000_dma_chan(emu, 1, EMU8000_RAM_CLOSE);
 
 	snd_printdd("EMU8000 [0x%lx]: %d Kb on-board memory detected\n",
-		    emu->port1, detected_size/1024);
+		    emu->port1, size/1024);
 
-	emu->mem_size = detected_size;
+	emu->mem_size = size;
 	emu->dram_checked = 1;
 }
 
-- 
1.8.4
