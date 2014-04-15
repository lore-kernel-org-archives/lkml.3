Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaDOJr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:47:59 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:35439
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750899AbaDOJr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:47:56 -0400
X-Greylist: delayed 852 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 05:47:56 EDT
X-WSS-ID: 0N42FW0-08-6V5-02
X-M-MSG: 
Message-ID: <534CFCEF.1050403@amd.com>
Date: Tue, 15 Apr 2014 11:33:35 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        David Airlie <airlied@linux.ie>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/radeon: memory leak on bo reservation failure.
References: <1395159412-12377-1-git-send-email-quentin.casasnovas@oracle.com>
 <A3397C8B8B789E45844E7EC5DEAD89D03ECB1956@satlexdag05.amd.com>
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D03ECB1956@satlexdag05.amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.152.106]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(189002)(13464003)(377454003)(33656001)(85852003)(83072002)(4396001)(19580405001)(44976005)(83322001)(74502001)(81342001)(31966008)(76482001)(23676002)(74662001)(86362001)(64126003)(85202002)(85182001)(65816999)(36756003)(80976001)(81542001)(19580395003)(97736001)(87936001)(50466002)(92566001)(46102001)(92726001)(59896001)(77982001)(50986999)(99396002)(84676001)(76176999)(77096999)(54356999)(2009001)(65956001)(83506001)(80022001)(47776003)(20776003)(65806001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB116;H:atltwp02.amd.com;FPR:BCDED4B2.A3C2AD61.EA5C9867.5266CA41.20279;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0182DBBB05
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.04.2014 23:43, schrieb Deucher, Alexander:
>> -----Original Message-----
>> From: Quentin Casasnovas [mailto:quentin.casasnovas@oracle.com]
>> Sent: Tuesday, March 18, 2014 12:17 PM
>> To: David Airlie
>> Cc: linux-kernel@vger.kernel.org; Quentin Casasnovas;
>> stable@vger.kernel.org; Koenig, Christian; Deucher, Alexander
>> Subject: [PATCH] drm/radeon: memory leak on bo reservation failure.
>>
>> On bo reservation failure, we end up leaking fpriv.
>>
>> Fixes: 5e386b574cf7e1 ("drm/radeon: fix missing bo reservation")
>> Cc: stable@vger.kernel.org
>> Cc: Christian König <christian.koenig@amd.com>
>> Cc: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> Sorry I missed this.  It looks like we probably want an updated version for newer kernels where radeon_vm_init() can fail as well.

I've rebased the stuff and added the missing free on vm failure as well.

Patch is on the list and in my 3.15 queue.

Christian.

>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>
> Alex
>
>> ---
>>   drivers/gpu/drm/radeon/radeon_kms.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon_kms.c
>> b/drivers/gpu/drm/radeon/radeon_kms.c
>> index 66ed3ea..51cda80 100644
>> --- a/drivers/gpu/drm/radeon/radeon_kms.c
>> +++ b/drivers/gpu/drm/radeon/radeon_kms.c
>> @@ -546,8 +546,11 @@ int radeon_driver_open_kms(struct drm_device
>> *dev, struct drm_file *file_priv)
>>   		radeon_vm_init(rdev, &fpriv->vm);
>>
>>   		r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
>> -		if (r)
>> +		if (r) {
>> +			radeon_vm_fini(rdev, &fpriv->vm);
>> +			kfree(fpriv);
>>   			return r;
>> +		}
>>
>>   		/* map the ib pool buffer read only into
>>   		 * virtual address space */
>> --
>> 1.8.3.2
>>

