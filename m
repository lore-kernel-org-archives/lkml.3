Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098AbaGPOxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:53:54 -0400
Received: from mx2.parallels.com ([199.115.105.18]:38913 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934066AbaGPOxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:53:51 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Topic: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Index: AQHPoQW+iuVgDGn56EGhE5PiroYLNw==
Date: Wed, 16 Jul 2014 14:53:47 +0000
Message-ID: <1405522426.2225.10.camel@jarvis.lan>
References: <1404866812-26950-1-git-send-email-kys@microsoft.com>
	 <1404866812-26950-4-git-send-email-kys@microsoft.com>
	 <20140709084300.GD6012@infradead.org>
	 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
	 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
	 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
	 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
	 <20140711063216.GA20660@infradead.org>
	 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
	 <yq1a98d2z5x.fsf@sermon.lab.mkp.net> <20140716110111.GA7382@infradead.org>
In-Reply-To: <20140716110111.GA7382@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.103.107]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4631051B0E5CE84EBC23F9B11473E066@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6GEs042028624

On Wed, 2014-07-16 at 04:01 -0700, hch@infradead.org wrote:
> On Sun, Jul 13, 2014 at 08:58:34AM -0400, Martin K. Petersen wrote:
> > >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> > 
> > KY> Windows hosts do support UNMAP and set the field in the
> > KY> EVPD. However, since the host advertises SPC-2 compliance, Linux
> > KY> does not even query the VPD page.
> >  
> > >> If we want to enable UNMAP in this case I'd prefer a blacklist entry
> > >> than trying UNMAP despite the device not advertising it.
> > 
> > I agree with that. We could do something like the patch below.
> > 
> > However, I do think it's a good idea that you guys are looking into
> > reporting SPC-3.
> 
> KY mentioned that they have a prototype for that now.
> 
> Btw, I looked over sd.c a bit more, and I think I understand why they
> get the WRITE SAME commands now:
> 
> read_capacity_16 calls sd_config_discard(sdkp, SD_LBP_WS16) if the LPBME
> bit is set.  At least older SBC drafts left it wide open if a target
> supports WRITE SAME with UNMAP or UNMAP in this case.  So I think we'd
> still want a patch to use UNMAP instead of WRITE SAME for this case,
> which should also fix hyperv.  Below is the quick hack version of that
> that just checks the host no_write_same flag, as the one on the device
> isn't set yet - I guess we need to refactor some of that logic.
> 
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 87566b5..4480fdf 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2035,7 +2035,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		if (buffer[14] & 0x40) /* LBPRZ */
>  			sdkp->lbprz = 1;
>  
> -		sd_config_discard(sdkp, SD_LBP_WS16);
> +		if (sdp->host->no_write_same)
> +			sd_config_discard(sdkp, SD_LBP_UNMAP);
> +		else
> +			sd_config_discard(sdkp, SD_LBP_WS16);

Right, I already said this was the problem: that was the reason for my
patch.  However, there are a couple of other cases (including the /sys
entry) which is why I patched sd_config_discard instead.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
