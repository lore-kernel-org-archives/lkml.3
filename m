Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaEDWXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 18:23:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51533 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752462AbaEDWXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 18:23:02 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] cpuidle / menu: Return error code if there are no suitable states
Date: Mon, 05 May 2014 00:39:38 +0200
Message-ID: <4202990.UXkavWrN4U@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53639B7B.2040209@linaro.org>
References: <2471963.urOyfY8mOG@vostro.rjw.lan> <1684440.TX1lbQesgE@vostro.rjw.lan> <53639B7B.2040209@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2014 03:19:55 PM Daniel Lezcano wrote:
> On 05/02/2014 02:20 PM, Rafael J. Wysocki wrote:
> > On Friday, May 02, 2014 10:47:48 AM Daniel Lezcano wrote:
> >> On 04/30/2014 01:16 AM, Rafael J. Wysocki wrote:
> >>> On Tuesday, April 29, 2014 01:28:03 AM Rafael J. Wysocki wrote:
> >>>> On Monday, April 28, 2014 01:14:32 PM Daniel Lezcano wrote:
> >>>>> On 04/27/2014 02:55 PM, Rafael J. Wysocki wrote:
> >>
> >> [ ... ]
> >>
> >>> ---
> >>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>> Subject: cpuidle / menu: Return (-1) if there are no suitable states
> >>>
> >>> If there is a PM QoS latency limit and all of the sufficiently shallow
> >>> C-states are disabled, the cpuidle menu governor returns 0 which on
> >>> some systems is CPUIDLE_DRIVER_STATE_START and shouldn't be returned
> >>> if that C-state has been disabled.
> >>>
> >>> Fix the issue by modifying the menu governor to return (-1) in such
> >>> situations.
> >>>
> >>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>> ---
> >>>    drivers/cpuidle/governors/menu.c |    2 +-
> >>>    include/linux/cpuidle.h          |    2 ++
> >>>    2 files changed, 3 insertions(+), 1 deletion(-)
> >>>
> >>> Index: linux-pm/drivers/cpuidle/governors/menu.c
> >>> ===================================================================
> >>> --- linux-pm.orig/drivers/cpuidle/governors/menu.c
> >>> +++ linux-pm/drivers/cpuidle/governors/menu.c
> >>> @@ -296,7 +296,7 @@ static int menu_select(struct cpuidle_dr
> >>>    		data->needs_update = 0;
> >>>    	}
> >>>
> >>> -	data->last_state_idx = 0;
> >>> +	data->last_state_idx = CPUIDLE_DRIVER_STATE_START - 1;
> >>
> >> In case of x86, CPUIDLE_DRIVER_STATE_START will be 1, so the select
> >> function could return 0 even this one is disabled and this is not what
> >> you want to happen, no ?
> >
> > OK, so that's a choice.  We can choose to do the above or to return an error
> > code if the 0 state is disabled too.  The above is arguably simpler and
> > matches the idea that 0 is a "fallback" state on x86.
> >
> > Of course, it also is confusing, because user space *can* set "disable" for
> > the 0 state on x86, but that actually has no effect today AFAICS.
> 
> Yes, the poll state is very rarely selected.
> 
> Regarding the description of this patch, I think it would make sense to 
> move the duplicate pm qos checks to the cpuidle_idle_call function 
> directly and pass the latency req to the select function, so the zero 
> latency check could be done by the caller before entering select.

I would prefer to have them in cpuidle_select() for various reasons (one
of them being to avoid the need to pass latency_req from cpuidle_idle_call()
to cpuidle_select() which isn't necessary).

> > I'm mostly worried about systems where CPUIDLE_DRIVER_STATE_START is 0
> > and where menu_select() explicitly checks "disabled" and then it returns
> > 0 anyway if it cannot find any other suitable state.
> 
> For the ARM platform, the state0 and the default idle function are the 
> same, so disabling this state will result in calling the same idle function.
> 
> > In my opinion that needs to be made consistent, but I don't care too much about
> > which way as long as the change is not too intrusive.
> 
> I think we can live with this patch until we remove the 
> CPUIDLE_DRIVER_STATE_START macro. It was introduced to factor out a 
> couple of drivers and now it results in a confusing-hard-to-fix-code.

OK

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
