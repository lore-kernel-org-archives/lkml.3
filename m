Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaKMTbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:31:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57105 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbaKMTbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:31:41 -0500
Message-ID: <546506F1.1020306@ti.com>
Date: Thu, 13 Nov 2014 21:30:57 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Linux PM list <linux-pm@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
Subject: Re: [PATCH] PM / Domains: restore calling of .suspend/resume_noirq()
 callbacks
References: <1415808047-23455-1-git-send-email-grygorii.strashko@ti.com>	<2997289.NEH22PNoYM@vostro.rjw.lan>	<5464FBCC.7060307@ti.com> <CAMuHMdV2JdEhvMsOahaMH8RUO12sit_39AfcWUFD9eGCYCCKGA@mail.gmail.com>
In-Reply-To: <CAMuHMdV2JdEhvMsOahaMH8RUO12sit_39AfcWUFD9eGCYCCKGA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 09:11 PM, Geert Uytterhoeven wrote:
> On Thu, Nov 13, 2014 at 7:43 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>> On 11/13/2014 03:33 AM, Rafael J. Wysocki wrote:
>>> On Wednesday, November 12, 2014 06:00:47 PM Grygorii Strashko wrote:
>>>> Now .suspend/resume_noirq() callbacks will not be called during
>>>> system wide suspend/resume for devices which belongs to some GPD.
>>>> It seems, that this change was accidentally introduced by
>>>> commit d23b9b00cdde ("PM / Domains: Rework system suspend callback
>>>>    routines (v2)").
>>>
>>> I'm not sure if that was really accidentally.
>>>
>>> Can you describe the problem that the change below is attempting to
>>> address, without going to much into the history?  IOW, what's that
>>> doesn't work right now?
>>
>> There are no real issues - now in Kernel there are no users of GPD
>> which use "noirq" callbacks.
> 
> Indeed.
> 
> But as the .suspend_noirq() and .resume_noirq() callbacks are not called
> when using the generic PM domain, I had to manually handle interrupt
> disable/enable in commit a00d91ea264f974b ("fbdev: sh_mobile_hdmi:
> Re-init regs before irq re-enable on resume").

^ Honestly, this is very useful practice, because with SMP enabled
the IRQ can be triggered after .suspend() and before .suspend_noirq()
which, in turn, may schedule some kthread/work or even threaded_irq_handler
on secondary cpus (disable_nonboot_cpus() is called after suspend_noirq stage).

Funny things may happen after that :P like: some work/thread which is 
servicing request from I2C device (for example) will be frozen in the middle of
its execution and then it will be resumed right after enable_nonboot_cpus().

^Issue from real life.

regards,
-grygorii
