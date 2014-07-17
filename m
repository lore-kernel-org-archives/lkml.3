Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbaGQM3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:29:13 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:10019
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755235AbaGQM3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:29:11 -0400
X-WSS-ID: 0N8UW0I-08-3EU-02
X-M-MSG: 
Message-ID: <53C7C18F.2070803@amd.com>
Date: Thu, 17 Jul 2014 14:29:03 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Oded Gabbay <oded.gabbay@amd.com>, Jerome Glisse <j.glisse@gmail.com>,
        Oded Gabbay <oded.gabbay@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 08/83] drm/radeon: Add calls to initialize and finalize
 kfd from radeon
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	 <1405029027-6085-7-git-send-email-oded.gabbay@amd.com>
 <20140711163627.GI1870@gmail.com> <53C7BA12.20703@amd.com>
In-Reply-To: <53C7BA12.20703@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.224.155.97]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(479174003)(189002)(199002)(24454002)(65806001)(84676001)(31966008)(77982001)(76482001)(74502001)(23756003)(20776003)(47776003)(44976005)(83322001)(64126003)(19580405001)(86362001)(33656002)(19580395003)(50986999)(46102001)(102836001)(65956001)(80022001)(107046002)(74662001)(21056001)(4396001)(83506001)(59896001)(81542001)(92726001)(81342001)(50466002)(106466001)(54356999)(92566001)(36756003)(105586002)(85852003)(101416001)(83072002)(85306003)(68736004)(99396002)(76176999)(95666004)(87266999)(65816999)(93886003)(64706001)(87936001)(79102001)(97736001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB039;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.07.2014 13:57, schrieb Oded Gabbay:
> On 11/07/14 19:36, Jerome Glisse wrote:
>> On Fri, Jul 11, 2014 at 12:50:08AM +0300, Oded Gabbay wrote:
>>> The KFD driver should be loaded when the radeon driver is loaded and
>>> should be finalized when the radeon driver is removed.
>>>
>>> This patch adds a function call to initialize kfd from radeon_init
>>> and a function call to finalize kfd from radeon_exit.
>>>
>>> If the KFD driver is not present in the system, the initialize call
>>> fails and the radeon driver continues normally.
>>>
>>> This patch also adds calls to probe, initialize and finalize a kfd 
>>> device
>>> per radeon device using the kgd-->kfd interface.
>>>
>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>
>> It might be nice to allow to build radeon without HSA so i think an
>> CONFIG_HSA should be added and have other thing depends on it.
>> Otherwise this one is.
>>
>> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
>>
> We do allow it :)
> There is no problem building radeon without the kfd. In that case, 
> when radeon finds out that kfd is not available, it simply moves on 
> with its initialization procedure.

At least off hand I don't see how this should work. Radeon directly 
calls radeon_kfd_(probe|init|fini) and so has a direct dependency on it.

Christian.

>
>     Oded
>>
>>> ---
>>>   drivers/gpu/drm/radeon/radeon_drv.c | 6 ++++++
>>>   drivers/gpu/drm/radeon/radeon_kms.c | 9 +++++++++
>>>   2 files changed, 15 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/radeon/radeon_drv.c 
>>> b/drivers/gpu/drm/radeon/radeon_drv.c
>>> index cb14213..88a45a0 100644
>>> --- a/drivers/gpu/drm/radeon/radeon_drv.c
>>> +++ b/drivers/gpu/drm/radeon/radeon_drv.c
>>> @@ -151,6 +151,9 @@ static inline void 
>>> radeon_register_atpx_handler(void) {}
>>>   static inline void radeon_unregister_atpx_handler(void) {}
>>>   #endif
>>>
>>> +extern bool radeon_kfd_init(void);
>>> +extern void radeon_kfd_fini(void);
>>> +
>>>   int radeon_no_wb;
>>>   int radeon_modeset = -1;
>>>   int radeon_dynclks = -1;
>>> @@ -630,12 +633,15 @@ static int __init radeon_init(void)
>>>   #endif
>>>       }
>>>
>>> +    radeon_kfd_init();
>>> +
>>>       /* let modprobe override vga console setting */
>>>       return drm_pci_init(driver, pdriver);
>>>   }
>>>
>>>   static void __exit radeon_exit(void)
>>>   {
>>> +    radeon_kfd_fini();
>>>       drm_pci_exit(driver, pdriver);
>>>       radeon_unregister_atpx_handler();
>>>   }
>>> diff --git a/drivers/gpu/drm/radeon/radeon_kms.c 
>>> b/drivers/gpu/drm/radeon/radeon_kms.c
>>> index 35d9318..0748284 100644
>>> --- a/drivers/gpu/drm/radeon/radeon_kms.c
>>> +++ b/drivers/gpu/drm/radeon/radeon_kms.c
>>> @@ -34,6 +34,10 @@
>>>   #include <linux/slab.h>
>>>   #include <linux/pm_runtime.h>
>>>
>>> +extern void radeon_kfd_device_probe(struct radeon_device *rdev);
>>> +extern void radeon_kfd_device_init(struct radeon_device *rdev);
>>> +extern void radeon_kfd_device_fini(struct radeon_device *rdev);
>>> +
>>>   #if defined(CONFIG_VGA_SWITCHEROO)
>>>   bool radeon_has_atpx(void);
>>>   #else
>>> @@ -63,6 +67,8 @@ int radeon_driver_unload_kms(struct drm_device *dev)
>>>
>>>       pm_runtime_get_sync(dev->dev);
>>>
>>> +    radeon_kfd_device_fini(rdev);
>>> +
>>>       radeon_acpi_fini(rdev);
>>>
>>>       radeon_modeset_fini(rdev);
>>> @@ -142,6 +148,9 @@ int radeon_driver_load_kms(struct drm_device 
>>> *dev, unsigned long flags)
>>>                   "Error during ACPI methods call\n");
>>>       }
>>>
>>> +    radeon_kfd_device_probe(rdev);
>>> +    radeon_kfd_device_init(rdev);
>>> +
>>>       if (radeon_is_px(dev)) {
>>>           pm_runtime_use_autosuspend(dev->dev);
>>>           pm_runtime_set_autosuspend_delay(dev->dev, 5000);
>>> -- 
>>> 1.9.1
>>>
>

