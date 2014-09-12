Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaILDET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:04:19 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39170 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaILDER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:04:17 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
X-Google-Original-From: "Lee, Chun-Yi" <jlee@suse.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Takashi Iwai <tiwai@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2] Hibernate: Do not assume the first e820 area to be RAM
Date: Fri, 12 Sep 2014 11:03:58 +0800
Message-Id: <1410491038-17576-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/kernel/setup.c::trim_bios_range(), the codes introduced
by 1b5576e6 (base on d8a9e6a5), it updates the first 4Kb of memory
to be E820_RESERVED region. That's because it's a BIOS owned area
but generally not listed in the E820 table:

[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000096fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000097000-0x0000000000097fff] reserved
...
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable

But the region of first 4Kb didn't register to nosave memory:

[    0.000000] PM: Registered nosave memory: [mem 0x00097000-0x00097fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]

The codes in e820_mark_nosave_regions() assumes the first e820 area to be
RAM, so it causes the first 4Kb E820_RESERVED region ignored when register
to nosave. This patch removed assumption of the first e820 area.

v2:
To avoid the i > 0 checking in for loop. (coding suggestion from Yinghai Lu)

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/kernel/e820.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-3.12-SLE12/arch/x86/kernel/e820.c
===================================================================
--- linux-3.12-SLE12.orig/arch/x86/kernel/e820.c
+++ linux-3.12-SLE12/arch/x86/kernel/e820.c
@@ -682,15 +682,14 @@ void __init parse_e820_ext(u64 phys_addr
  * hibernation (32 bit) or software suspend and suspend to RAM (64 bit).
  *
  * This function requires the e820 map to be sorted and without any
- * overlapping entries and assumes the first e820 area to be RAM.
+ * overlapping entries.
  */
 void __init e820_mark_nosave_regions(unsigned long limit_pfn)
 {
 	int i;
-	unsigned long pfn;
+	unsigned long pfn = 0;
 
-	pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
-	for (i = 1; i < e820.nr_map; i++) {
+	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 
 		if (pfn < PFN_UP(ei->addr))
