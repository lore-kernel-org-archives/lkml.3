Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaB1CIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:08:31 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:49075
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750999AbaB1CI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:08:29 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Ales Novak <alnovak@suse.cz>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jkosina@suse.cz" <jkosina@suse.cz>,
        Thomas Abraham <tabraham@suse.com>
Subject: RE: [PATCH] scsi: storvsc_device_destroy NULL pointer fix
Thread-Topic: [PATCH] scsi: storvsc_device_destroy NULL pointer fix
Thread-Index: AQHPM6M6W9uUPbUsck2+emTpYkAlW5rJ7Ggw
Date: Fri, 28 Feb 2014 02:08:26 +0000
Message-ID: <3f6f360973de44bcb1991c510ca8a81e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1393495410-17575-1-git-send-email-alnovak@suse.cz>
In-Reply-To: <1393495410-17575-1-git-send-email-alnovak@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [167.220.233.2]
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(199002)(377454003)(13464003)(81542001)(65816001)(95666003)(92566001)(74502001)(33646001)(74662001)(31966008)(47446002)(63696002)(87266001)(87936001)(76796001)(93136001)(2656002)(56776001)(54316002)(76482001)(85852003)(83072002)(90146001)(85306002)(76576001)(95416001)(80976001)(54356001)(4396001)(94946001)(86362001)(53806001)(59766001)(49866001)(77982001)(50986001)(47976001)(47736001)(79102001)(74876001)(51856001)(69226001)(46102001)(81342001)(80022001)(66066001)(81816001)(74366001)(93516002)(81686001)(94316002)(74706001)(83322001)(19580405001)(74316001)(19580395003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB596;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:167.220.233.2;FPR:F93AF44D.A5374665.C7D6AFBF.84AEDA8D.20202;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ales Novak [mailto:alnovak@suse.cz]
> Sent: Thursday, February 27, 2014 2:04 AM
> To: KY Srinivasan; James E.J. Bottomley
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> jkosina@suse.cz; Ales Novak; Thomas Abraham
> Subject: [PATCH] scsi: storvsc_device_destroy NULL pointer fix
> 
> If the initialization of storvsc fails, the storvsc_device_destroy() causes NULL
> pointer dereference.
> 
> storvsc_bus_scan()
>   scsi_scan_target()
>     __scsi_scan_target()
>       scsi_probe_and_add_lun(hostdata=NULL)
>         scsi_alloc_sdev(hostdata=NULL)
> 
> 	  sdev->hostdata = hostdata
> 
> 	  now the host allocation fails
> 
>           __scsi_remove_device(sdev)
> 
> 	  calls sdev->host->hostt->slave_destroy() ==
> 	  storvsc_device_destroy(sdev)
> 	    access of sdev->hostdata->request_mempool
> 
> Signed-off-by: Ales Novak <alnovak@suse.cz>
> Signed-off-by: Thomas Abraham <tabraham@suse.com>
> Acked-by: Jiri Kosina <jkosina@suse.cz>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 17d7404..9969fa1 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1419,6 +1419,9 @@ static void storvsc_device_destroy(struct
> scsi_device *sdevice)  {
>  	struct stor_mem_pools *memp = sdevice->hostdata;
> 
> +	if (!memp)
> +		return;
> +
>  	mempool_destroy(memp->request_mempool);
>  	kmem_cache_destroy(memp->request_pool);
>  	kfree(memp);
> --
> 1.8.1.4

