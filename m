Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaL3Tj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 14:39:59 -0500
Received: from mail-bn1on0130.outbound.protection.outlook.com ([157.56.110.130]:33446
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751380AbaL3Tj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 14:39:57 -0500
From: Long Li <longli@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3/4] Drivers: scsi: storvsc: Fix a bug in storvsc limits
Thread-Topic: [PATCH 3/4] Drivers: scsi: storvsc: Fix a bug in storvsc limits
Thread-Index: AQHQGWx07cuIUS3uQ028++Xfd0Sf9pyomWmQ
Date: Tue, 30 Dec 2014 19:24:00 +0000
Message-ID: <BLUPR03MB407EE2C86301CD642F48B7DCE5E0@BLUPR03MB407.namprd03.prod.outlook.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-3-git-send-email-kys@microsoft.com>
In-Reply-To: <1418764905-11250-3-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.22.8.192]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
x-forefront-prvs: 04410E544A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(377454003)(13464003)(51704005)(68736005)(107046002)(50986999)(106356001)(2950100001)(86612001)(76176999)(62966003)(76576001)(54206007)(54356999)(66066001)(77156002)(20776003)(1511001)(19580405001)(46102003)(120916001)(77096005)(64706001)(87936001)(92566001)(97736003)(2501002)(105586002)(86362001)(31966008)(122556002)(33656002)(106116001)(107886001)(99286002)(40100003)(2421001)(74316001)(1720100001)(2201001)(15975445007)(2900100001)(102836002)(101416001)(2656002)(4396001)(54606007)(19580395003)(21056001)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0712;H:BLUPR03MB407.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2014 19:24:00.0339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0712
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
> Subject: [PATCH 3/4] Drivers: scsi: storvsc: Fix a bug in storvsc limits
> 
> Commit 4cd83ecdac20d30725b4f96e5d7814a1e290bc7e changed the limits to
> reflect the values on the host. It turns out that WS2008R2 cannot correctly
> handle these new limits. Fix this bug by setting the limits based on the host.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> a7163c6..fdc5164 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1782,6 +1782,9 @@ static int storvsc_probe(struct hv_device *device,
>  	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
>  	int target = 0;
>  	struct storvsc_device *stor_device;
> +	int max_luns_per_target;
> +	int max_targets;
> +	int max_channels;
> 
>  	/*
>  	 * Based on the windows host we are running on, @@ -1795,12
> +1798,18 @@ static int storvsc_probe(struct hv_device *device,
>  		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
>  		vmstor_current_major = VMSTOR_WIN7_MAJOR;
>  		vmstor_current_minor = VMSTOR_WIN7_MINOR;
> +		max_luns_per_target =
> STORVSC_IDE_MAX_LUNS_PER_TARGET;
> +		max_targets = STORVSC_IDE_MAX_TARGETS;
> +		max_channels = STORVSC_IDE_MAX_CHANNELS;
>  		break;
>  	default:
>  		sense_buffer_size =
> POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
>  		vmscsi_size_delta = 0;
>  		vmstor_current_major = VMSTOR_WIN8_MAJOR;
>  		vmstor_current_minor = VMSTOR_WIN8_MINOR;
> +		max_luns_per_target = STORVSC_MAX_LUNS_PER_TARGET;
> +		max_targets = STORVSC_MAX_TARGETS;
> +		max_channels = STORVSC_MAX_CHANNELS;
>  		break;
>  	}
> 
> @@ -1848,9 +1857,9 @@ static int storvsc_probe(struct hv_device *device,
>  		break;
> 
>  	case SCSI_GUID:
> -		host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
> -		host->max_id = STORVSC_MAX_TARGETS;
> -		host->max_channel = STORVSC_MAX_CHANNELS - 1;
> +		host->max_lun = max_luns_per_target;
> +		host->max_id = max_targets;
> +		host->max_channel = max_channels - 1;
>  		break;
> 
>  	default:
> --
> 1.7.4.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
