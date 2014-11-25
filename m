Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaKYFKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:10:42 -0500
Received: from mail-bl2on0112.outbound.protection.outlook.com ([65.55.169.112]:45267
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750937AbaKYFKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:10:40 -0500
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
Subject: RE: [PATCH v2] hv: hv_balloon: avoid memory leak on alloc_error of
 2MB memory block
Thread-Topic: [PATCH v2] hv: hv_balloon: avoid memory leak on alloc_error of
 2MB memory block
Thread-Index: AQHQCF8xc6Xp+RnZXkOvrtlHpdKKu5xwyy2w
Date: Tue, 25 Nov 2014 05:10:33 +0000
Message-ID: <BY2PR0301MB07118588B302F59904455F15A0730@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1416889963-31602-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1416889963-31602-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:4099:1075:632d:8112]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;
x-forefront-prvs: 040655413E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(13464003)(51704005)(199003)(377454003)(106116001)(107046002)(106356001)(54206007)(101416001)(2656002)(2561002)(86362001)(99286002)(95666004)(1511001)(20776003)(77096003)(21056001)(64706001)(46102003)(77156002)(40100003)(62966003)(105586002)(2501002)(33656002)(76576001)(99396003)(2421001)(31966008)(97736003)(87936001)(92726001)(86612001)(92566001)(76176999)(120916001)(2201001)(54356999)(122556002)(19580395003)(50986999)(4396001)(19580405001)(74316001)(54606007)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui [mailto:decui@microsoft.com]
> Sent: Monday, November 24, 2014 8:33 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan
> Cc: Haiyang Zhang
> Subject: [PATCH v2] hv: hv_balloon: avoid memory leak on alloc_error of
> 2MB memory block
> 
> If num_ballooned is not 0, we shouldn't neglect the already-partially-
> allocated 2MB memory block(s).
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
> 
> v2: I fixed the logic error in v1, pointed by Jason Wang:
> 	In v1: in the case of partially-allocated 2MB, alloc_error is true,
> 	so we'll run "done = true" and hence we won't proceed with
> 	the next iteration of trying 4K allocation.
> 
>     I also changed the WARN_ON to WARN_ON_ONCE in case the host
> behavior
>     changes in the future.
> 
>  drivers/hv/hv_balloon.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c index
> 5e90c5d..b958ded 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -1087,10 +1087,12 @@ static void balloon_up(struct work_struct
> *dummy)
>  	struct dm_balloon_response *bl_resp;
>  	int alloc_unit;
>  	int ret;
> -	bool alloc_error = false;
> +	bool alloc_error;
>  	bool done = false;
>  	int i;
> 
> +	/* The host balloons pages in 2M granularity. */
> +	WARN_ON_ONCE(num_pages % PAGES_IN_2M != 0);
> 
>  	/*
>  	 * We will attempt 2M allocations. However, if we fail to @@ -1107,16
> +1109,18 @@ static void balloon_up(struct work_struct *dummy)
> 
> 
>  		num_pages -= num_ballooned;
> +		alloc_error = false;
>  		num_ballooned = alloc_balloon_pages(&dm_device,
> num_pages,
>  						bl_resp, alloc_unit,
>  						 &alloc_error);
> 
> -		if ((alloc_error) && (alloc_unit != 1)) {
> +		if (alloc_unit != 1 && num_ballooned == 0) {
>  			alloc_unit = 1;
>  			continue;
>  		}
> 
> -		if ((alloc_error) || (num_ballooned == num_pages)) {
> +		if ((alloc_unit == 1 && alloc_error) ||
> +			(num_ballooned == num_pages)) {
>  			bl_resp->more_pages = 0;
>  			done = true;
>  			dm_device.state = DM_INITIALIZED;
> --
> 1.9.1

