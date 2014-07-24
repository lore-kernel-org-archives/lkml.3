Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbaGXOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:09:27 -0400
Received: from mx2.parallels.com ([199.115.105.18]:42438 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945AbaGXOJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:09:25 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "sitsofe@gmail.com" <sitsofe@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 2/3] [SCSI] storvsc: Add Hyper-V logical block
 provisioning tests
Thread-Topic: [PATCH 2/3] [SCSI] storvsc: Add Hyper-V logical block
 provisioning tests
Thread-Index: AQHPp0jXiCsIZOfLBEqFRrhpisiOnQ==
Date: Thu, 24 Jul 2014 14:09:11 +0000
Message-ID: <1406210951.2040.5.camel@jarvis.lan>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
	 <20140723141028.GA22724@sucs.org> <20140723141558.GA9705@infradead.org>
	 <20140723201341.GA10292@sucs.org> <20140724074739.GA15127@sucs.org>
	 <20140724075653.GC15127@sucs.org>
In-Reply-To: <20140724075653.GC15127@sucs.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.103.107]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C0405326331634AB54A917409251B18@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6OE9WEO025411

On Thu, 2014-07-24 at 08:56 +0100, Sitsofe Wheeler wrote:
> Microsoft Hyper-V targets currently only claim SPC-2 compliance / no
> compliance indicated even though they implement post SPC-2 features
> which means those features are not tested for. Add a blacklist flag to
> Hyper-V devices that forces said testing.

This description is misleading: you don't force the test now, you force
the driver to send unmap commands down to the device.

> See https://lkml.org/lkml/2014/7/21/627 for the previous version of this
> patch and https://lkml.org/lkml/2014/7/23/615 for example devices.
> 
> Original-patch-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> ---
>  drivers/scsi/storvsc_drv.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 5ad2810..88b7173 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -326,8 +326,6 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
>   */
>  static int storvsc_timeout = 180;
>  
> -static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
> -
>  #define STORVSC_MAX_IO_REQUESTS				200
>  
>  static void storvsc_on_channel_callback(void *context);
> @@ -1444,12 +1442,10 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
>  	sdevice->no_write_same = 1;
>  
>  	/*
> -	 * Add blist flags to permit the reading of the VPD pages even when
> -	 * the target may claim SPC-2 compliance. MSFT targets currently
> -	 * claim SPC-2 compliance while they implement post SPC-2 features.
> -	 * With this patch we can correctly handle WRITE_SAME_16 issues.
> +	 * Forcefully enable logical block provisioning testing.
>  	 */
> -	sdevice->sdev_bflags |= msft_blist_flags;
> +	sdevice->sdev_bflags |= BLIST_TRY_LBP;
> +	sdevice->try_lbp = 1;

Really no way to this one.  You're forcing unmap support on every
hyper-v device; including spinning rust pass through ones which won't
support it.  The hyper-v storage interface has proven to be somewhat
fragile, so it may explode when the device tries to send illegal command
sense back.

If you have a specific IDENTITY string for a faulty SSD that fails to
report unmap support correctly, then we could quirk for that, but not
everything attached to the hyper-v driver.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
