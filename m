Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbbAJAun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:50:43 -0500
Received: from nupi.pair.com ([209.68.5.149]:65189 "EHLO nupi.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbbAJAum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:50:42 -0500
Message-ID: <54B0775C.1080705@flaterco.com>
Date: Fri, 09 Jan 2015 19:50:36 -0500
From: David Flater <vger@flaterco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
        Alsa Devel <alsa-devel@alsa-project.org>
Subject: [PATCHv2 1/2] ALSA: fix emu8000 DRAM sizing for AWE64 Value
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
2015-01-09  v2: In response to feedback from Takashi Iwai,
               1. Optimize for diff size.
                 1a. Use goto to avoid indenting and repeating code.
                 1b. Jettison new debugging printouts.
               2. Split printk into second patch.
            Retested on CT4390 (4 MiB) and CT4380 (512 KiB).
2015-01-08  v1 patch sent to LKML, Alsa Devel and maintainers.  Tested on
            unexpanded CT4390 (4 MiB), CT4520 (512 KiB), and CT4380 (512
            KiB).

CT4380 is commonly said to come with 1 MiB of DRAM, but Creative's AWE
Control app agreed that mine has only 512 KiB.  It has the same memory chip
as the CT4520.

The affected function first appeared in alsa-driver-0.3.0 and was merged in
linux-2.5.5.  Its somewhat different ancestor was in sound/oss/awe_wave.c.

 sound/isa/sb/emu8000.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/sound/isa/sb/emu8000.c b/sound/isa/sb/emu8000.c
index 45fcdff..3dcf80e 100644
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
@@ -392,11 +391,12 @@ size_dram(struct snd_emu8000 *emu)
 	EMU8000_SMALW_WRITE(emu, EMU8000_DRAM_OFFSET);
 	EMU8000_SMLD_WRITE(emu, UNIQUE_ID1);
 	snd_emu8000_init_fm(emu); /* This must really be here and not 2 lines back even */
+	snd_emu8000_write_wait(emu);
+
+	goto size_dram_ID1_check; /* If that fails, we have no RAM. */
 
 	while (size < EMU8000_MAX_DRAM) {
 
-		size += 512 * 1024;  /* increment 512kbytes */
-
 		/* Write a unique data on the test address.
 		 * if the address is out of range, the data is written on
 		 * 0x200000(=EMU8000_DRAM_OFFSET).  Then the id word is
@@ -424,23 +424,20 @@ size_dram(struct snd_emu8000 *emu)
 		 * wraps back to the beginning; so check to see if the
 		 * initial value has been overwritten.
 		 */
+
+	size_dram_ID1_check:
 		EMU8000_SMALR_WRITE(emu, EMU8000_DRAM_OFFSET);
 		EMU8000_SMLD_READ(emu); /* discard stale data  */
 		if (EMU8000_SMLD_READ(emu) != UNIQUE_ID1)
-			break; /* we must have wrapped around */
+			break;
 		snd_emu8000_read_wait(emu);
 
-		/* Otherwise, it's valid memory. */
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
+		/*
+		 * Otherwise, it's valid memory.  If a write succeeds at
+		 * the beginning of a 512 KiB page we assume that the whole
+		 * page is there.
+		 */
+		size += 512 * 1024;  /* increment 512 KiB */
 	}
 
 	/* wait until FULL bit in SMAxW register is false */
@@ -455,9 +452,9 @@ size_dram(struct snd_emu8000 *emu)
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
