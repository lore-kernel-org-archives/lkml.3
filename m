Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaJ0Jjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:39:46 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:42775 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaJ0Jjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:39:44 -0400
MIME-Version: 1.0
In-Reply-To: <544A410B.3050903@ti.com>
References: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com>
	<1413809764-21995-3-git-send-email-grygorii.strashko@ti.com>
	<5446A065.9050308@gmail.com>
	<544793B5.6080601@ti.com>
	<CAPDyKFo97D3XbwDQrDzHw+qr4b24Fsq9EwDbdOMhy_L-RoYsLw@mail.gmail.com>
	<CAMuHMdVsqsSHxirzoWspGz7y+2qBk42p-VUBNkys3_rr6Th_9Q@mail.gmail.com>
	<CAPDyKFp6T1a1XXHdxiubP2RaS26uSqkUS3rbBgsNV_y+dSFfvw@mail.gmail.com>
	<CAMuHMdVO4nMoeYdzLf6wdKW876gYVyML3C2+QKoteGPtisD4sA@mail.gmail.com>
	<CAPDyKFrVCczc+fSy1ax4XinhB4SMfZZWP=d4QdY5Lv4zjOrHPA@mail.gmail.com>
	<544912AB.3050801@ti.com>
	<CAPDyKFpwguzd_iy46mpPcwDs98bh1k_3fVNfe4UAjYYwNoBJPQ@mail.gmail.com>
	<544A410B.3050903@ti.com>
Date: Mon, 27 Oct 2014 10:39:43 +0100
Message-ID: <CAPDyKFpdoA=cZYKuUCigyzfBARtkt5tfwhvJp2MaChTA9E+eRw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: keystone: pm: switch to use generic pm domains
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>, ssantosh@kernel.org,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

[...]

>>
>> The solution that I propose is to "manually" enable your PM clks
>> during the probe sequence. We can do that as a part of pm_clk_add() or
>
> Done in patch set 3 - but only if !CONFIG_PM_RUNTIME
>
>> we invoke pm_clk_resume() separately, but more important no matter of
>> CONFIG_PM_RUNTIME.
>>
> Why? What benefits will be doing this if CONFIG_PM_RUNTIME=y?
> For Keystone 2 CONFIG_PM_RUNTIME=y is intended to be normal operational mode and
> all devices belongs to Platform bus.
>
> Also, device's resuming operation is usually heavy operation and, taking into
> account deferred probing mechanism and usual implementation of .probe() function,
> your proposition will lead to runtime overhead at least for Platform devices.

I don't quite follow. Why should there be an overhead?

>
> What is usually done in probe:
> <- here you propose to resume device

I didn't suggest we should resume the device here.

I said we should enable the device's PM clocks during ->probe().
That's a different thing.

>
> 1) get resources (IO, IRQ, regulators, GPIO, phys, ..) - for each
> resource -EPROBE_DEFER can be returned.
>
> 2) allocate and fill device context - can fail.

For your information, writing/reading to the device's registers might
not be safe, unless its PM domain is powered.

>
> 3) configure resources (set gpio, enable regulators or phys,..) - can fail
>
> 4) [now] resume device
>
> 5) configure device
>
> 6) setup irq
>
> 7) [optional] suspend device
>
> As you can see from above, the Platform devices aren't need to be enabled before step 5 and,
> if your proposition will be accepted, it will lead to few additional resume/suspend
> cycles per-device. It's not good as for me. Is it?

Why will it lead to a few additional resume/suspend cycles per device?
I don't follow.

>
>
>> The driver could then be responsible to invoke pm_runtime_set_active()
>> to reflect that all runtime PM resources are enabled.
>
> [runtime_pm.txt] - this is recovery function and caller should be very careful.

What? I couldn't find this stated anywhere in the documentation.

This is what's stated though:

5. Runtime PM Initialization, Device Probing and Removal
[...]
In addition to that, the initial runtime PM status of all devices is
'suspended', but it need not reflect the actual physical state of the device.
Thus, if the device is initially active (i.e. it is able to process I/O), its
runtime PM status must be changed to 'active', with the help of
pm_runtime_set_active(), before pm_runtime_enable() is called for the device.
[...]

>
> Again, from implementation point of view:
> -- how it's done now:
>     .probe()
>         pm_runtime_enable(&pdev->dev);
>         pm_runtime_get_sync(&pdev->dev);
>
>     .remove()
>         pm_runtime_put_sync(&pdev->dev);
>         pm_runtime_disable(&pdev->dev);
>
> -- how it will be:
>      .probe()
>         //pm_runtime_enable(&pdev->dev);
>         //pm_runtime_get_sync(&pdev->dev);
>
>         [optional] call .runtime_resume();
>
>         pm_runtime_set_active(dev);
>         pm_runtime_enable(dev);
>         [optional, to keep device active] pm_runtime_get_sync()
>
>      .remove()
>         [optional] pm_runtime_put_sync(&pdev->dev);
>         pm_runtime_disable(&pdev->dev);
>
>         call .runtime_suspend();
>         pm_runtime_set_suspended(dev);
>
> And that would need to be done for all drivers.

I can't tell the number of drivers you are referring to and how big
impact it would have. Could you maybe summarize which drivers you are
concerned about?

I guess, if we have screwed things up regarding the runtime PM support
for some drivers, we need to fix them. I am also happy to help.

[...]

>> This is wrong!
>>
>> 1) It will break the driver for !CONFIG_PM_RUNTIME.
>
> Hm. It should work. In your driver you have (for the case !CONFIG_PM_RUNTIME):
>         pm_runtime_enable(dev); ------------------------ NOP
>         ret = pm_runtime_get_sync(&pdev->dev); --------- NOP
>         if (ret < 0)
>                 goto err_m2m;
> so, if you add:
>         if (!pm_runtime_enabled(dev)) { ---------------- always FALSE
>                gsc_runtime_resume(dev);
>                /* ^ is the same as
>                 gsc_hw_set_sw_reset(gsc);
>                 gsc_wait_reset(gsc);
>                 gsc_m2m_resume(gsc);
>                */
>        }
> it will work in both cases, because pm_runtime_enabled() == true
> when  CONFIG_PM_RUNTIME=y.

So this might work for some cases and for some not. As stated earlier,
it won't work if the device is runtime PM active.

The better solution is the follow my proposal and thus also conform to
the runtime PM documentation for how ->probe() should be done.

>
>>
>> 2) It would also be broken for CONFIG_PM_RUNTIME for the scenario
>> where a bus also handles runtime PM resources.
>> Typically from the bus' ->probe() this is done:
>> pm_runtime_get_noresume()
>> pm_runtime_set_active()
>
> So, Has your device been enabled by bus?

Yes we have examples of that. drivers/amba/bus.c.

Kind regards
Uffe
