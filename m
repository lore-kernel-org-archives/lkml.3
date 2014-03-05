Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbaCECba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:31:30 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34188 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaCECb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:31:28 -0500
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: Re: [PATCH] IOMMU: iommu module do not check NULL return of kmem_cache_zalloc
Date: Wed,  5 Mar 2014 10:31:17 +0800
Message-Id: <1393986677-22160-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

On Tue, 4 Mar 2014 16:41:18 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> On Tue, Feb 11, 2014 at 10:12:53AM +0800, Zhouyi Zhou wrote:
> > From: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> > 
> > The function iopte_alloc do not check NULL return of kmem_cache_zalloc,
> > call iopte_free with argument 0 will panic.
> > 
> > Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> > ---
> >  drivers/iommu/omap-iommu.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> > index bcd78a7..5155714 100644
> > --- a/drivers/iommu/omap-iommu.c
> > +++ b/drivers/iommu/omap-iommu.c
> > @@ -551,7 +551,8 @@ static u32 *iopte_alloc(struct omap_iommu *obj, u32 *iopgd, u32 da)
> >    	      dev_vdbg(obj->dev, "%s: a new pte:%p\n", __func__, iopte);
> >  	      } else {
> >  	      	/* We raced, free the reduniovant table */
> > -		   iopte_free(iopte);
> > +			if (iopte)
> > +				iopte_free(iopte);
> 
> Isn't it better to put the check into iopte_free?
> 
> 
>	Joerg
> 
> 
Thanks Joerg for reviewing
Checking the null pointer in iopte_free guarantees kmem_cache_free
is happy all the time.

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Signed-off-by: Joerg Roedel <joro@8bytes.org>

---
 drivers/iommu/omap-iommu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bcd78a7..51211e8 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -523,7 +523,8 @@ static void flush_iopte_range(u32 *first, u32 *last)
 static void iopte_free(u32 *iopte)
 {
 	/* Note: freed iopte's must be clean ready for re-use */
-	kmem_cache_free(iopte_cachep, iopte);
+	if (iopte)
+		kmem_cache_free(iopte_cachep, iopte);
 }
 
 static u32 *iopte_alloc(struct omap_iommu *obj, u32 *iopgd, u32 da)


