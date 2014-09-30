Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaI3FEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 01:04:08 -0400
Received: from mail-bl2on0127.outbound.protection.outlook.com ([65.55.169.127]:21919
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752275AbaI3FED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 01:04:03 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <tglx@linutronix.de>, <daniel.lezcano@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <john.stultz@linaro.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v3 1/2] clocksource: Update to the newer memory functions.
Date: Tue, 30 Sep 2014 13:03:27 +0800
Message-ID: <1412053408-21751-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1412053408-21751-1-git-send-email-Li.Xiubo@freescale.com>
References: <1412053408-21751-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(102836001)(229853001)(106466001)(36756003)(50466002)(47776003)(64706001)(107046002)(77156001)(20776003)(19580395003)(81156004)(21056001)(105606002)(6806004)(19580405001)(44976005)(95666004)(68736004)(92726001)(69596002)(93916002)(87286001)(48376002)(50226001)(87936001)(4396001)(104166001)(97736003)(92566001)(86362001)(88136002)(84676001)(62966002)(85852003)(31966008)(104016003)(26826002)(85306004)(76176999)(50986999)(76482002)(80022003)(99396003)(89996001)(120916001)(46102003)(10300001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-Forefront-PRVS: 0350D7A55D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ioread{16,32} instead of read{w,l}_relaxed.

For read{w,l}_relaxed accessor, if one arch has its own defination,
then used it. Or will use the generic one, which will be read as LE
endian as default.

For some ARCHes, such PowerPC, if using the clocksource mmio, the
read{w,l}_relaxed will couldn't be used directly. There must be its
own BE accessor in its individual clocksource driver.

The ioread{16,32} will be read as LE endian as default if the arch
hasn't any defination of it too, like read{w,l}_relaxed do.

To prepare supporting the BE APIs and to be more unified with them,
using ioread{16,32}[be] is a good chioce here.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/mmio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
index 1593ade..d3cbf70 100644
--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -22,22 +22,22 @@ static inline struct clocksource_mmio *to_mmio_clksrc(struct clocksource *c)
 
 cycle_t clocksource_mmio_readl_up(struct clocksource *c)
 {
-	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
+	return (cycle_t)ioread32(to_mmio_clksrc(c)->reg);
 }
 
 cycle_t clocksource_mmio_readl_down(struct clocksource *c)
 {
-	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
+	return ~(cycle_t)ioread32(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 cycle_t clocksource_mmio_readw_up(struct clocksource *c)
 {
-	return (cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
+	return (cycle_t)ioread16(to_mmio_clksrc(c)->reg);
 }
 
 cycle_t clocksource_mmio_readw_down(struct clocksource *c)
 {
-	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
+	return ~(cycle_t)ioread16(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 /**
-- 
2.1.0.27.g96db324

