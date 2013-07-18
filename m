Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3GRHsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:48:45 -0400
Received: from mo5.mail-out.ovh.net ([178.32.228.5]:47126 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3GRHso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:48:44 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: [PATCH v4 5/5] ASoC: atmel-ssc: remove clk_disable_unprepare call from critical section
Date: Thu, 18 Jul 2013 09:48:40 +0200
Message-Id: <1374133720-27362-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com>
References: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11369900209700894828
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_prepare/unprepare (and indirectly clk_prepare_enable/disable_unprepare)
may sleep and thus cannot be called in critical section.

This patch fix a bug introduced by commit
6f0d94790efe9f4481bbd7c174ef0e9b5e5db7c4 where clk_disable_unprepare was
called with user_lock hold.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/misc/atmel-ssc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index f7b90661..e068a76 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -66,14 +66,19 @@ EXPORT_SYMBOL(ssc_request);
 
 void ssc_free(struct ssc_device *ssc)
 {
+	bool disable_clk = true;
+
 	spin_lock(&user_lock);
-	if (ssc->user) {
+	if (ssc->user)
 		ssc->user--;
-		clk_disable_unprepare(ssc->clk);
-	} else {
+	else {
+		disable_clk = false;
 		dev_dbg(&ssc->pdev->dev, "device already free\n");
 	}
 	spin_unlock(&user_lock);
+
+	if (disable_clk)
+		clk_disable_unprepare(ssc->clk);
 }
 EXPORT_SYMBOL(ssc_free);
 
-- 
1.7.9.5

