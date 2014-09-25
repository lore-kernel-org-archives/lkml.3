Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaIYCHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:07:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:10357 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaIYCHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:07:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,593,1406617200"; 
   d="scan'208";a="578589250"
Message-ID: <542378F0.6070303@linux.intel.com>
Date: Thu, 25 Sep 2014 10:07:44 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / platform / LPSS: disable async suspend/resume
 of LPSS devices
References: <540E91F0.2060306@linux.intel.com> <2190534.fECTUJ0MGh@vostro.rjw.lan> <5422E0FA.5090600@linux.intel.com> <13208235.eyDL0NsKvo@vostro.rjw.lan>
In-Reply-To: <13208235.eyDL0NsKvo@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/25 4:32, Rafael J. Wysocki wrote:
> On Wednesday, September 24, 2014 11:19:22 PM Fu, Zhonghui wrote:
>> This is a multi-part message in MIME format.
>> --------------040808000309050202010005
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 7bit
>>
>>
>> On 2014/9/23 7:17, Rafael J. Wysocki wrote:
>>> On Monday, September 22, 2014 10:45:42 PM Fu, Zhonghui wrote:
>>> [cut]
>>>
>>>>>>> This operation is reading data from Operation Region of one operand object in name space. I don't know the reason of hang at this point. Could you please give out some explanation about this?
>>>>>> I don't know the exact reason why this particular read hangs, but this means
>>>>>> that, perhaps, instead of disabling async suspend/resume for all LPSS devices
>>>>>> altogether, perhaps we can serialize their acpi_dev_resume_early()?
>>>>>>
>>>>>> Rafael
>>>>> Do you mean keeping other phases(prepare, suspend, suspend_late, suspend_noirq, resume_noirq, resume, complete) of suspend/resume asynchronous, and only serializing "resume_early" phase for all LPSS devices?
>>>>>
>>>>> Thanks,
>>>>> Zhonghui
>>>> Hi, Rafael
>>>>
>>>> Could you please confirm my understanding?
>>> This is not what I meant.
>>>
>>> Since we have a PM domain for the LPSS devices already, why don't we add an
>>> internal lock to that PM domain and acquire it over executing either
>>> acpi_dev_suspend_late() (during suspend) or acpi_dev_resume_early() (during
>>> resume) for all of them?
>> I seem find the root cause of this issue. Because this "hang" issue is occurred on ASUS T100(Baytrail-T platform), so I checked its DSDT and found that URT and I2C controllers depend on(_DEP) PEPD device(description in Windows is "power engine plug-in"). That is, URT and I2C controllers can not transition to ACPI_STATE_D0 state until PEPD device has completed this transition during resuming. But, the ACPI subsystem in the 3.16 kernel doesn't support "_DEP" feature. So, if enabling async suspend/resume for LPSS devices, their "_DEP" relationship with PEPD device will be broken and incur "hang" during the transition to ACPI_STATE_D0, please see the following code, it is from dpm_resume_early function in drivers/base/power/main.c file:
>>
>> list_for_each_entry(dev, &dpm_late_early_list, power.entry) {
>>                 reinit_completion(&dev->power.completion);
>>                 if (is_async(dev)) {
>>                         get_device(dev);
>>                         async_schedule(async_resume_early, dev);
>>                 }
>>         }
>>
>>         while (!list_empty(&dpm_late_early_list)) {
>>                 dev = to_device(dpm_late_early_list.next);
>>                 get_device(dev);
>>                 list_move_tail(&dev->power.entry, &dpm_suspended_list);
>>                 mutex_unlock(&dpm_list_mtx);
>>
>>                 if (!is_async(dev)) {    // PEPD is not configured as async device now.
>>                         int error;
>>
>>                         error = device_resume_early(dev, state, false);
>>                         if (error) {
>>                                 suspend_stats.failed_resume_early++;
>>                                 dpm_save_failed_step(SUSPEND_RESUME_EARLY);
>>                                 dpm_save_failed_dev(dev_name(dev));
>>                                 pm_dev_err(dev, state, " early", error);
>>                         }
>>                 }
>>                 mutex_lock(&dpm_list_mtx);
>>                 put_device(dev);
>>         }
>>
>>
>> Based on the above analysis,I move the resume_early operation of PEPD device to head of dpm_resume_early function and "hang" did not occur any more during resuming(I tested this 10 times).
>>
>> If disabling async suspend/resume for LPSS devices, PEPD device will be prior to UART and I2C controllers in dpm_late_early_list list and the "_DEP" relationship can be kept. Maybe,the "_DEP" ACPI feature will be supported in future kernel, so, I think simply disabling async suspend/resume for LPSS devices is a acceptable workaround now, and need not add new mechanism to deal with this issue.
>>
>> BTW, I will take two week's leave and can't reply email during this time. Sorry.
> 
> OK, thanks for the analysis.  In that case we really may be better off by
> disabling the runtime PM of LPSS devices for now until we figure out how this
> can be addressed properly.

Please let me know if the patch need to be refined, I can do it before
October 1st, then one-week Chinese National holiday.

Besides this patch, we leave the non-LPSS devices as async
suspend/resume, the risk is unknown. I wonder if we need to make
pm_async parameter configurable thru kernel command line to make android
userspace happy?

Thanks,
-Aubrey

> 
> Rafael
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

