Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbbAMNXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:23:23 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:62123 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbAMNXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:23:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kernel-build-reports@lists.linaro.org
Cc: Mark Brown <broonie@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Vinod Koul <vinod.koul@intel.com>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] dmaengine: k3: fix duplicate function definition
Date: Tue, 13 Jan 2015 14:23:13 +0100
Message-ID: <1869934.MKKaD1UAQn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150113120751.GQ4160@sirena.org.uk>
References: <E1YAwSG-0000zm-Cs@debutante> <20150113120751.GQ4160@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:YHFDLXFU+JWS25PLRizIw7J5PcaJBjCNTafPE1BYu8vYCOMxsca
 56ifFg8lneikXuz2kqIu8uSBbNkJZ+9B9d7k9cE+DyRReLJ8uA8I7MhuqN3ZmH/VLAxFx6m
 sLYy0/l4Nn7eweRwnGJzM35AX8Uo93dYpX4WXLCO6UuU5OZiZwZjVasQQf0agY6b/1mwL47
 hGHcPzX3OxD68riW4c9nw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit db08425ebd51f ("dmaengine: k3: Split device_control") introduced
two new helper functions, which unfortunately have the same names
as the existing suspend/resume functions, resulting in a build error
when CONFIG_PM_SLEEP is enabled:

drivers/dma/k3dma.c:823:12: error: conflicting types for 'k3_dma_resume'
 static int k3_dma_resume(struct device *dev)
            ^
drivers/dma/k3dma.c:625:12: note: previous definition of 'k3_dma_resume' was here
 static int k3_dma_resume(struct dma_chan *chan)
            ^

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: db08425ebd51f ("dmaengine: k3: Split device_control")

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index 49be7f687c4c..8cc61ae42f42 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -804,7 +804,7 @@ static int k3_dma_remove(struct platform_device *op)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int k3_dma_suspend(struct device *dev)
+static int k3_dma_suspend_dev(struct device *dev)
 {
 	struct k3_dma_dev *d = dev_get_drvdata(dev);
 	u32 stat = 0;
@@ -820,7 +820,7 @@ static int k3_dma_suspend(struct device *dev)
 	return 0;
 }
 
-static int k3_dma_resume(struct device *dev)
+static int k3_dma_resume_dev(struct device *dev)
 {
 	struct k3_dma_dev *d = dev_get_drvdata(dev);
 	int ret = 0;
@@ -835,7 +835,7 @@ static int k3_dma_resume(struct device *dev)
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(k3_dma_pmops, k3_dma_suspend, k3_dma_resume);
+static SIMPLE_DEV_PM_OPS(k3_dma_pmops, k3_dma_suspend_dev, k3_dma_resume_dev);
 
 static struct platform_driver k3_pdma_driver = {
 	.driver		= {

