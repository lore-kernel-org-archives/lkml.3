Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3EWX0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 19:26:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab3EWX0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 19:26:34 -0400
Date: Thu, 23 May 2013 16:26:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msm: iommu: fix leak and invalid access
Message-Id: <20130523162632.8a51569b776134b2db32a64e@linux-foundation.org>
In-Reply-To: <51931347.7020600@huawei.com>
References: <51931347.7020600@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013 12:47:03 +0800 Libo Chen <clbchenlibo.chen@huawei.com> wrote:

> It fixes two obvious problems:
> 1. We have registered msm_iommu_driver first, and need unregister it when
> registered msm_iommu_ctx_driver fail

yup, that's a bug.

> 2. We don`t need to kfree drvdata before kzalloc successful

The code's OK at present - kfree(NULL) is legal.

However I suppose the patch cleans things up a little bit, however it
missed a couple of things:



From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-iommu-msm_iommu_devc-fix-leak-and-invalid-access-fix

remove now-unneeded initialization of ctx_drvdata, remove unneeded braces

Cc: David Brown <davidb@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: Libo Chen <libo.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/msm_iommu_dev.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-invalid-access-fix drivers/iommu/msm_iommu_dev.c
--- a/drivers/iommu/msm_iommu_dev.c~drivers-iommu-msm_iommu_devc-fix-leak-and-invalid-access-fix
+++ a/drivers/iommu/msm_iommu_dev.c
@@ -289,22 +289,19 @@ static int msm_iommu_ctx_probe(struct pl
 {
 	struct msm_iommu_ctx_dev *c = pdev->dev.platform_data;
 	struct msm_iommu_drvdata *drvdata;
-	struct msm_iommu_ctx_drvdata *ctx_drvdata = NULL;
+	struct msm_iommu_ctx_drvdata *ctx_drvdata;
 	int i, ret;
-	if (!c || !pdev->dev.parent) {
+
+	if (!c || !pdev->dev.parent)
 		return -EINVAL;
-	}
 
 	drvdata = dev_get_drvdata(pdev->dev.parent);
-
-	if (!drvdata) {
+	if (!drvdata)
 		return -ENODEV;
-	}
 
 	ctx_drvdata = kzalloc(sizeof(*ctx_drvdata), GFP_KERNEL);
-	if (!ctx_drvdata) {
+	if (!ctx_drvdata)
 		return -ENOMEM;
-	}
 
 	ctx_drvdata->num = c->num;
 	ctx_drvdata->pdev = pdev;
_

