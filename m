Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3KSLeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:34:21 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51451 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3KSLeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:34:19 -0500
MIME-Version: 1.0
In-Reply-To: <87ob5lnwz8.fsf@linaro.org>
References: <1384297710-29694-1-git-send-email-nm@ti.com>
	<1384448716-3186-1-git-send-email-nm@ti.com>
	<alpine.DEB.2.02.1311150806220.15980@utopia.booyaka.com>
	<528621E5.4030201@ti.com>
	<20131115143736.GW10317@atomide.com>
	<87ob5lnwz8.fsf@linaro.org>
Date: Tue, 19 Nov 2013 12:34:18 +0100
Message-ID: <CAPDyKFrgGn91151SuAfirpcT48fvXeDup9OxqnkiWkk9UBvxeA@mail.gmail.com>
Subject: Re: [PATCH V3] ARM: OMAP2+: omap_device: maintain sane runtime pm
 status around suspend/resume
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Rajendra Nayak <rnayak@ti.com>,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2013 23:03, Kevin Hilman <khilman@linaro.org> wrote:
> Tony Lindgren <tony@atomide.com> writes:
>
>> * Nishanth Menon <nm@ti.com> [131115 05:30]:
>>> On 11/15/2013 02:07 AM, Paul Walmsley wrote:
>>> > On Thu, 14 Nov 2013, Nishanth Menon wrote:
>>> >
>>> >> OMAP device hooks around suspend|resume_noirq ensures that hwmod
>>> >> devices are forced to idle using omap_device_idle/enable as part of
>>> >> the last stage of suspend activity.
>>> >>
>>> >> For a device such as i2c who uses autosuspend, it is possible to enter
>>> >> the suspend path with dev->power.runtime_status = RPM_ACTIVE.
>>> >>
>>> >> As part of the suspend flow, the generic runtime logic would increment
>>> >> it's dev->power.disable_depth to 1. This should prevent further
>>> >> pm_runtime_get_sync from succeeding once the runtime_status has been
>>> >> set to RPM_SUSPENDED.
>>> >>
>>> >> Now, as part of the suspend_noirq handler in omap_device, we force the
>>> >> following: if the device status is !suspended, we force the device
>>> >> to idle using omap_device_idle (clocks are cut etc..). This ensures
>>> >> that from a hardware perspective, the device is "suspended". However,
>>> >> runtime_status is left to be active.
>>> >>
>>> >> *if* an operation is attempted after this point to
>>> >> pm_runtime_get_sync, runtime framework depends on runtime_status to
>>> >> indicate accurately the device status, and since it sees it to be
>>> >> ACTIVE, it assumes the module is functional and returns a non-error
>>> >> value. As a result the user will see pm_runtime_get succeed, however a
>>> >> register access will crash due to the lack of clocks.
>>> >>
>>> >> To prevent this from happening, we should ensure that runtime_status
>>> >> exactly indicates the device status. As a result of this change
>>> >> any further calls to pm_runtime_get* would return -EACCES (since
>>> >> disable_depth is 1). On resume, we restore the clocks and runtime
>>> >> status exactly as we suspended with. These operations are not expected
>>> >> to fail as we update the states after the core runtime framework has
>>> >> suspended itself and restore before the core runtime framework has
>>> >> resumed.
>>> >>
>>> >> Reported-by: J Keerthy <j-keerthy@ti.com>
>>> >> Signed-off-by: Nishanth Menon <nm@ti.com>
>>> >> Acked-by: Rajendra Nayak <rnayak@ti.com>
>>> >> Acked-by: Kevin Hilman <khilman@linaro.org>

Hi Kevin,

I am wondering if OMAP would benefit from letting the PM core allow
runtime suspends during system suspend, which is not the case as of
now.

My impression is that it could simplify OMAP drivers and the power
domain, but it would be interesting to hear your opinion in this. It
somewhat touches this patch. I guess.

The reason for bringing this up here, is that I wanted to highlight
that we are at the moment discussing the following RFC on the linux-pm
mailing list:

"[RFC PATCH] PM / Runtime: Allow to inactivate devices during system suspend".

Kind regards
Ulf Hansson

>>> >
>>> > Looks reasonable to me.  Looks like this should be considered for -stable
>>> > - Nishanth, what do you think?
>>>
>>> Every product kernel since 3.4 needed to be hacked (we have hacked in
>>> different ways so far) to work around this (since we never spend time
>>> digging deeper :( ), So, I do agree with your view that a -stable tag
>>> will be most beneficial.
>>>
>>> >
>>> > Tony or Kevin, do you want to take this one, or want me to?
>>
>> I can take it unless you have other fixes pending right now.
>
> This version looks good to me.
>
> Reviewed-by: Kevin Hilman <khilman@linaro.org>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
