Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaL3Tgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 14:36:54 -0500
Received: from mail-bn1bon0115.outbound.protection.outlook.com ([157.56.111.115]:40688
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751779AbaL3Tgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 14:36:52 -0500
X-Greylist: delayed 769 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2014 14:36:52 EST
From: Long Li <longli@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/4] Drivers: scsi: storvsc: In responce to a scan event,
 scan the host
Thread-Topic: [PATCH 1/4] Drivers: scsi: storvsc: In responce to a scan event,
 scan the host
Thread-Index: AQHQGWx2mqAc9mNU7EKB5dmAE3rJnpyomKpg
Date: Tue, 30 Dec 2014 19:21:52 +0000
Message-ID: <BLUPR03MB4075B290CA33C4BDFD03B7ACE5E0@BLUPR03MB407.namprd03.prod.outlook.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1418764905-11250-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.22.8.192]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0708;
x-forefront-prvs: 04410E544A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(13464003)(189002)(377454003)(107046002)(21056001)(77156002)(2656002)(54356999)(76176999)(97736003)(50986999)(2501002)(105586002)(99286002)(33656002)(4396001)(54206007)(106116001)(31966008)(76576001)(106356001)(62966003)(87936001)(107886001)(2421001)(19580405001)(19580395003)(64706001)(101416001)(46102003)(122556002)(66066001)(54606007)(40100003)(68736005)(92566001)(15975445007)(1720100001)(77096005)(2900100001)(99396003)(20776003)(120916001)(2950100001)(102836002)(86612001)(2201001)(1511001)(74316001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0708;H:BLUPR03MB407.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2014 19:21:52.9680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0708
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of K. Y. Srinivasan
> Sent: Tuesday, December 16, 2014 1:22 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: [PATCH 1/4] Drivers: scsi: storvsc: In responce to a scan event, scan
> the host
> 
> The virtual HBA that storvsc implements can support multiple channels and
> targets. So, scan the host when the host notifies that a scan is needed.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   19 +++++++------------
>  1 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> e3ba251..0a96fef 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -426,21 +426,16 @@ done:
>  	kfree(wrk);
>  }
> 
> -static void storvsc_bus_scan(struct work_struct *work)
> +static void storvsc_host_scan(struct work_struct *work)
>  {
>  	struct storvsc_scan_work *wrk;
> -	int id, order_id;
> +	struct Scsi_Host *host;
> 
>  	wrk = container_of(work, struct storvsc_scan_work, work);
> -	for (id = 0; id < wrk->host->max_id; ++id) {
> -		if (wrk->host->reverse_ordering)
> -			order_id = wrk->host->max_id - id - 1;
> -		else
> -			order_id = id;
> -
> -		scsi_scan_target(&wrk->host->shost_gendev, 0,
> -				order_id, SCAN_WILD_CARD, 1);
> -	}
> +	host = wrk->host;
> +
> +	scsi_scan_host(host);
> +
>  	kfree(wrk);
>  }
> 
> @@ -1198,7 +1193,7 @@ static void storvsc_on_receive(struct hv_device
> *device,
>  		if (!work)
>  			return;
> 
> -		INIT_WORK(&work->work, storvsc_bus_scan);
> +		INIT_WORK(&work->work, storvsc_host_scan);
>  		work->host = stor_device->host;
>  		schedule_work(&work->work);
>  		break;
> --
> 1.7.4.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
