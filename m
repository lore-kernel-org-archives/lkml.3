Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbaGQL5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:57:38 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:5355
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754855AbaGQL5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:57:36 -0400
X-WSS-ID: 0N8UUJF-08-1HB-02
X-M-MSG: 
Message-ID: <53C7BA12.20703@amd.com>
Date: Thu, 17 Jul 2014 14:57:06 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, Oded Gabbay <oded.gabbay@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 08/83] drm/radeon: Add calls to initialize and finalize
 kfd from radeon
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	 <1405029027-6085-7-git-send-email-oded.gabbay@amd.com>
 <20140711163627.GI1870@gmail.com>
In-Reply-To: <20140711163627.GI1870@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(24454002)(479174003)(51704005)(106466001)(81542001)(81342001)(86362001)(76482001)(74662001)(102836001)(21056001)(97736001)(101416001)(4396001)(36756003)(46102001)(107046002)(105586002)(74502001)(83506001)(44976005)(77982001)(83322001)(54356999)(50986999)(23756003)(64126003)(76176999)(65816999)(99396002)(19580405001)(68736004)(95666004)(19580395003)(31966008)(85306003)(50466002)(65806001)(33656002)(80022001)(79102001)(84676001)(64706001)(92726001)(20776003)(47776003)(85852003)(92566001)(65956001)(83072002)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB044;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/14 19:36, Jerome Glisse wrote:
> On Fri, Jul 11, 2014 at 12:50:08AM +0300, Oded Gabbay wrote:
>> The KFD driver should be loaded when the radeon driver is loaded and
>> should be finalized when the radeon driver is removed.
>>
>> This patch adds a function call to initialize kfd from radeon_init
>> and a function call to finalize kfd from radeon_exit.
>>
>> If the KFD driver is not present in the system, the initialize call
>> fails and the radeon driver continues normally.
>>
>> This patch also adds calls to probe, initialize and finalize a kfd device
>> per radeon device using the kgd-->kfd interface.
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>
> It might be nice to allow to build radeon without HSA so i think an
> CONFIG_HSA should be added and have other thing depends on it.
> Otherwise this one is.
>
> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
>
We do allow it :)
There is no problem building radeon without the kfd. In that case, when radeon 
finds out that kfd is not available, it simply moves on with its initialization 
procedure.
	Oded
>
>> ---
>>   drivers/gpu/drm/radeon/radeon_drv.c | 6 ++++++
>>   drivers/gpu/drm/radeon/radeon_kms.c | 9 +++++++++
>>   2 files changed, 15 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
>> index cb14213..88a45a0 100644
>> --- a/drivers/gpu/drm/radeon/radeon_drv.c
>> +++ b/drivers/gpu/drm/radeon/radeon_drv.c
>> @@ -151,6 +151,9 @@ static inline void radeon_register_atpx_handler(void) {}
>>   static inline void radeon_unregister_atpx_handler(void) {}
>>   #endif
>>
>> +extern bool radeon_kfd_init(void);
>> +extern void radeon_kfd_fini(void);
>> +
>>   int radeon_no_wb;
>>   int radeon_modeset = -1;
>>   int radeon_dynclks = -1;
>> @@ -630,12 +633,15 @@ static int __init radeon_init(void)
>>   #endif
>>   	}
>>
>> +	radeon_kfd_init();
>> +
>>   	/* let modprobe override vga console setting */
>>   	return drm_pci_init(driver, pdriver);
>>   }
>>
>>   static void __exit radeon_exit(void)
>>   {
>> +	radeon_kfd_fini();
>>   	drm_pci_exit(driver, pdriver);
>>   	radeon_unregister_atpx_handler();
>>   }
>> diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
>> index 35d9318..0748284 100644
>> --- a/drivers/gpu/drm/radeon/radeon_kms.c
>> +++ b/drivers/gpu/drm/radeon/radeon_kms.c
>> @@ -34,6 +34,10 @@
>>   #include <linux/slab.h>
>>   #include <linux/pm_runtime.h>
>>
>> +extern void radeon_kfd_device_probe(struct radeon_device *rdev);
>> +extern void radeon_kfd_device_init(struct radeon_device *rdev);
>> +extern void radeon_kfd_device_fini(struct radeon_device *rdev);
>> +
>>   #if defined(CONFIG_VGA_SWITCHEROO)
>>   bool radeon_has_atpx(void);
>>   #else
>> @@ -63,6 +67,8 @@ int radeon_driver_unload_kms(struct drm_device *dev)
>>
>>   	pm_runtime_get_sync(dev->dev);
>>
>> +	radeon_kfd_device_fini(rdev);
>> +
>>   	radeon_acpi_fini(rdev);
>>   	
>>   	radeon_modeset_fini(rdev);
>> @@ -142,6 +148,9 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
>>   				"Error during ACPI methods call\n");
>>   	}
>>
>> +	radeon_kfd_device_probe(rdev);
>> +	radeon_kfd_device_init(rdev);
>> +
>>   	if (radeon_is_px(dev)) {
>>   		pm_runtime_use_autosuspend(dev->dev);
>>   		pm_runtime_set_autosuspend_delay(dev->dev, 5000);
>> --
>> 1.9.1
>>

