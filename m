Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaDNV6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:58:20 -0400
Received: from [207.46.163.203] ([207.46.163.203]:17221 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751177AbaDNV6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:58:18 -0400
X-WSS-ID: 0N41J0B-08-CY1-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        David Airlie <airlied@linux.ie>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [PATCH] drm/radeon: memory leak on bo reservation failure.
Thread-Topic: [PATCH] drm/radeon: memory leak on bo reservation failure.
Thread-Index: AQHPQsWRRvfF7vS4uku7cSKMOka0fZsRzvcw
Date: Mon, 14 Apr 2014 21:43:26 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D03ECB1956@satlexdag05.amd.com>
References: <1395159412-12377-1-git-send-email-quentin.casasnovas@oracle.com>
In-Reply-To: <1395159412-12377-1-git-send-email-quentin.casasnovas@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(199002)(189002)(51704005)(13464003)(19580395003)(80976001)(81542001)(87936001)(92726001)(2009001)(54356999)(84676001)(76176999)(80022001)(20776003)(47776003)(79102001)(46102001)(92566001)(77982001)(99396002)(50986999)(53416003)(50466002)(74502001)(81342001)(76482001)(2656002)(31966008)(83072002)(4396001)(33656001)(85852003)(44976005)(83322001)(19580405001)(86362001)(55846006)(23676002)(74662001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB116;H:atltwp02.amd.com;FPR:BC1ED4B2.23C2AD51.EA5CB867.52668A41.2023F;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0181F4652A
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3ELwSPn021946

> -----Original Message-----
> From: Quentin Casasnovas [mailto:quentin.casasnovas@oracle.com]
> Sent: Tuesday, March 18, 2014 12:17 PM
> To: David Airlie
> Cc: linux-kernel@vger.kernel.org; Quentin Casasnovas;
> stable@vger.kernel.org; Koenig, Christian; Deucher, Alexander
> Subject: [PATCH] drm/radeon: memory leak on bo reservation failure.
> 
> On bo reservation failure, we end up leaking fpriv.
> 
> Fixes: 5e386b574cf7e1 ("drm/radeon: fix missing bo reservation")
> Cc: stable@vger.kernel.org
> Cc: Christian KÃ¶nig <christian.koenig@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>

Sorry I missed this.  It looks like we probably want an updated version for newer kernels where radeon_vm_init() can fail as well.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

Alex

> ---
>  drivers/gpu/drm/radeon/radeon_kms.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_kms.c
> b/drivers/gpu/drm/radeon/radeon_kms.c
> index 66ed3ea..51cda80 100644
> --- a/drivers/gpu/drm/radeon/radeon_kms.c
> +++ b/drivers/gpu/drm/radeon/radeon_kms.c
> @@ -546,8 +546,11 @@ int radeon_driver_open_kms(struct drm_device
> *dev, struct drm_file *file_priv)
>  		radeon_vm_init(rdev, &fpriv->vm);
> 
>  		r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
> -		if (r)
> +		if (r) {
> +			radeon_vm_fini(rdev, &fpriv->vm);
> +			kfree(fpriv);
>  			return r;
> +		}
> 
>  		/* map the ib pool buffer read only into
>  		 * virtual address space */
> --
> 1.8.3.2
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
