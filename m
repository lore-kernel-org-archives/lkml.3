Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaGKRsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:48:15 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:34653
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751045AbaGKRsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:48:13 -0400
X-WSS-ID: 0N8K6S0-07-ALK-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: Jerome Glisse <j.glisse@gmail.com>, Oded Gabbay <oded.gabbay@gmail.com>
CC: David Airlie <airlied@linux.ie>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: [PATCH 07/83] drm/radeon: Add kfd-->kgd interface of locking
 srbm_gfx_cntl register
Thread-Topic: [PATCH 07/83] drm/radeon: Add kfd-->kgd interface of locking
 srbm_gfx_cntl register
Thread-Index: AQHPnIkNpAGCPFjel0W1olZsAQbmHpubVf8A///PiRA=
Date: Fri, 11 Jul 2014 17:48:02 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01031AE7@storexdag02.amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-6-git-send-email-oded.gabbay@amd.com>
 <20140711163437.GH1870@gmail.com>
In-Reply-To: <20140711163437.GH1870@gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(51704005)(24454002)(13464003)(189002)(377454003)(46102001)(81342001)(92566001)(68736004)(97736001)(64706001)(83072002)(2656002)(77982001)(77096002)(21056001)(84676001)(79102001)(81542001)(76176999)(53416004)(87936001)(50986999)(85852003)(76482001)(85306003)(55846006)(106116001)(99396002)(107046002)(105586002)(54356999)(92726001)(74502001)(83322001)(31966008)(74662001)(20776003)(95666004)(86362001)(106466001)(80022001)(19580405001)(50466002)(47776003)(101416001)(44976005)(33656002)(19580395003)(4396001)(23756003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB036;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02698DF457
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking... we shouldn't need to call the lock from kfd any more.We should be able to do any required locking in radeon kgd code.

>-----Original Message-----
>From: Jerome Glisse [mailto:j.glisse@gmail.com]
>Sent: Friday, July 11, 2014 12:35 PM
>To: Oded Gabbay
>Cc: David Airlie; Deucher, Alexander; linux-kernel@vger.kernel.org; dri-
>devel@lists.freedesktop.org; Bridgman, John; Lewycky, Andrew; Joerg
>Roedel; Gabbay, Oded; Koenig, Christian
>Subject: Re: [PATCH 07/83] drm/radeon: Add kfd-->kgd interface of locking
>srbm_gfx_cntl register
>
>On Fri, Jul 11, 2014 at 12:50:07AM +0300, Oded Gabbay wrote:
>> This patch adds a new interface to kfd2kgd_calls structure, which
>> allows the kfd to lock and unlock the srbm_gfx_cntl register
>
>Why does kfd needs to lock this register if kfd can not access any of those
>register ? This sounds broken to me, exposing a driver internal mutex to
>another driver is not something i am fan of.
>
>Cheers,
>Jérôme
>
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>  drivers/gpu/drm/radeon/radeon_kfd.c | 20 ++++++++++++++++++++
>>  include/linux/radeon_kfd.h          |  4 ++++
>>  2 files changed, 24 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c
>> b/drivers/gpu/drm/radeon/radeon_kfd.c
>> index 66ee36b..594020e 100644
>> --- a/drivers/gpu/drm/radeon/radeon_kfd.c
>> +++ b/drivers/gpu/drm/radeon/radeon_kfd.c
>> @@ -43,6 +43,10 @@ static void unkmap_mem(struct kgd_dev *kgd, struct
>> kgd_mem *mem);
>>
>>  static uint64_t get_vmem_size(struct kgd_dev *kgd);
>>
>> +static void lock_srbm_gfx_cntl(struct kgd_dev *kgd); static void
>> +unlock_srbm_gfx_cntl(struct kgd_dev *kgd);
>> +
>> +
>>  static const struct kfd2kgd_calls kfd2kgd = {
>>  	.allocate_mem = allocate_mem,
>>  	.free_mem = free_mem,
>> @@ -51,6 +55,8 @@ static const struct kfd2kgd_calls kfd2kgd = {
>>  	.kmap_mem = kmap_mem,
>>  	.unkmap_mem = unkmap_mem,
>>  	.get_vmem_size = get_vmem_size,
>> +	.lock_srbm_gfx_cntl = lock_srbm_gfx_cntl,
>> +	.unlock_srbm_gfx_cntl = unlock_srbm_gfx_cntl,
>>  };
>>
>>  static const struct kgd2kfd_calls *kgd2kfd; @@ -233,3 +239,17 @@
>> static uint64_t get_vmem_size(struct kgd_dev *kgd)
>>
>>  	return rdev->mc.real_vram_size;
>>  }
>> +
>> +static void lock_srbm_gfx_cntl(struct kgd_dev *kgd) {
>> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
>> +
>> +	mutex_lock(&rdev->srbm_mutex);
>> +}
>> +
>> +static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd) {
>> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
>> +
>> +	mutex_unlock(&rdev->srbm_mutex);
>> +}
>> diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
>> index c7997d4..40b691c 100644
>> --- a/include/linux/radeon_kfd.h
>> +++ b/include/linux/radeon_kfd.h
>> @@ -81,6 +81,10 @@ struct kfd2kgd_calls {
>>  	void (*unkmap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
>>
>>  	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
>> +
>> +	/* SRBM_GFX_CNTL mutex */
>> +	void (*lock_srbm_gfx_cntl)(struct kgd_dev *kgd);
>> +	void (*unlock_srbm_gfx_cntl)(struct kgd_dev *kgd);
>>  };
>>
>>  bool kgd2kfd_init(unsigned interface_version,
>> --
>> 1.9.1
>>
