Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3KOOht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:37:49 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40093 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3KOOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:37:41 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/4ngy7SYoMm+hSUjHRrvne
Date: Fri, 15 Nov 2013 06:37:37 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, rnayak@ti.com, khilman@linaro.org,
        balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] ARM: OMAP2+: omap_device: maintain sane runtime pm
 status around suspend/resume
Message-ID: <20131115143736.GW10317@atomide.com>
References: <1384297710-29694-1-git-send-email-nm@ti.com>
 <1384448716-3186-1-git-send-email-nm@ti.com>
 <alpine.DEB.2.02.1311150806220.15980@utopia.booyaka.com>
 <528621E5.4030201@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528621E5.4030201@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [131115 05:30]:
> On 11/15/2013 02:07 AM, Paul Walmsley wrote:
> > On Thu, 14 Nov 2013, Nishanth Menon wrote:
> > 
> >> OMAP device hooks around suspend|resume_noirq ensures that hwmod
> >> devices are forced to idle using omap_device_idle/enable as part of
> >> the last stage of suspend activity.
> >>
> >> For a device such as i2c who uses autosuspend, it is possible to enter
> >> the suspend path with dev->power.runtime_status = RPM_ACTIVE.
> >>
> >> As part of the suspend flow, the generic runtime logic would increment
> >> it's dev->power.disable_depth to 1. This should prevent further
> >> pm_runtime_get_sync from succeeding once the runtime_status has been
> >> set to RPM_SUSPENDED.
> >>
> >> Now, as part of the suspend_noirq handler in omap_device, we force the
> >> following: if the device status is !suspended, we force the device
> >> to idle using omap_device_idle (clocks are cut etc..). This ensures
> >> that from a hardware perspective, the device is "suspended". However,
> >> runtime_status is left to be active.
> >>
> >> *if* an operation is attempted after this point to
> >> pm_runtime_get_sync, runtime framework depends on runtime_status to
> >> indicate accurately the device status, and since it sees it to be
> >> ACTIVE, it assumes the module is functional and returns a non-error
> >> value. As a result the user will see pm_runtime_get succeed, however a
> >> register access will crash due to the lack of clocks.
> >>
> >> To prevent this from happening, we should ensure that runtime_status
> >> exactly indicates the device status. As a result of this change
> >> any further calls to pm_runtime_get* would return -EACCES (since
> >> disable_depth is 1). On resume, we restore the clocks and runtime
> >> status exactly as we suspended with. These operations are not expected
> >> to fail as we update the states after the core runtime framework has
> >> suspended itself and restore before the core runtime framework has
> >> resumed.
> >>
> >> Reported-by: J Keerthy <j-keerthy@ti.com>
> >> Signed-off-by: Nishanth Menon <nm@ti.com>
> >> Acked-by: Rajendra Nayak <rnayak@ti.com>
> >> Acked-by: Kevin Hilman <khilman@linaro.org>
> > 
> > Looks reasonable to me.  Looks like this should be considered for -stable 
> > - Nishanth, what do you think?
> 
> Every product kernel since 3.4 needed to be hacked (we have hacked in
> different ways so far) to work around this (since we never spend time
> digging deeper :( ), So, I do agree with your view that a -stable tag
> will be most beneficial.
> 
> > 
> > Tony or Kevin, do you want to take this one, or want me to?

I can take it unless you have other fixes pending right now.

Tony
