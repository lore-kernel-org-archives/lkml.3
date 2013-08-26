Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3HZMVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:21:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab3HZMVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:21:03 -0400
Message-ID: <521B482A.80908@redhat.com>
Date: Mon, 26 Aug 2013 14:20:58 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?Big5?B?tsCyTbap?= <ching2048@areca.com.tw>
CC: james.bottomley@hansenpartnership.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, billion@areca.com.tw
Subject: Re: [PATCH 1/3] arcmsr: Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284
References: <7A2818CC441F4BCE96D3B1E70CC3D76B@chingDT>
In-Reply-To: <7A2818CC441F4BCE96D3B1E70CC3D76B@chingDT>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 06:14 AM, ¶À²M¶© wrote:
>  From: Ching <ching2048@areca.com.tw>
>
> Support Areca new SATA Raid adapter ARC1214/1224/1264/1284.
> Modify maximum outstanding command number, notify command complete with auto
> request sense
> Signed-off-by: Ching  <ching2048@areca.com.tw>

Hi Ching,
+static bool
+arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)
+{
...
+	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
+	&dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent) {
+		pr_notice("DMA allocation failed...\n");
+		return -ENOMEM;
You've declared the return value as a bool so the function should return false or true.
---------------------------------------
In arcmsr_alloc_ccb_pool
-	roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) + (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
-	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
-	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
-	if(!dma_coherent){
-		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n", acb->host->host_no);
-		return -ENOMEM;
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		roundup_ccbsize =
+		roundup(sizeof(struct CommandControlBlock) +
+		max_sg_entrys * sizeof(struct SG64ENTRY), 32);
+		acb->uncache_size = roundup_ccbsize *
+			ARCMSR_MAX_FREECCB_NUM;
+		dma_coherent = dma_alloc_coherent(&pdev->dev,
+			acb->uncache_size, &dma_coherent_handle,
+			GFP_KERNEL);
...
+	case ACB_ADAPTER_TYPE_B: {
+		roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
+			(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+		acb->uncache_size = roundup_ccbsize *
+			ARCMSR_MAX_FREECCB_NUM;
+		dma_coherent = dma_alloc_coherent(&pdev->dev,
+			acb->uncache_size, &dma_coherent_handle,
+			GFP_KERNEL);
You've added a switch with  four almost identical
cases, what is the point of splitting the code this way?
-----------------------------------------
 struct AdapterControlBlock
+	void *dma_coherent;
+	dma_addr_t dma_coherent_handle;
+	dma_addr_t dma_coherent_handle2;
+	void *dma_coherent2;
why do you need these pairs? Is there an adapter which uses both
for example dma_coherent and dma_coherent2 at the same time?

Please include the patch into the message body next time, it makes the review easier.
Thanks, Tomas 
 

