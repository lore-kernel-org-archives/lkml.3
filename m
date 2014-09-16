Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaIPK5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:57:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaIPK5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:57:09 -0400
Date: Tue, 16 Sep 2014 03:56:30 -0700
From: "tip-bot for Lee, Chun-Yi" <tipbot@zytor.com>
Message-ID: <tip-84779575554e2a19b9f6fc8d44f9763546a822ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org, tiwai@suse.de,
        pavel@ucw.cz, jlee@suse.com, joeyli.kernel@gmail.com,
        tglx@linutronix.de, rjw@rjwysocki.net, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org, tiwai@suse.de,
        pavel@ucw.cz, jlee@suse.com, joeyli.kernel@gmail.com,
        rjw@rjwysocki.net, tglx@linutronix.de, len.brown@intel.com
In-Reply-To: <1410491038-17576-1-git-send-email-jlee@suse.com>
References: <1410491038-17576-1-git-send-email-jlee@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm, hibernate:
  Do not assume the first e820 area to be RAM
Git-Commit-ID: 84779575554e2a19b9f6fc8d44f9763546a822ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84779575554e2a19b9f6fc8d44f9763546a822ad
Gitweb:     http://git.kernel.org/tip/84779575554e2a19b9f6fc8d44f9763546a822ad
Author:     Lee, Chun-Yi <joeyli.kernel@gmail.com>
AuthorDate: Fri, 12 Sep 2014 11:03:58 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Sep 2014 09:54:31 +0200

x86/mm, hibernate: Do not assume the first e820 area to be RAM

In arch/x86/kernel/setup.c::trim_bios_range(), the codes
introduced by 1b5576e6 (base on d8a9e6a5), it updates the first
4Kb of memory to be E820_RESERVED region. That's because it's a
BIOS owned area but generally not listed in the E820 table:

  e820: BIOS-provided physical RAM map:
  BIOS-e820: [mem 0x0000000000000000-0x0000000000096fff] usable
  BIOS-e820: [mem 0x0000000000097000-0x0000000000097fff] reserved
  ...
  e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
  e820: remove [mem 0x000a0000-0x000fffff] usable

But the region of first 4Kb didn't register to nosave memory:

  PM: Registered nosave memory: [mem 0x00097000-0x00097fff]
  PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]

The code in e820_mark_nosave_regions() assumes the first e820
area to be RAM, so it causes the first 4Kb E820_RESERVED region
ignored when register to nosave. This patch removed assumption
of the first e820 area.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Link: http://lkml.kernel.org/r/1410491038-17576-1-git-send-email-jlee@suse.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/e820.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 988c00a..49f8864 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -682,15 +682,14 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
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
