Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3H2T6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:58:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42870 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab3H2T6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:58:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>, Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 1/3] cpuidle: coupled: disable interrupts after entering safe state
Date: Thu, 29 Aug 2013 22:09:01 +0200
Message-ID: <3891367.RzYTp6nikM@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAMbhsRSTv9ivMY1=-4YPxPV0tCTcJnHwWOEvr_F5exg9A2Z1Mw@mail.gmail.com>
References: <1377287112-12018-1-git-send-email-ccross@android.com> <521EEF26.80803@nvidia.com> <CAMbhsRSTv9ivMY1=-4YPxPV0tCTcJnHwWOEvr_F5exg9A2Z1Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 29, 2013 12:12:17 AM Colin Cross wrote:
> On Wed, Aug 28, 2013 at 11:50 PM, Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
> > On Saturday 24 August 2013 01:15 AM, Colin Cross wrote:
> >>
> >> Calling cpuidle_enter_state is expected to return with interrupts
> >> enabled, but interrupts must be disabled before starting the
> >> ready loop synchronization stage.  Call local_irq_disable after
> >> each call to cpuidle_enter_state for the safe state.
> >>
> >> CC: stable@vger.kernel.org
> >> Signed-off-by: Colin Cross <ccross@android.com>
> >> ---
> >>   drivers/cpuidle/coupled.c | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> >> index 2a297f8..db92bcb 100644
> >> --- a/drivers/cpuidle/coupled.c
> >> +++ b/drivers/cpuidle/coupled.c
> >> @@ -460,6 +460,7 @@ int cpuidle_enter_state_coupled(struct cpuidle_device
> >> *dev,
> >>                 }
> >>                 entered_state = cpuidle_enter_state(dev, drv,
> >>                         dev->safe_state_index);
> >> +               local_irq_disable();
> >
> >
> > Colin,
> >
> > There is still some window where irq remains enabled after exiting safe
> > state. It may introduce some corner case.
> > Instead of this can we pass a parameter to cpuidle_enter_state indicating
> > that irq has to be enabled or not after exit from idle state, which would be
> > false when entering safe state from coupled idle.
> 
> It's fine for irqs to be enabled when exiting the safe state, in fact
> on further inspection this patch isn't strictly necessary at all - we
> always enable interrupts inside cpuidle_coupled_clear_pokes soon after
> cpuidle_enter_state returns, and then disable them again.  It's
> probably better to disable interrupts right after cpuidle_enter_state,
> it makes sure interrupts are consistently disabled when calling
> cpuidle_coupled_set_waiting, cpuidle_coupled_cpus_waiting and
> cpuidle_coupled_clear_pokes, although that doesn't matter in the
> current implementation.
> 
> Rafael, feel free to drop the stable annotation from this patch.

I will, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
