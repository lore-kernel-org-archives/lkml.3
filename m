Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbaGYOYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:24:20 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:53798 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752994AbaGYOYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:24:18 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, paul@pwsan.com,
        Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, arm@kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Chris Ball <chris@printf.net>, Anton Vorontsov <anton@enomsg.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 3/5] mmc: sdhci-pltfm: Do not use parent as the host's device
Date: Fri, 25 Jul 2014 15:23:51 +0100
Message-Id: <1406298233-27876-3-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code selecting a device for the sdhci host has been
continuously tweaked (4b711cb13843f5082e82970dd1e8031383134a65
"mmc: sdhci-pltfm: Add structure for host-specific data" and
a4d2177f00a5252d825236c5124bc1e9918bdb41 "mmc: sdhci-pltfm: dt
device does not pass parent to sdhci_alloc_host") while there
does not seem to be any reason to use platform device's parent
in the first place.

The comment saying "Some PCI-based MFD need the parent here"
seem to refer to Timberdale FPGA driver (the only MFD driver
registering SDHCI cell, drivers/mfd/timberdale.c) but again,
the only situation when parent device matter is runtime PM,
which is not implemented for Timberdale.

Cc: Chris Ball <chris@printf.net>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---

This patch is a part of effort to remove references to platform_bus
and make it static.

Chris, Anton, Ulf - could you please advise if the assumptions
above are correct or if I'm completely wrong? Do you know what
where the real reasons to use parent originally? The PCI comment
seems like a red herring to me...

 drivers/mmc/host/sdhci-pltfm.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 7e834fb..4996112 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -136,13 +136,8 @@ struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
 	if (resource_size(iomem) < 0x100)
 		dev_err(&pdev->dev, "Invalid iomem size!\n");
 
-	/* Some PCI-based MFD need the parent here */
-	if (pdev->dev.parent != &platform_bus && !np)
-		host = sdhci_alloc_host(pdev->dev.parent,
-			sizeof(struct sdhci_pltfm_host) + priv_size);
-	else
-		host = sdhci_alloc_host(&pdev->dev,
-			sizeof(struct sdhci_pltfm_host) + priv_size);
+	host = sdhci_alloc_host(&pdev->dev,
+		sizeof(struct sdhci_pltfm_host) + priv_size);
 
 	if (IS_ERR(host)) {
 		ret = PTR_ERR(host);
-- 
1.9.1

