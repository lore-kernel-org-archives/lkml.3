Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaISHJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 03:09:54 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:15836 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbaISHJw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 03:09:52 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-msm@vger.kernel.org'" <linux-arm-msm@vger.kernel.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?=27Uwe_Kleine-K=F6nig=27?= 
	<u.kleine-koenig@pengutronix.de>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>
CC: DL-WW-ContributionOfficers-Linux 
	<DL-WW-ContributionOfficers-Linux@sonymobile.com>
Date: Fri, 19 Sep 2014 15:09:47 +0800
Subject: [PATCH resend] arm:extend the reserved memory for initrd to be page
 aligned
Thread-Topic: [PATCH resend] arm:extend the reserved memory for initrd to be
 page aligned
Thread-Index: Ac/T2LIW6UBWTbUISxiu6PxPXS6bZw==
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB49161F@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
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
