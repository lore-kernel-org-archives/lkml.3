Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881AbaGPNMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:12:54 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:3210
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932702AbaGPNMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:12:51 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Drivers: hv: hv_fcopy: fix a race condition for SMP guest
Thread-Topic: [PATCH] Drivers: hv: hv_fcopy: fix a race condition for SMP
 guest
Thread-Index: AQHPoLst0fSzyHevtkmmqfAMPmjMf5uirZBQ
Date: Wed, 16 Jul 2014 13:12:47 +0000
Message-ID: <a8f42da640f94201abd45df723e85411@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405494045-11548-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1405494045-11548-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(13464003)(51704005)(199002)(189002)(20776003)(83322001)(76176999)(80022001)(105586002)(86362001)(85852003)(50986999)(87936001)(95666004)(2656002)(19580405001)(19580395003)(15975445006)(79102001)(77982001)(76576001)(2421001)(99286002)(66066001)(99396002)(85306003)(21056001)(4396001)(64706001)(81542001)(101416001)(74316001)(92566001)(31966008)(106116001)(106356001)(74502001)(86612001)(81342001)(2201001)(74662001)(46102001)(54356999)(83072002)(551934003)(77096002)(33646002)(76482001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui [mailto:decui@microsoft.com]
> Sent: Wednesday, July 16, 2014 12:01 AM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan; Haiyang Zhang
> Subject: [PATCH] Drivers: hv: hv_fcopy: fix a race condition for SMP guest
> 
> We should schedule the 5s "timer work" before starting the data transfer,
> otherwise, the data transfer code may finish so fast on another virtual cpu
> that when the code(fcopy_write()) trying to cancel the 5s "timer work" can
> occasionally fail because the "timer work" may haven't been scheduled yet
> and as a result the fcopy process will be aborted wrongly by
> fcopy_work_func() in 5s.
> 
> Thank Liz Zhang <lizzha@microsoft.com> for the initial investigation on the
> bug.
> 
> This addresses https://bugzilla.redhat.com/show_bug.cgi?id=1118123
> 
> Tested-by: Liz Zhang <lizzha@microsoft.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Thanks Dexuan.
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>


K. Y

> ---
>  drivers/hv/hv_fcopy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c index
> eaaa3d8..23b2ce2 100644
> --- a/drivers/hv/hv_fcopy.c
> +++ b/drivers/hv/hv_fcopy.c
> @@ -246,8 +246,8 @@ void hv_fcopy_onchannelcallback(void *context)
>  		/*
>  		 * Send the information to the user-level daemon.
>  		 */
> -		fcopy_send_data();
>  		schedule_delayed_work(&fcopy_work, 5*HZ);
> +		fcopy_send_data();
>  		return;
>  	}
>  	icmsghdr->icflags = ICMSGHDRFLAG_TRANSACTION |
> ICMSGHDRFLAG_RESPONSE;
> --
> 1.9.1

