Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbaIPBiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:38:07 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:3459 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbaIPBiF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:38:05 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-msm@vger.kernel.org'" <linux-arm-msm@vger.kernel.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Date: Tue, 16 Sep 2014 09:34:49 +0800
Subject: [RFC v3] arm:extend the reserved mrmory for initrd to be page
 aligned
Thread-Topic: [RFC v3] arm:extend the reserved mrmory for initrd to be page
 aligned
Thread-Index: Ac/RTmegzKLfxnudTH+lcS457OIJMg==
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB49160A@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch extend the start and end address of initrd to be page aligned,
so that we can free all memory including the un-page aligned head or tail
page of initrd, if the start or end address of initrd are not page
aligned, the page can't be freed by free_initrd_mem() function.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 arch/arm/mm/init.c   | 5 +++++
 arch/arm64/mm/init.c | 8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 659c75d..9221645 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -636,6 +636,11 @@ static int keep_initrd;
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (!keep_initrd) {
+		if (start == initrd_start)
+			start = round_down(start, PAGE_SIZE);
+		if (end == initrd_end)
+			end = round_up(end, PAGE_SIZE);
+
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
 		free_reserved_area((void *)start, (void *)end, -1, "initrd");
 	}
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 5472c24..c5512f6 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -334,8 +334,14 @@ static int keep_initrd;
 
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (!keep_initrd)
+	if (!keep_initrd) {
+		if (start == initrd_start)
+			start = round_down(start, PAGE_SIZE);
+		if (end == initrd_end)
+			end = round_up(end, PAGE_SIZE);
+
 		free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	}
 }
 
 static int __init keepinitrd_setup(char *__unused)
-- 
2.1.0
