Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaFDXXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbaFDXXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Javier Martin <javier.martin@vista-silicon.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3.10 047/103] [media] omap3isp: Defer probe when the IOMMU is not available
Date: Wed,  4 Jun 2014 16:25:10 -0700
Message-Id: <20140604232548.367880573@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 7c0f812a5d65e712618af880dda4a5cc7ed79463 upstream.

When the OMAP3 ISP driver is compiled in the kernel the device can be
probed before the corresponding IOMMU is available. Defer the probe in
that case, and fix a crash in the error path.

Reported-by: Javier Martin <javier.martin@vista-silicon.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/omap3isp/isp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2249,6 +2249,7 @@ static int isp_probe(struct platform_dev
 	ret = iommu_attach_device(isp->domain, &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't attach iommu device: %d\n", ret);
+		ret = -EPROBE_DEFER;
 		goto free_domain;
 	}
 
@@ -2287,6 +2288,7 @@ detach_dev:
 	iommu_detach_device(isp->domain, &pdev->dev);
 free_domain:
 	iommu_domain_free(isp->domain);
+	isp->domain = NULL;
 error_isp:
 	isp_xclk_cleanup(isp);
 	omap3isp_put(isp);


