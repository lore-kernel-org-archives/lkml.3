Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaIXUNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:13:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53531 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751710AbaIXUNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:13:05 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices
Date: Wed, 24 Sep 2014 22:32:54 +0200
Message-ID: <13208235.eyDL0NsKvo@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5422E0FA.5090600@linux.intel.com>
References: <540E91F0.2060306@linux.intel.com> <2190534.fECTUJ0MGh@vostro.rjw.lan> <5422E0FA.5090600@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 24, 2014 11:19:22 PM Fu, Zhonghui wrote:
> This is a multi-part message in MIME format.
> --------------040808000309050202010005
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 7bit
> 
> 
> On 2014/9/23 7:17, Rafael J. Wysocki wrote:
> > On Monday, September 22, 2014 10:45:42 PM Fu, Zhonghui wrote:
> > [cut]
> >
> >>>>> This operation is reading data from Operation Region of one operand object in name space. I don't know the reason of hang at this point. Could you please give out some explanation about this?
> >>>> I don't know the exact reason why this particular read hangs, but this means
> >>>> that, perhaps, instead of disabling async suspend/resume for all LPSS devices
> >>>> altogether, perhaps we can serialize their acpi_dev_resume_early()?
> >>>>
> >>>> Rafael
> >>> Do you mean keeping other phases(prepare, suspend, suspend_late, suspend_noirq, resume_noirq, resume, complete) of suspend/resume asynchronous, and only serializing "resume_early" phase for all LPSS devices?
> >>>
> >>> Thanks,
> >>> Zhonghui
> >> Hi, Rafael
> >>
> >> Could you please confirm my understanding?
> > This is not what I meant.
> >
> > Since we have a PM domain for the LPSS devices already, why don't we add an
> > internal lock to that PM domain and acquire it over executing either
> > acpi_dev_suspend_late() (during suspend) or acpi_dev_resume_early() (during
> > resume) for all of them?
> I seem find the root cause of this issue. Because this "hang" issue is occurred on ASUS T100(Baytrail-T platform), so I checked its DSDT and found that URT and I2C controllers depend on(_DEP) PEPD device(description in Windows is "power engine plug-in"). That is, URT and I2C controllers can not transition to ACPI_STATE_D0 state until PEPD device has completed this transition during resuming. But, the ACPI subsystem in the 3.16 kernel doesn't support "_DEP" feature. So, if enabling async suspend/resume for LPSS devices, their "_DEP" relationship with PEPD device will be broken and incur "hang" during the transition to ACPI_STATE_D0, please see the following code, it is from dpm_resume_early function in drivers/base/power/main.c file:
> 
> list_for_each_entry(dev, &dpm_late_early_list, power.entry) {
>                 reinit_completion(&dev->power.completion);
>                 if (is_async(dev)) {
>                         get_device(dev);
>                         async_schedule(async_resume_early, dev);
>                 }
>         }
> 
>         while (!list_empty(&dpm_late_early_list)) {
>                 dev = to_device(dpm_late_early_list.next);
>                 get_device(dev);
>                 list_move_tail(&dev->power.entry, &dpm_suspended_list);
>                 mutex_unlock(&dpm_list_mtx);
> 
>                 if (!is_async(dev)) {    // PEPD is not configured as async device now.
>                         int error;
> 
>                         error = device_resume_early(dev, state, false);
>                         if (error) {
>                                 suspend_stats.failed_resume_early++;
>                                 dpm_save_failed_step(SUSPEND_RESUME_EARLY);
>                                 dpm_save_failed_dev(dev_name(dev));
>                                 pm_dev_err(dev, state, " early", error);
>                         }
>                 }
>                 mutex_lock(&dpm_list_mtx);
>                 put_device(dev);
>         }
> 
> 
> Based on the above analysis,I move the resume_early operation of PEPD device to head of dpm_resume_early function and "hang" did not occur any more during resuming(I tested this 10 times).
> 
> If disabling async suspend/resume for LPSS devices, PEPD device will be prior to UART and I2C controllers in dpm_late_early_list list and the "_DEP" relationship can be kept. Maybe,the "_DEP" ACPI feature will be supported in future kernel, so, I think simply disabling async suspend/resume for LPSS devices is a acceptable workaround now, and need not add new mechanism to deal with this issue.
> 
> BTW, I will take two week's leave and can't reply email during this time. Sorry.

OK, thanks for the analysis.  In that case we really may be better off by
disabling the runtime PM of LPSS devices for now until we figure out how this
can be addressed properly.

Rafael

