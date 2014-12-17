Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaLQSwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:52:49 -0500
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:46429 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751323AbaLQSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:52:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:4321:5007:6261:7974:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13255:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ocean32_34a429a6cb02d
X-Filterd-Recvd-Size: 3440
Message-ID: <1418842360.14140.29.camel@perches.com>
Subject: Re: [PATCH 1/1] [SCSI] mpt2sas: Convert non-returned local variable
 to boolean when relevant
From: Joe Perches <joe@perches.com>
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 17 Dec 2014 10:52:40 -0800
In-Reply-To: <20141217145618.GA2812@sloth>
References: <20141217145618.GA2812@sloth>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 15:56 +0100, Quentin Lambert wrote:
> This patch was produced using Coccinelle. A simplified version of the
> semantic patch is:

[...]

Interesting.

Some of these conversions show what I think is
relatively poor logic.  For instance:

> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
[]
> @@ -1414,10 +1414,10 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
>  	struct msix_entry *entries, *a;
>  	int r;
>  	int i;
> -	u8 try_msix = 0;
> +	bool try_msix = false;
>  
>  	if (msix_disable == -1 || msix_disable == 0)
> -		try_msix = 1;
> +		try_msix = true;
>  
>  	if (!try_msix)
>  		goto try_ioapic;

This might as well remove the try_msix variable
and become:

	if (msix_disable != -1 && msix_disable != 0)
		goto try_ioapic;

> @@ -3236,7 +3236,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
>  	u16 smid;
>  	u32 ioc_state;
>  	unsigned long timeleft;
> -	u8 issue_reset;
> +	bool issue_reset;
>  	int rc;
>  	void *request;
>  	u16 wait_state_count;
> @@ -3300,7 +3300,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
>  		_debug_dump_mf(mpi_request,
>  		    sizeof(Mpi2SasIoUnitControlRequest_t)/4);
>  		if (!(ioc->base_cmds.status & MPT2_CMD_RESET))
> -			issue_reset = 1;
> +			issue_reset = true;
>  		goto issue_host_reset;
>  	}
>  	if (ioc->base_cmds.status & MPT2_CMD_REPLY_VALID)

It seems like issue_reset should be initialized to false.
issue_reset can be an arbitrary value before the goto issue_host_reset
which is:

 issue_host_reset:
	if (issue_reset)
		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
		    FORCE_BIG_HAMMER);

> @@ -3341,7 +3341,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
>  	u16 smid;
>  	u32 ioc_state;p
>  	unsigned long timeleft;
> -	u8 issue_reset;
> +	bool issue_reset;
>  	int rc;
>  	void *request;
>  	u16 wait_state_count;
> @@ -3398,7 +3398,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
>  		_debug_dump_mf(mpi_request,
>  		    sizeof(Mpi2SepRequest_t)/4);
>  		if (!(ioc->base_cmds.status & MPT2_CMD_RESET))
> -			issue_reset = 1;
> +			issue_reset = true;
>  		goto issue_host_reset;
>  	}

same

I stopped looking here.


