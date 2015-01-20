Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbbATSeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:34:18 -0500
Received: from mail-bl2on0128.outbound.protection.outlook.com ([65.55.169.128]:52430
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753145AbbATSeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:34:14 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: RE: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind
 offer
Thread-Topic: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind
 offer
Thread-Index: AQHQNMgaLPCg6Xxhv067MvQB7Q0C3ZzJVbOw
Date: Tue, 20 Jan 2015 18:34:10 +0000
Message-ID: <BY2PR0301MB0711C4B649166E5F946F9284A04B0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
 <1421768706-5363-4-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421768706-5363-4-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.176]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0774;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0774;
x-forefront-prvs: 0462918D61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(13464003)(51704005)(377454003)(189002)(68736005)(46102003)(54356999)(64706001)(76176999)(2656002)(101416001)(2900100001)(87936001)(97736003)(102836002)(33656002)(2501002)(2950100001)(19580405001)(86612001)(19580395003)(99286002)(105586002)(86362001)(50986999)(40100003)(122556002)(77156002)(62966003)(106356001)(74316001)(92566002)(66066001)(106116001)(54606007)(76576001)(54206007);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0774;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2015 18:34:10.9363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0774
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0KIYQjJ014702



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, January 20, 2015 7:45 AM
> To: KY Srinivasan; devel@linuxdriverproject.org
> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui; Jason Wang;
> Radim KrÄmÃ¡Å™; Dan Carpenter
> Subject: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind offer
> 
> Commit 4b2f9abea52a ("staging: hv: convert channel_mgmt.c to not call
> osd_schedule_callback")' was written under an assumption that we never
> receive Rescind offer while we're still processing the initial Offer request.
> However, the issue we fixed in 04a258c162a8 could be caused by this
> assumption not always being true.
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
>    especially after we set >state = CHANNEL_OPEN_STATE. Many things can
> go
>    wrong in that case, e.g. we can call free_channel() while we're still using
>    it.
> 
> Implement the required protection by changing work->func at the very end
> of
> vmbus_process_offer() and checking work->func in
> vmbus_onoffer_rescind(). In case we receive rescind offer during or before
> vmbus_process_offer() is done we set rescind flag to true and we check it at
> the end of vmbus_process_offer() so such offer will not get lost.
> 
> Suggested-by: Radim KrÄmÃ¡Å™ <rkrcmar@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks Vitaly.
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/channel_mgmt.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c index
> c6fdd74..877a944 100644
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
> +		queue_work(newchannel->controlwq, &newchannel-
> >work);
> +	spin_unlock_irqrestore(&newchannel->lock, flags);
>  	return;
>  err_free_chan:
>  	free_channel(newchannel);
> @@ -520,6 +524,7 @@ static void vmbus_onoffer_rescind(struct
> vmbus_channel_message_header *hdr)  {
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
> 1.9.3

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
