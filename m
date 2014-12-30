Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaL3TW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 14:22:57 -0500
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:32448
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbaL3TWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 14:22:55 -0500
From: Long Li <longli@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 2/4] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Thread-Topic: [PATCH 2/4] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Thread-Index: AQHQGWx0LPoLzVkeHUqdUoTmYpzjlZyomQXQ
Date: Tue, 30 Dec 2014 19:22:52 +0000
Message-ID: <BLUPR03MB40787742B3BB04B9FFE891DCE5E0@BLUPR03MB407.namprd03.prod.outlook.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-2-git-send-email-kys@microsoft.com>
In-Reply-To: <1418764905-11250-2-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.22.8.192]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0706;
x-forefront-prvs: 04410E544A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(51704005)(377454003)(199003)(189002)(76176999)(2201001)(54606007)(86362001)(50986999)(2656002)(87936001)(86612001)(107886001)(31966008)(21056001)(62966003)(20776003)(74316001)(19580395003)(2900100001)(2421001)(64706001)(54356999)(15975445007)(122556002)(76576001)(77156002)(40100003)(1511001)(54206007)(99396003)(92566001)(97736003)(4396001)(2501002)(99286002)(120916001)(106356001)(66066001)(2950100001)(101416001)(102836002)(33656002)(1720100001)(68736005)(46102003)(107046002)(19580405001)(106116001)(77096005)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0706;H:BLUPR03MB407.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2014 19:22:52.8758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0706
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
> Subject: [PATCH 2/4] Drivers: scsi: storvsc: Force discovery of LUNs that may
> have been removed.
> 
> The host asks the guest to scan when a LUN is removed or added.
> The only way a guest can identify the removed LUN is when an I/O is
> attempted on a removed LUN - the SRB status code indicates that the LUN is
> invalid. We currently handle this SRB status and remove the device.
> 
> Rather than waiting for an I/O to remove the device, force the discovery of
> LUNs that may have been removed prior to discovering LUNs that may have
> been added.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 0a96fef..a7163c6 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -430,10 +430,36 @@ static void storvsc_host_scan(struct work_struct
> *work)  {
>  	struct storvsc_scan_work *wrk;
>  	struct Scsi_Host *host;
> +	struct scsi_device *sdev;
> +	unsigned long flags;
> 
>  	wrk = container_of(work, struct storvsc_scan_work, work);
>  	host = wrk->host;
> 
> +	/*
> +	 * Before scanning the host, first check to see if any of the
> +	 * currrently known devices have been hot removed. We issue a
> +	 * "unit ready" command against all currently known devices.
> +	 * This I/O will result in an error for devices that have been
> +	 * removed. As part of handling the I/O error, we remove the device.
> +	 *
> +	 * When a LUN is added or removed, the host sends us a signal to
> +	 * scan the host. Thus we are forced to discover the LUNs that
> +	 * may have been removed this way.
> +	 */
> +	mutex_lock(&host->scan_mutex);
> +	spin_lock_irqsave(host->host_lock, flags);
> +	list_for_each_entry(sdev, &host->__devices, siblings) {
> +		spin_unlock_irqrestore(host->host_lock, flags);
> +		scsi_test_unit_ready(sdev, 1, 1, NULL);
> +		spin_lock_irqsave(host->host_lock, flags);
> +		continue;
> +	}
> +	spin_unlock_irqrestore(host->host_lock, flags);
> +	mutex_unlock(&host->scan_mutex);
> +	/*
> +	 * Now scan the host to discover LUNs that may have been added.
> +	 */
>  	scsi_scan_host(host);
> 
>  	kfree(wrk);
> --
> 1.7.4.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
