Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaJUSqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:46:49 -0400
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:3648
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754564AbaJUSqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:46:47 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jeff Leung <jleung@v10networks.ca>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH] scsi: storvsc: Force SPC-3 for Win8 Hosts or Later
Thread-Topic: [PATCH] scsi: storvsc: Force SPC-3 for Win8 Hosts or Later
Thread-Index: AQHP7PFmQOk6ANN4oEe58ld+F68v/5w64M2g
Date: Tue, 21 Oct 2014 18:46:43 +0000
Message-ID: <84a680528eb44a38824175118f9c561e@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1413869964-38940-1-git-send-email-jleung@v10networks.ca>
In-Reply-To: <1413869964-38940-1-git-send-email-jleung@v10networks.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e8:ee31::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;
x-forefront-prvs: 0371762FE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(13464003)(189002)(377454003)(51704005)(86612001)(2656002)(101416001)(87936001)(86362001)(2501002)(92566001)(575784001)(50986999)(54356999)(76176999)(76576001)(64706001)(99396003)(106116001)(19580405001)(74316001)(99286002)(105586002)(95666004)(106356001)(107046002)(21056001)(108616004)(85306004)(97736003)(31966008)(80022003)(85852003)(19580395003)(20776003)(40100003)(122556002)(76482002)(120916001)(2201001)(46102003)(77096002)(4396001)(33646002)(24736002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jeff Leung [mailto:jleung@v10networks.ca]
> Sent: Monday, October 20, 2014 10:39 PM
> To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Cc: KY Srinivasan; James.Bottomley@HansenPartnership.com; Jeff Leung
> Subject: [PATCH] scsi: storvsc: Force SPC-3 for Win8 Hosts or Later
> 
> This patch forces SPC-3 for Hyper-V disks on the VMBus. As Windows 10's
> virtual SAS bus is SPC-3 compliant and there are no negative side effects on
> forcing SPC-3 compliance for Win8 hosts, this patch enables SPC-3 compliance
> by forcing it on for hosts with versions later than Win8.
> 
> Forcing SPC-3 compliance for hosts earlier than Win10 also enables TRIM
> support.
> 
> Suggested by: James Bottomley
> <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Jeff Leung <jleung@v10networks.ca>
> ---
>  drivers/scsi/storvsc_drv.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> ed0f899..afcc68e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1449,6 +1449,15 @@ static int storvsc_device_configure(struct
> scsi_device *sdevice)
> 
>  	sdevice->no_write_same = 1;
> 
> +	/*
> +	 * If the host is Win2k12 or later, we pretend to be SPC-3 compliant
> +	 * and send RC16 which activates TRIM. We will only enable this on a
> +	 * host with levels greater than VERSION_WIN8
> +	 */
> +	if (vmbus_proto_version >= VERSION_WIN8) {

I would want this hack not to be in Windows 10. We can have this hack if the host is either
Ws2012 or ws2012 r2 (VERSION_WIN8 or VERSION_WIN8_1). Also this hack should apply only 
to VHD's being presented and not pass through devices.

K. Y
> +		sdevice->scsi_level = SCSI_SPC_3;
> +	}
> +
>  	return 0;
>  }
> 
> --
> 1.7.2.5

