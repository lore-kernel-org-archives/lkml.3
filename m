Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaHLJhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:37:48 -0400
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:34196 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755055AbaHLJhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:37:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:4321:5007:6248:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13255:13311:13357:13972:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rule
X-HE-Tag: road94_265ff55945c39
X-Filterd-Recvd-Size: 2374
Message-ID: <1407836262.3141.16.camel@joe-AO725>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post
 Queue (RDPQ) Array support
From: Joe Perches <joe@perches.com>
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, linux-scsi@vger.kernel.org,
        JBottomley@Parallels.com, Sathya.Prakash@avagotech.com,
        Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org,
        hch@infradead.org
Date: Tue, 12 Aug 2014 02:37:42 -0700
In-Reply-To: <1407835482-37919-1-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1407835482-37919-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-12 at 14:54 +0530, Sreekanth Reddy wrote:
> So, the proposal is to allocate memory independently for each
> Reply Queue and pass down all of the addresses to the firmware.
> Then the firmware will just take each address and program the value
> into the correct register.

trivial note:

> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
[]
> @@ -1179,17 +1184,22 @@ static int
>  _base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
>  {
>  	struct sysinfo s;
> -	char *desc = NULL;
> +	u64 consistent_dma_mask;
> +
> +	if (dma_mask)
> +		consistent_dma_mask = DMA_BIT_MASK(64);
> +	else
> +		consistent_dma_mask = DMA_BIT_MASK(32);
>  
>  	if (sizeof(dma_addr_t) > 4) {
>  		const uint64_t required_mask =
>  		    dma_get_required_mask(&pdev->dev);
>  		if ((required_mask > DMA_BIT_MASK(32)) && !pci_set_dma_mask(pdev,
>  		    DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(pdev,
> -		    DMA_BIT_MASK(64))) {
> +		    consistent_dma_mask)) {

This would be easier to read if the embedded functions
within the if were on separate lines like:

		if ((required_mask > DMA_BIT_MASK(32)) &&
		    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
		    !pci_set_consistent_dma_mask(pdev, consistent_dma_mask)) {


