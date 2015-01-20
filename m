Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbbATSra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:47:30 -0500
Received: from mail-bl2on0116.outbound.protection.outlook.com ([65.55.169.116]:34304
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751109AbbATSr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:47:28 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: RE: [PATCH v3 1/3] Drivers: hv: check vmbus_device_create() return
 value in vmbus_process_offer()
Thread-Topic: [PATCH v3 1/3] Drivers: hv: check vmbus_device_create() return
 value in vmbus_process_offer()
Thread-Index: AQHQNMgX48g/fI3qgUCQeYB6WJtooZzJVLEg
Date: Tue, 20 Jan 2015 18:33:03 +0000
Message-ID: <BY2PR0301MB07118DBD8B97EEA900A900B7A04B0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
 <1421768706-5363-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421768706-5363-2-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.176]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0776;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-forefront-prvs: 0462918D61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(377454003)(199003)(51704005)(13464003)(106116001)(105586002)(74316001)(97736003)(86612001)(19580395003)(76176999)(50986999)(19580405001)(2501002)(54606007)(92566002)(106356001)(54356999)(64706001)(2656002)(77156002)(62966003)(76576001)(54206007)(87936001)(2900100001)(33656002)(102836002)(66066001)(101416001)(68736005)(99286002)(86362001)(2950100001)(40100003)(46102003)(122556002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0776;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2015 18:33:03.1234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0776
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, January 20, 2015 7:45 AM
> To: KY Srinivasan; devel@linuxdriverproject.org
> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui; Jason Wang;
> Radim Krèmáø; Dan Carpenter
> Subject: [PATCH v3 1/3] Drivers: hv: check vmbus_device_create() return
> value in vmbus_process_offer()
> 
> vmbus_device_create() result is not being checked in
> vmbus_process_offer() and it can fail if kzalloc() fails. Add the check and do
> minor cleanup to avoid additional duplication of "free_channel(); return;"
> block.
> 
> Reported-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks Vitaly.
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/channel_mgmt.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c index
> 2c59f03..01f2c2b 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -341,11 +341,10 @@ static void vmbus_process_offer(struct
> work_struct *work)
>  			if (channel->sc_creation_callback != NULL)
>  				channel->sc_creation_callback(newchannel);
> 
> -			return;
> +			goto out;
>  		}
> 
> -		free_channel(newchannel);
> -		return;
> +		goto err_free_chan;
>  	}
> 
>  	/*
> @@ -364,6 +363,8 @@ static void vmbus_process_offer(struct work_struct
> *work)
>  		&newchannel->offermsg.offer.if_type,
>  		&newchannel->offermsg.offer.if_instance,
>  		newchannel);
> +	if (!newchannel->device_obj)
> +		goto err_free_chan;
> 
>  	/*
>  	 * Add the new device to the bus. This will kick off device-driver @@
> -379,9 +380,12 @@ static void vmbus_process_offer(struct work_struct
> *work)
>  		list_del(&newchannel->listentry);
>  		spin_unlock_irqrestore(&vmbus_connection.channel_lock,
> flags);
>  		kfree(newchannel->device_obj);
> -
> -		free_channel(newchannel);
> +		goto err_free_chan;
>  	}
> +out:
> +	return;
> +err_free_chan:
> +	free_channel(newchannel);
>  }
> 
>  enum {
> --
> 1.9.3

