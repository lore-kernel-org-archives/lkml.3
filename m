Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbbA1U3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:29:47 -0500
Received: from mail-by2on0117.outbound.protection.outlook.com ([207.46.100.117]:48254
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933254AbbA1U3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:29:43 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: RE: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind
 offer
Thread-Topic: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind
 offer
Thread-Index: AQHQNMgbpKTJmOaTDEmNPuquIq7yQJzVcMtw
Date: Wed, 28 Jan 2015 11:57:30 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C61EA94FB7@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
 <1421768706-5363-4-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421768706-5363-4-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.69]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 206.191.229.84)
 smtp.mailfrom=decui@microsoft.com; oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=pass action=none header.from=microsoft.com;
X-Forefront-Antispam-Report: CIP:206.191.229.84;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(164054003)(377454003)(13464003)(2656002)(19580405001)(87936001)(92566002)(6806004)(19580395003)(55846006)(86146001)(46102003)(106116001)(2501002)(23676002)(102836002)(66066001)(86362001)(22746005)(22756005)(33656002)(47776003)(1511001)(2421001)(2920100001)(2900100001)(2950100001)(104016003)(50466002)(54356999)(76176999)(77156002)(62966003)(2561002)(50986999)(86612001)(79686002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0846;H:064-smtp-out.microsoft.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-DmarcStatus-Test: Passed
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004)(3003004);SRVR:DM2PR0301MB0846;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0846;
X-Forefront-PRVS: 047001DADA
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0846;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 11:57:36.3382
 (UTC)
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=72f988bf-86f1-41af-91ab-2d7cd011db47;Ip=[206.191.229.84]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0846
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0SKU1kx006066

> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, January 20, 2015 23:45 PM
> To: KY Srinivasan; devel@linuxdriverproject.org
> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui; Jason Wang;
> Radim KrÄmÃ¡Å™; Dan Carpenter
> Subject: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind offer
> 
> Commit 4b2f9abea52a ("staging: hv: convert channel_mgmt.c to not call
> osd_schedule_callback")' was written under an assumption that we never
> receive
> Rescind offer while we're still processing the initial Offer request. However,
> the issue we fixed in 04a258c162a8 could be caused by this assumption not
> always being true.
> 
> In particular, we need to protect against the following:
> 1) Receiving a Rescind offer after we do queue_work() for processing an
> Offer
>    request and before we actually enter vmbus_process_offer(). work.func
> points
>    to vmbus_process_offer() at this moment and in vmbus_onoffer_rescind()
> we do
>    another queue_work() without a check so we'll enter
> vmbus_process_offer()
>    twice.
> 2) Receiving a Rescind offer after we enter vmbus_process_offer() and
>    especially after we set >state = CHANNEL_OPEN_STATE. Many things can go
>    wrong in that case, e.g. we can call free_channel() while we're still using
>    it.
> 
> Implement the required protection by changing work->func at the very end
> of
> vmbus_process_offer() and checking work->func in vmbus_onoffer_rescind().
> In
> case we receive rescind offer during or before vmbus_process_offer() is
> done
> we set rescind flag to true and we check it at the end of
> vmbus_process_offer()
> so such offer will not get lost.
> 
> Suggested-by: Radim KrÄmÃ¡Å™ <rkrcmar@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  drivers/hv/channel_mgmt.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index c6fdd74..877a944 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -279,9 +279,6 @@ static void vmbus_process_offer(struct work_struct
> *work)
>  	int ret;
>  	unsigned long flags;
> 
> -	/* The next possible work is rescind handling */
> -	INIT_WORK(&newchannel->work, vmbus_process_rescind_offer);
> -
>  	/* Make sure this is a new offer */
>  	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
> 
> @@ -341,7 +338,7 @@ static void vmbus_process_offer(struct work_struct
> *work)
>  			if (channel->sc_creation_callback != NULL)
>  				channel->sc_creation_callback(newchannel);
> 
> -			goto out;
> +			goto done_init_rescind;
>  		}
> 
>  		goto err_free_chan;
> @@ -382,7 +379,14 @@ static void vmbus_process_offer(struct work_struct
> *work)
>  		kfree(newchannel->device_obj);
>  		goto err_free_chan;
>  	}
> -out:
> +done_init_rescind:
> +	spin_lock_irqsave(&newchannel->lock, flags);
> +	/* The next possible work is rescind handling */
> +	INIT_WORK(&newchannel->work, vmbus_process_rescind_offer);
> +	/* Check if rescind offer was already received */
> +	if (newchannel->rescind)
> +		queue_work(newchannel->controlwq, &newchannel->work);
> +	spin_unlock_irqrestore(&newchannel->lock, flags);
>  	return;
>  err_free_chan:
>  	free_channel(newchannel);
> @@ -520,6 +524,7 @@ static void vmbus_onoffer_rescind(struct
> vmbus_channel_message_header *hdr)
>  {
>  	struct vmbus_channel_rescind_offer *rescind;
>  	struct vmbus_channel *channel;
> +	unsigned long flags;
> 
>  	rescind = (struct vmbus_channel_rescind_offer *)hdr;
>  	channel = relid2channel(rescind->child_relid);
> @@ -528,11 +533,20 @@ static void vmbus_onoffer_rescind(struct
> vmbus_channel_message_header *hdr)
>  		/* Just return here, no channel found */
>  		return;
> 
> +	spin_lock_irqsave(&channel->lock, flags);
>  	channel->rescind = true;
> +	/*
> +	 * channel->work.func != vmbus_process_rescind_offer means we
> are still
> +	 * processing offer request and the rescind offer processing should
> be
> +	 * postponed. It will be done at the very end of
> vmbus_process_offer()
> +	 * as rescind flag is being checked there.
> +	 */
> +	if (channel->work.func == vmbus_process_rescind_offer)
> +		/* work is initialized for vmbus_process_rescind_offer() from
> +		 * vmbus_process_offer() where the channel got created */
> +		queue_work(channel->controlwq, &channel->work);
> 
> -	/* work is initialized for vmbus_process_rescind_offer() from
> -	 * vmbus_process_offer() where the channel got created */
> -	queue_work(channel->controlwq, &channel->work);
> +	spin_unlock_irqrestore(&channel->lock, flags);
>  }
> 
>  /*
> --

Hi Vitaly and all,
I have 2 questions:
In vmbus_process_offer(),  in the cases of "goto err_free_chan",
should we consider the possibility a rescind message could be pending for 
the new channel?
In the cases,  because we don't run 
"INIT_WORK(&newchannel->work, vmbus_process_rescind_offer); ",
vmbus_onoffer_rescind() will do nothing and as a result, 
vmbus_process_rescind_offer() won't be invoked.

Question 2: in vmbus_process_offer(), in the case
vmbus_device_register() fails, we'll run
"list_del(&newchannel->listentry);" -- just after this line,
 what will happen at this time if relid2channel() returns NULL
in vmbus_onoffer_rescind()?

I think we'll lose the rescind message. 

Thanks,
-- Dexuan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
