Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaIZGWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:22:31 -0400
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:31684
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753417AbaIZGW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:22:29 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2] clocksource: Add BE APIs support for clocksource counter reading.
Date: Fri, 26 Sep 2014 14:22:09 +0800
Message-ID: <1411712529-35293-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(83322001)(76482002)(575784001)(92726001)(92566001)(19580395003)(86362001)(31966008)(19580405001)(4396001)(69596002)(105606002)(44976005)(93916002)(20776003)(104166001)(6806004)(50226001)(84676001)(85852003)(120916001)(10300001)(74502003)(47776003)(81342003)(80022003)(85306004)(77982003)(95666004)(106466001)(46102003)(87936001)(74662003)(89996001)(88136002)(81542003)(64706001)(68736004)(79102003)(81156004)(83072002)(107046002)(87286001)(99396003)(21056001)(104016003)(36756003)(62966002)(90102001)(102836001)(77156001)(50986999)(48376002)(229853001)(50466002)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0622;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0622;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---

Hi Daniel, Thomas

For now I just added  _be() support using ioread{16,32}be.
And i have a check of the clocksource drivers, didn't find anyone
using LE mode on one BE SoC, so _le() APIs is not needed.


For V2:
- Using ioread{16,32}[be]() instead of readl_relaxed().
- Add clocksource_mmio_readX_Y_be() supports only.

 drivers/clocksource/mmio.c  | 28 ++++++++++++++++++++++++----
 include/linux/clocksource.h |  4 ++++
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
index 1593ade..d35a407 100644
--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -20,24 +20,44 @@ static inline struct clocksource_mmio *to_mmio_clksrc(struct clocksource *c)
 	return container_of(c, struct clocksource_mmio, clksrc);
 }
 
+cycle_t clocksource_mmio_readl_up_be(struct clocksource *c)
+{
+	return (cycle_t)ioread32be(to_mmio_clksrc(c)->reg);
+}
+
 cycle_t clocksource_mmio_readl_up(struct clocksource *c)
 {
-	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
+	return (cycle_t)ioread32(to_mmio_clksrc(c)->reg);
+}
+
+cycle_t clocksource_mmio_readl_down_be(struct clocksource *c)
+{
+	return ~(cycle_t)ioread32be(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 cycle_t clocksource_mmio_readl_down(struct clocksource *c)
 {
-	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
+	return ~(cycle_t)ioread32(to_mmio_clksrc(c)->reg) & c->mask;
+}
+
+cycle_t clocksource_mmio_readw_up_be(struct clocksource *c)
+{
+	return (cycle_t)ioread16be(to_mmio_clksrc(c)->reg);
 }
 
 cycle_t clocksource_mmio_readw_up(struct clocksource *c)
 {
-	return (cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
+	return (cycle_t)ioread16(to_mmio_clksrc(c)->reg);
+}
+
+cycle_t clocksource_mmio_readw_down_be(struct clocksource *c)
+{
+	return ~(cycle_t)ioread16be(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 cycle_t clocksource_mmio_readw_down(struct clocksource *c)
 {
-	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
+	return ~(cycle_t)ioread16(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 /**
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 653f0e2..931a037 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -327,9 +327,13 @@ static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
 
 extern int timekeeping_notify(struct clocksource *clock);
 
+extern cycle_t clocksource_mmio_readl_up_be(struct clocksource *);
 extern cycle_t clocksource_mmio_readl_up(struct clocksource *);
+extern cycle_t clocksource_mmio_readl_down_be(struct clocksource *);
 extern cycle_t clocksource_mmio_readl_down(struct clocksource *);
+extern cycle_t clocksource_mmio_readw_up_be(struct clocksource *);
 extern cycle_t clocksource_mmio_readw_up(struct clocksource *);
+extern cycle_t clocksource_mmio_readw_down_be(struct clocksource *);
 extern cycle_t clocksource_mmio_readw_down(struct clocksource *);
 
 extern int clocksource_mmio_init(void __iomem *, const char *,
-- 
2.1.0.27.g96db324

