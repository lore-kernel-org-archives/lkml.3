Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaGLAgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:36:41 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:35787
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752741AbaGLAgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:36:40 -0400
X-WSS-ID: 0N8KPOM-07-RBG-02
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
Thread-Index: AQHPnIkNpAGCPFjel0W1olZsAQbmHpubVf8A///PiRCAAHA08A==
Date: Sat, 12 Jul 2014 00:36:19 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01031F75@storexdag02.amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-6-git-send-email-oded.gabbay@amd.com>
 <20140711163437.GH1870@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01031AE7@storexdag02.amd.com>
In-Reply-To: <D89D60253BB73A4E8C62F9FD18A939CA01031AE7@storexdag02.amd.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(164054003)(51704005)(377454003)(13464003)(24454002)(80022001)(77982001)(55846006)(64706001)(99396002)(76482001)(31966008)(92726001)(85306003)(97736001)(74502001)(76176999)(68736004)(33656002)(86362001)(21056001)(79102001)(50466002)(23756003)(2656002)(105586002)(77096002)(19580395003)(44976005)(20776003)(92566001)(81342001)(46102001)(95666004)(106466001)(50986999)(107046002)(54356999)(53416004)(83072002)(87936001)(93886003)(101416001)(74662001)(81542001)(85852003)(83322001)(47776003)(19580405001)(4396001)(84676001)(106116001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0270ED2845
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Confirmed. The locking functions are removed from the interface in commit 82 :

[PATCH 82/83] drm/radeon: Remove lock functions from kfd2kgd interface

There is an elegant symmetry there, but yeah we need to find a way to make this less awkward to review without screwing up all the work you've done so far. It's not obvious how to do that though. I looked at squashing into a smaller number of big commits earlier on but unless we completely rip the code out and recreate from scratch I don't see anything better than :

- a few foundation commits
- a big code dump that covers everything up to ~patch 54 (with 71 squashed in)
- remaining commits squashed a bit to combine fixes with initial code

Is that what you had in mind when you said ~10 big commits ? Our feeling was that the need to skip over the original scheduler would make it more like "one really big commit and 10-20 smaller ones", and I think we all felt that the "big code dump" required to skip over the original scheduler would be a non-starter. 

I guess there is another option, and maybe that's what you had in mind -- breaking the "big code dump" into smaller commits would be possible if we were willing to not have working code until we got to the equivalent of ~patch 54 (+71) when all the new scheduler bits were in. Maybe that would still be an improvement ?

Thanks,
JB

>-----Original Message-----
>From: Bridgman, John
>Sent: Friday, July 11, 2014 1:48 PM
>To: 'Jerome Glisse'; Oded Gabbay
>Cc: David Airlie; Deucher, Alexander; linux-kernel@vger.kernel.org; dri-
>devel@lists.freedesktop.org; Lewycky, Andrew; Joerg Roedel; Gabbay, Oded;
>Koenig, Christian
>Subject: RE: [PATCH 07/83] drm/radeon: Add kfd-->kgd interface of locking
>srbm_gfx_cntl register
>
>Checking... we shouldn't need to call the lock from kfd any more.We should
>be able to do any required locking in radeon kgd code.
>
>>-----Original Message-----
>>From: Jerome Glisse [mailto:j.glisse@gmail.com]
>>Sent: Friday, July 11, 2014 12:35 PM
>>To: Oded Gabbay
>>Cc: David Airlie; Deucher, Alexander; linux-kernel@vger.kernel.org;
>>dri- devel@lists.freedesktop.org; Bridgman, John; Lewycky, Andrew;
>>Joerg Roedel; Gabbay, Oded; Koenig, Christian
>>Subject: Re: [PATCH 07/83] drm/radeon: Add kfd-->kgd interface of
>>locking srbm_gfx_cntl register
>>
>>On Fri, Jul 11, 2014 at 12:50:07AM +0300, Oded Gabbay wrote:
>>> This patch adds a new interface to kfd2kgd_calls structure, which
>>> allows the kfd to lock and unlock the srbm_gfx_cntl register
>>
>>Why does kfd needs to lock this register if kfd can not access any of
>>those register ? This sounds broken to me, exposing a driver internal
>>mutex to another driver is not something i am fan of.
>>
>>Cheers,
>>Jérôme
>>
>>>
>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>> ---
>>>  drivers/gpu/drm/radeon/radeon_kfd.c | 20 ++++++++++++++++++++
>>>  include/linux/radeon_kfd.h          |  4 ++++
>>>  2 files changed, 24 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c
>>> b/drivers/gpu/drm/radeon/radeon_kfd.c
>>> index 66ee36b..594020e 100644
>>> --- a/drivers/gpu/drm/radeon/radeon_kfd.c
>>> +++ b/drivers/gpu/drm/radeon/radeon_kfd.c
>>> @@ -43,6 +43,10 @@ static void unkmap_mem(struct kgd_dev *kgd,
>struct
>>> kgd_mem *mem);
>>>
>>>  static uint64_t get_vmem_size(struct kgd_dev *kgd);
>>>
>>> +static void lock_srbm_gfx_cntl(struct kgd_dev *kgd); static void
>>> +unlock_srbm_gfx_cntl(struct kgd_dev *kgd);
>>> +
>>> +
>>>  static const struct kfd2kgd_calls kfd2kgd = {
>>>  	.allocate_mem = allocate_mem,
>>>  	.free_mem = free_mem,
>>> @@ -51,6 +55,8 @@ static const struct kfd2kgd_calls kfd2kgd = {
>>>  	.kmap_mem = kmap_mem,
>>>  	.unkmap_mem = unkmap_mem,
>>>  	.get_vmem_size = get_vmem_size,
>>> +	.lock_srbm_gfx_cntl = lock_srbm_gfx_cntl,
>>> +	.unlock_srbm_gfx_cntl = unlock_srbm_gfx_cntl,
>>>  };
>>>
>>>  static const struct kgd2kfd_calls *kgd2kfd; @@ -233,3 +239,17 @@
>>> static uint64_t get_vmem_size(struct kgd_dev *kgd)
>>>
>>>  	return rdev->mc.real_vram_size;
>>>  }
>>> +
>>> +static void lock_srbm_gfx_cntl(struct kgd_dev *kgd) {
>>> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
>>> +
>>> +	mutex_lock(&rdev->srbm_mutex);
>>> +}
>>> +
>>> +static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd) {
>>> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
>>> +
>>> +	mutex_unlock(&rdev->srbm_mutex);
>>> +}
>>> diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
>>> index c7997d4..40b691c 100644
>>> --- a/include/linux/radeon_kfd.h
>>> +++ b/include/linux/radeon_kfd.h
>>> @@ -81,6 +81,10 @@ struct kfd2kgd_calls {
>>>  	void (*unkmap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
>>>
>>>  	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
>>> +
>>> +	/* SRBM_GFX_CNTL mutex */
>>> +	void (*lock_srbm_gfx_cntl)(struct kgd_dev *kgd);
>>> +	void (*unlock_srbm_gfx_cntl)(struct kgd_dev *kgd);
>>>  };
>>>
>>>  bool kgd2kfd_init(unsigned interface_version,
>>> --
>>> 1.9.1
>>>
