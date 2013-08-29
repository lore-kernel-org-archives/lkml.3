Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3H2S1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:27:54 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:39205 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3H2S1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:27:53 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1308291250350.2723@math.ut.ee>
References: <alpine.SOC.1.00.1307310017380.19288@math.ut.ee>
	<alpine.SOC.1.00.1308191158220.19642@math.ut.ee>
	<alpine.SOC.1.00.1308291017030.2723@math.ut.ee>
	<20130829092935.GB2235@swordfish>
	<alpine.SOC.1.00.1308291250350.2723@math.ut.ee>
Date: Thu, 29 Aug 2013 14:27:52 -0400
Message-ID: <CADnq5_OPQD68o80ZGZODOxR3V2M7dU1xEYEhqjDKPcqgGwWYeQ@mail.gmail.com>
Subject: Re: [PATCH] radeon kms: fix uninitialised hotplug work usage in r100_irq_process()
From: Alex Deucher <alexdeucher@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 6:55 AM, Meelis Roos <mroos@linux.ee> wrote:
>> Reported-by: Meelis Roos <mroos@linux.ee>
>> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>
> It works, thank you for quick response!
>
> Tested-by: Meelis Roos <mroos@linux.ee>

Thanks.  I've added it to my patch queue.

Alex

>
>>  drivers/gpu/drm/radeon/radeon_irq_kms.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
>> index 081886b..cc9e848 100644
>> --- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
>> +++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
>> @@ -275,17 +275,19 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
>>                       dev_info(rdev->dev, "radeon: using MSI.\n");
>>               }
>>       }
>> +
>> +     INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
>> +     INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
>> +     INIT_WORK(&rdev->reset_work, radeon_irq_reset_work_func);
>> +
>>       rdev->irq.installed = true;
>>       r = drm_irq_install(rdev->ddev);
>>       if (r) {
>>               rdev->irq.installed = false;
>> +             flush_work(&rdev->hotplug_work);
>>               return r;
>>       }
>>
>> -     INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
>> -     INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
>> -     INIT_WORK(&rdev->reset_work, radeon_irq_reset_work_func);
>> -
>>       DRM_INFO("radeon: irq initialized.\n");
>>       return 0;
>>  }
>>
>
> --
> Meelis Roos (mroos@linux.ee)
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
