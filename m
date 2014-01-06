Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaAFSrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:47:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33735 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaAFSrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:47:48 -0500
Date: Mon, 6 Jan 2014 13:46:42 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swiotlb: Don't DoS us with 'swiotlb buffer is full'
Message-ID: <20140106184642.GA29781@phenom.dumpdata.com>
References: <1388505254-2986-1-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1401031334240.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401031334240.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 01:35:52PM +0000, Stefano Stabellini wrote:
> On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > There is no need for that so lets use ratelimiting.
> > Also add some extra information to be helpful.
> > 
> > CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> lib/swiotlb.c: In function 'swiotlb_tbl_map_single':
> lib/swiotlb.c:509:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'size_t' [-Wformat=]
> 

How about this:

>From c83a2ab5d5fbc502b4165262a2983c2ad646f061 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 16 Dec 2013 14:05:01 -0500
Subject: [PATCH] swiotlb: Don't DoS us with 'swiotlb buffer is full' (v2)

There is no need for that so lets use ratelimiting.
Also add some extra information to be helpful.

CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
[v2: s/ld/zs on the printk]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e4399fa..4634ac9 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -505,7 +505,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 
 not_found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
-	dev_warn(hwdev, "swiotlb buffer is full\n");
+	if (printk_ratelimit())
+		dev_warn(hwdev, "swiotlb buffer is full (sz: %zd bytes)\n", size);
 	return SWIOTLB_MAP_ERROR;
 found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
-- 
1.8.3.1

