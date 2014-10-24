Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaJXMIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:08:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42429 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415AbaJXMIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:08:36 -0400
Message-ID: <544A410B.3050903@ti.com>
Date: Fri, 24 Oct 2014 15:07:39 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>, <ssantosh@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: keystone: pm: switch to use generic pm domains
References: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com>	<1413809764-21995-3-git-send-email-grygorii.strashko@ti.com>	<5446A065.9050308@gmail.com>	<544793B5.6080601@ti.com>	<CAPDyKFo97D3XbwDQrDzHw+qr4b24Fsq9EwDbdOMhy_L-RoYsLw@mail.gmail.com>	<CAMuHMdVsqsSHxirzoWspGz7y+2qBk42p-VUBNkys3_rr6Th_9Q@mail.gmail.com>	<CAPDyKFp6T1a1XXHdxiubP2RaS26uSqkUS3rbBgsNV_y+dSFfvw@mail.gmail.com>	<CAMuHMdVO4nMoeYdzLf6wdKW876gYVyML3C2+QKoteGPtisD4sA@mail.gmail.com>	<CAPDyKFrVCczc+fSy1ax4XinhB4SMfZZWP=d4QdY5Lv4zjOrHPA@mail.gmail.com>	<544912AB.3050801@ti.com> <CAPDyKFpwguzd_iy46mpPcwDs98bh1k_3fVNfe4UAjYYwNoBJPQ@mail.gmail.com>
In-Reply-To: <CAPDyKFpwguzd_iy46mpPcwDs98bh1k_3fVNfe4UAjYYwNoBJPQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On 10/24/2014 12:53 PM, Ulf Hansson wrote:
> On 23 October 2014 16:37, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>> On 10/23/2014 11:11 AM, Ulf Hansson wrote:
>>> On 22 October 2014 17:44, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>> On Wed, Oct 22, 2014 at 5:28 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>>>>> On 22 October 2014 17:09, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>>>> On Wed, Oct 22, 2014 at 5:01 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>>>>>>>>>> +void keystone_pm_domain_attach_dev(struct device *dev)
>>>>>>>>>>     {
>>>>>>>>>> +    struct clk *clk;
>>>>>>>>>>         int ret;
>>>>>>>>>> +    int i = 0;
>>>>>>>>>>
>>>>>>>>>>         dev_dbg(dev, "%s\n", __func__);
>>>>>>>>>>
>>>>>>>>>> -    ret = pm_generic_runtime_suspend(dev);
>>>>>>>>>> -    if (ret)
>>>>>>>>>> -        return ret;
>>>>>>>>>> -
>>>>>>>>>> -    ret = pm_clk_suspend(dev);
>>>>>>>>>> +    ret = pm_clk_create(dev);
>>>>>>>>>>         if (ret) {
>>>>>>>>>> -        pm_generic_runtime_resume(dev);
>>>>>>>>>> -        return ret;
>>>>>>>>>> +        dev_err(dev, "pm_clk_create failed %d\n", ret);
>>>>>>>>>> +        return;
>>>>>>>>>> +    };
>>>>>>>>>> +
>>>>>>>>>> +    while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
>>>>>>>>>> +        ret = pm_clk_add_clk(dev, clk);
>>>>>>>>>> +        if (ret) {
>>>>>>>>>> +            dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
>>>>>>>>>> +            goto clk_err;
>>>>>>>>>> +        };
>>>>>>>>>>         }
>>>>>>>>>>
>>>>>>>>>> -    return 0;
>>>>>>>>>> +    if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
>>>>>>>>> Can we not okkup two seperate callbacks instead of above check ?
>>>>>>>>> I don't like this CONFIG check here. Its slightly better version of
>>>>>>>>> ifdef in middle of the code.
>>>>>>>>
>>>>>>>> I've found more-less similar comment on patch
>>>>>>>> "Re: [PATCH v3 1/3] power-domain: add power domain drivers for Rockchip platform"
>>>>>>>> https://lkml.org/lkml/2014/10/17/257
>>>>>>>>
>>>>>>>> So, Would you like me to create patch which will enable clocks in pm_clk_add/_clk()
>>>>>>>> in case !IS_ENABLED(CONFIG_PM_RUNTIME)
>>>>>>>
>>>>>>> I am wondering whether we actually should/could do this, no matter of
>>>>>>> CONFIG_PM_RUNTIME.
>>>>>>>
>>>>>>> Typically, for configurations that uses CONFIG_PM_RUNTIME, the PM
>>>>>>> clocks through pm_clk_suspend(), will be gated once the device becomes
>>>>>>> runtime PM suspended. Right?
>>>>>>
>>>>>> Doing it unconditionally means we'll have lots of unneeded clocks running
>>>>>> for a short while.
>>>>
>>>>> As long as the pm_clk_add() is being invoked from the ->attach_dev()
>>>>> callback, we are in the probe path. Certainly we would like to have
>>>>> clocks enabled while probing, don't you think?
>>>>>
>>>>> If we wouldn't enable the clocks for CONFIG_PM_RUNTIME, when will
>>>>> those be enabled?
>>>>
>>>> They will be enabled when the driver does
>>>>
>>>>           pm_runtime_enable(dev);
>>>>           pm_runtime_get_sync(dev);
>>>>
>>>> in its .probe() method.
>>>
>>> No! This doesn't work for drivers which have used
>>> pm_runtime_set_active() prior pm_runtime_enable().
>>
>> Sorry, but some misunderstanding is here:
>> 1) If some code call pm_runtime_set_active() it has to ensure
>> that all PM resources switched to ON state. All! So, it will
>> be ok to call enable & get after that - these functions will only
>> adjust counters.
> 
> Correct.
> 
> This is also the key problem with your approach. You requires a
> pm_runtime_get_sync() to trigger the runtime PM resume callbacks to be
> invoked. That's a fragile design.

Sorry, but what I'm expecting is that these APIs will work according to
documentation - nothing specific actually :) And for Paltform bus devices
it's usual way to enable device.

> 
> The solution that I propose is to "manually" enable your PM clks
> during the probe sequence. We can do that as a part of pm_clk_add() or

Done in patch set 3 - but only if !CONFIG_PM_RUNTIME

> we invoke pm_clk_resume() separately, but more important no matter of
> CONFIG_PM_RUNTIME.
> 

Why? What benefits will be doing this if CONFIG_PM_RUNTIME=y?
For Keystone 2 CONFIG_PM_RUNTIME=y is intended to be normal operational mode and 
all devices belongs to Platform bus.

Also, device's resuming operation is usually heavy operation and, taking into
account deferred probing mechanism and usual implementation of .probe() function,
your proposition will lead to runtime overhead at least for Platform devices.

What is usually done in probe:
<- here you propose to resume device

1) get resources (IO, IRQ, regulators, GPIO, phys, ..) - for each
resource -EPROBE_DEFER can be returned.

2) allocate and fill device context - can fail.

3) configure resources (set gpio, enable regulators or phys,..) - can fail

4) [now] resume device 

5) configure device

6) setup irq
 
7) [optional] suspend device

As you can see from above, the Platform devices aren't need to be enabled before step 5 and, 
if your proposition will be accepted, it will lead to few additional resume/suspend
cycles per-device. It's not good as for me. Is it?


> The driver could then be responsible to invoke pm_runtime_set_active()
> to reflect that all runtime PM resources are enabled.

[runtime_pm.txt] - this is recovery function and caller should be very careful.
 
Again, from implementation point of view:
-- how it's done now:
    .probe()
	pm_runtime_enable(&pdev->dev);
	pm_runtime_get_sync(&pdev->dev);

    .remove()
	pm_runtime_put_sync(&pdev->dev);
	pm_runtime_disable(&pdev->dev);

-- how it will be:
     .probe()
	//pm_runtime_enable(&pdev->dev);
	//pm_runtime_get_sync(&pdev->dev);

	[optional] call .runtime_resume();

	pm_runtime_set_active(dev);
	pm_runtime_enable(dev);
	[optional, to keep device active] pm_runtime_get_sync()

     .remove()
	[optional] pm_runtime_put_sync(&pdev->dev);
	pm_runtime_disable(&pdev->dev);
	
	call .runtime_suspend();
	pm_runtime_set_suspended(dev);

And that would need to be done for all drivers.

> 
>>
>> 2) if CONFIG_PM_RUNTIME=n the pm_runtime_set_active() will
>> be empty (see pm_runtime.h) and you can't relay on it.
>>
>> 3) if CONFIG_PM_RUNTIME=n the pm_runtime_enable/disable() will
>> be empty - and disable_depth == 1 all the time.
>>
>> In my case, the combination of generic PD and PM clock framework
>> will do everything I need for both cases CONFIG_PM_RUNTIME=y/n.
>>
>> PM domain attach_dev/detach_dev callbacks - will fill PM resources
>> and enable them if CONFIG_PM_RUNTIME=n.
>>
>> if CONFIG_PM_RUNTIME - PM resources will be enabled/disabled
>> by Runtime PM through .start()/.stop() callbacks.
>>
>> And seems suspend/resume will work too - can't try it now, but it
>> should work, because .start()/.stop() callbacks have to be called
>> from pm_genpd_suspend_noirq.
>>
>>
>>>
>>> That should also be a common good practice for most drivers, otherwise
>>> they wouldn’t work unless CONFIG_PM_RUNTIME is enabled.
>>>
>>> Please have a look at the following patchset, which is fixing up one
>>> driver to behave better.
>>> http://marc.info/?l=linux-pm&m=141327095713390&w=2
>>
>> It always was (and seems will) a big challenge to support both
>> CONFIG_PM_RUNTIME=y and system suspend in drivers ;), especially if driver was
>> initially created using Runtime PM centric approach.
>>
>> But, for the case CONFIG_PM_RUNTIME + !CONFIG_PM_RUNTIME + suspend...
>> It will be painful :..((
> 
> I agree to that this _has_ been an issue. It also remarkable that
> people have been just accepting that for so long.
> 
> Now, we have added the pm_runtime_force_suspend|resume() helpers.
> Those will help to solve these cases.
> 
>>
>>
>> For example your patches (may be I'm not fully understand your problem,
>> so here are just comments to code):
>> patch 3:
>>    - I think you can do smth like this in probe
>>          ret = pm_runtime_get_sync(&pdev->dev);
>>          if (ret < 0)
>>                  goto err_m2m;
> 
> This is wrong!
> 
> 1) It will break the driver for !CONFIG_PM_RUNTIME.

Hm. It should work. In your driver you have (for the case !CONFIG_PM_RUNTIME):
	pm_runtime_enable(dev); ------------------------ NOP
	ret = pm_runtime_get_sync(&pdev->dev); --------- NOP
	if (ret < 0)
		goto err_m2m;
so, if you add:
	if (!pm_runtime_enabled(dev)) { ---------------- always FALSE
               gsc_runtime_resume(dev); 
	       /* ^ is the same as
		gsc_hw_set_sw_reset(gsc);
		gsc_wait_reset(gsc);
		gsc_m2m_resume(gsc);
	       */
       }
it will work in both cases, because pm_runtime_enabled() == true
when  CONFIG_PM_RUNTIME=y.

> 
> 2) It would also be broken for CONFIG_PM_RUNTIME for the scenario
> where a bus also handles runtime PM resources.
> Typically from the bus' ->probe() this is done:
> pm_runtime_get_noresume()
> pm_runtime_set_active()

So, Has your device been enabled by bus?

> 
> As stated earlier, we shouldn't require the runtime PM resume callback
> to be invoked just because a pm_runtime_get_sync(). It's fragile.
> 
>> +
>> +       if (!pm_runtime_enabled(dev)) {
>> +               gsc_runtime_resume(dev);
>> +       }
>>
>>   - and similar thing in remove, before pm_runtime_disable
>>
>> patch 5 - pm_runtime_force_suspend/resume() will not take into
>> account or change Runtime PM state of the device if !CONFIG_PM_RUNTIME.
>> runtime_status == RPM_SUSPENDED always in this case!
>> So, there may be some side-effects.
> 
> pm_runtime_status_suspended() will always return false for !CONFIG_PM_RUNTIME.

Nice workaround.

> 
> There are no side effects as long as you have defined your runtime PM
> callbacks within CONFIG_PM. SET_PM_RUNTIME_PM_OPS() also helps out
> here.
> 
>>
>> patch 7 - you can't call clk_prepare/unprepare from Runtime PM
>> callbacks, because they aren't atomic
> 
> If the runtime PM callbacks are invoked in atomic context, the driver
> needs to tell the runtime PM core about it. That's done through,
> pm_runtime_irq_safe(), which it doesn't.
> 
>>
>> Oh, You definitely will be enjoyed ;)
> 
> Likely you to. :-)

Oh. Yes definitely :) I'm trying to reuse what is already in kernel
(even not to implement smth. new) more then 3 months already :( - It's sad.

regards,
-grygorii

