Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaKSW7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:59:21 -0500
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:3005
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755043AbaKSW7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:59:18 -0500
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
Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHP/ixzoWqBLlree0aJYfe1XGjx8ZxonIcQ
Date: Wed, 19 Nov 2014 22:59:15 +0000
Message-ID: <BN1PR0301MB0707ED3958628389255649FCA0890@BN1PR0301MB0707.namprd03.prod.outlook.com>
References: <1415768606-28538-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1415768606-28538-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0705;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0705;
x-forefront-prvs: 04004D94E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(377454003)(189002)(51704005)(199003)(40100003)(2420400002)(77156002)(62966003)(77096003)(86612001)(74316001)(106116001)(87936001)(2656002)(86362001)(105586002)(19580395003)(106356001)(107046002)(19580405001)(15975445006)(1511001)(92566001)(92726001)(2201001)(64706001)(20776003)(54606007)(76176999)(99286002)(54356999)(95666004)(50986999)(551934003)(2501002)(101416001)(97736003)(33656002)(2561002)(122556002)(2421001)(21056001)(54206007)(99396003)(120916001)(4396001)(46102003)(76576001)(15202345003)(217423001)(31966008)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0705;H:BN1PR0301MB0707.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0596;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of Dexuan Cui
> Sent: Tuesday, November 11, 2014 9:03 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: Haiyang Zhang
> Subject: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> 
> In the case the user-space daemon crashes, hangs or is killed, we need to
> down the semaphore, otherwise, after the daemon starts next time, the
> obsolete data in fcopy_transaction.message or fcopy_transaction.fcopy_msg
> will be used immediately.
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/hv/hv_fcopy.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c index
> 23b2ce2..177122a 100644
> --- a/drivers/hv/hv_fcopy.c
> +++ b/drivers/hv/hv_fcopy.c
> @@ -86,6 +86,15 @@ static void fcopy_work_func(struct work_struct
> *dummy)
>  	 * process the pending transaction.
>  	 */
>  	fcopy_respond_to_host(HV_E_FAIL);
> +
> +	/* In the case the user-space daemon crashes, hangs or is killed, we
> +	 * need to down the semaphore, otherwise, after the daemon starts
> next
> +	 * time, the obsolete data in fcopy_transaction.message or
> +	 * fcopy_transaction.fcopy_msg will be used immediately.
> +	 */
> +	if (down_trylock(&fcopy_transaction.read_sema))
> +		pr_debug("FCP: failed to acquire the semaphore\n");
> +
>  }

When the daemon is killed, we currently reset the state in the release function. Why can't we cleanup the semaphore state (initialize) here as well.

K. Y
> 
>  static int fcopy_handle_handshake(u32 version)
> --
> 1.9.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
