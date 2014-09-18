Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbaIRUGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:06:51 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33736 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756218AbaIRUGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:06:49 -0400
Date: Thu, 18 Sep 2014 21:06:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mmc: don't request CD IRQ until mmc_start_host()
Message-ID: <20140918200633.GC5182@n2100.arm.linux.org.uk>
References: <1410542338-24565-1-git-send-email-swarren@wwwdotorg.org> <CAPDyKFq63LKHKJ_1JD=SGU=V1eE-1105qPLy1EQtf=4k8dwKkA@mail.gmail.com> <5419E7B6.7020708@wwwdotorg.org> <541A6CAD.1020001@intel.com> <541B0ACA.6020808@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541B0ACA.6020808@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 10:39:38AM -0600, Stephen Warren wrote:
> On 09/17/2014 11:25 PM, Adrian Hunter wrote:
>> On 09/17/2014 10:57 PM, Stephen Warren wrote:
>>> On 09/17/2014 01:55 PM, Ulf Hansson wrote:
>>>> On 12 September 2014 19:18, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>>> From: Stephen Warren <swarren@nvidia.com>
>>>>>
>>>>> As soon as the CD IRQ is requested, it can trigger, since it's an
>>>>> externally controlled event. If it does, delayed_work host->detect will
>>>>> be scheduled.
>>>>>
>>>>> Many host controller probe()s are roughly structured as:
>>>>>
>>>>> *_probe() {
>>>>>       host = sdhci_pltfm_init();
>>>>>       mmc_of_parse(host->mmc);
>>>>>       rc = sdhci_add_host(host);
>>>>>       if (rc) {
>>>>>           sdhci_pltfm_free();
>>>>>           return rc;
>>>>>       }
>>>>>
>>>>> In 3.17, CD IRQs can are enabled quite early via *_probe() ->
>>>>> mmc_of_parse() -> mmc_gpio_request_cd() -> mmc_gpiod_request_cd_irq().
>>>>>
>>>>> Note that in linux-next, mmc_of_parse() calls mmc_gpio*d*_request_cd()
>>>>> rather than mmc_gpio_request_cd(), and mmc_gpio*d*_request_cd() doesn't
>>>>> call mmc_gpiod_request_cd_irq(). However, this issue still exists for
>>>>> any other direct users of mmc_gpio_request_cd().
>>>>>
>>>>> sdhci_add_host() may fail part way through (e.g. due to deferred
>>>>> probe for a vmmc regulator), and sdhci_pltfm_free() does nothing to
>>>>> unrequest the CD IRQ nor cancel the delayed_work. sdhci_pltfm_free() is
>>>>> coded to assume that if sdhci_add_host() failed, then the delayed_work
>>>>> cannot (or should not) have been triggered.
>>>>>
>>>>> This can lead to the following with CONFIG_DEBUG_OBJECTS_* enabled, when
>>>>> kfree(host) is eventually called inside sdhci_pltfm_free():
>>>>>
>>>>> WARNING: CPU: 2 PID: 6 at lib/debugobjects.c:263
>>>>> debug_print_object+0x8c/0xb4()
>>>>> ODEBUG: free active (active state 0) object type: timer_list hint:
>>>>> delayed_work_timer_fn+0x0/0x18
>>>>>
>>>>> The object being complained about is host->detect.
>>>>>
>>>>> There's no need to request the CD IRQ so early; mmc_start_host() already
>>>>> requests it, and I *assume* that mmc_start_host() is called somehow for
>>>>> all host controllers. For SDHCI hosts at least, the typical call path
>>>>> that does this is: *_probe() -> sdhci_add_host() -> mmc_add_host() ->
>>>>> mmc_start_host(). So, remove the call to mmc_gpiod_request_cd_irq() from
>>>>> mmc_gpio_request_cd(). This matches mmc_gpio*d*_request_cd(), which
>>>>> already doesn't call mmc_gpiod_request_cd_irq().
>>>>>
>>>>> This solves the problem (eliminates the kernel error message above),
>>>>> since it guarantees that the IRQ can't trigger before mmc_start_host()
>>>>> is called.
>>>>>
>>>>> The critical point here is that once sdhci_add_host() calls
>>>>> mmc_add_host() -> mmc_start_host(), sdhci_add_host() is coded not to
>>>>> fail. In other words, if there's a chance that mmc_start_host() may have
>>>>> been called, and CD IRQs triggered, and the delayed_work scheduled,
>>>>> sdhci_add_host() won't fail, and so cleanup is no longer via
>>>>> sdhci_pltfm_free() (which doesn't free the IRQ or cancel the work queue)
>>>>> but instead must be via sdhci_remove_host(), which calls mmc_remove_host()
>>>>> -> mmc_stop_host(), which does free the IRQ and cancel the work queue.
>>>>>
>>>>> This fixes what I might conclude to be a mistake in commit 740a221ef0e5
>>>>> ("mmc: slot-gpio: Add GPIO descriptor based CD GPIO API"), which added the
>>>>> call from mmc_start_host() to mmc_gpiod_request_cd_irq(), but also added
>>>>> incorrectly added a call from mmc_gpio_request_cd() to
>>>>> mmc_gpiod_request_cd_irq().
>>>>>
>>>>> CC: Russell King <linux@arm.linux.org.uk>
>>>>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>>>>> Cc: Alexandre Courbot <acourbot@nvidia.com>
>>>>> Cc: Linus Walleij <linus.walleij@linaro.org>
>>>>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>>>>
>>>> Hi Stephen,
>>>>
>>>> Thanks for looking into this. It seems like this issue has been
>>>> present for quite a while.
>>>> I believe your patch should have a stable tag for 3.15+ as well,
>>>> unless you object I will add it.
>>>
>>> Yes, that probably makes sense, thanks.
>>
>> Doesn't this patch break the drivers that call mmc_gpio_request_cd() after
>> mmc_add_host() like mmc_spi.c or sdhci-sirf.c or tmio_mmc_pio.c ?
>
> Oh, if there are drivers that do that, this patch might cause an issue.
>
> But why are they doing that? Shouldn't all the drivers set up the same  
> kinds of resources in the same order and way?

The way this /should/ work is that:

+ mmc_alloc_host() (and corresponding derivatives) should initialise
  everything into a safe state.

+ mmc_add_host() (and corresponding derivatives) publishes the host,
  and "enables" card discovery etc.

Host drivers should not do anything after mmc_add_host().  Yes, there's
buggy host drivers (particularly the sdhci crap - and even after my
mega patch set, the most friendly and positive term I have to describe
sdhci _is_ "crap") which oops the kernel if you (eg) receive a card
detect IRQ between those two calls, but that's really because the
host driver _is_ crap and not following proper driver initialisation
rules.

Someone /really/ needs to sort out MMC and stop this kind of driver
variability poliferating.  All drivers should be doing the same thing:

- allocate the host
- map the resources
- claim interrupts etc (it doesn't matter if you schedule the detect
  work, mmc_rescan won't process the event if mmc_add_host() hasn't
  been called)
- publish the host via mmc_add_host()

Looking through sdhci_add_host(), I notice this:

        mmc_add_host(mmc);

        pr_info("%s: SDHCI controller on %s [%s] using %s\n",
                mmc_hostname(mmc), host->hw_name, dev_name(mmc_dev(mmc)),
                (host->flags & SDHCI_USE_ADMA) ? "ADMA" :
                (host->flags & SDHCI_USE_SDMA) ? "DMA" : "PIO");

        sdhci_enable_card_detection(host);

        return 0;

However:

int mmc_add_host(struct mmc_host *host)
{
        int err;

        err = mmc_of_parse_child(host);
        if (err)
                return err;
...
        err = device_add(&host->class_dev);
        if (err)
                return err;

Like I say, it's crap...

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
