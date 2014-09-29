Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaI2XYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:24:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62514 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751028AbaI2XYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:24:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 1/1] Cpufreq: Keep cpufreq sysfs nodes across S2RAM/S2DISK when using intel_pstate driver.
Date: Tue, 30 Sep 2014 01:44:05 +0200
Message-ID: <5318779.3lMVbcv1i3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpokht4=7XCftPYa5PqpPMN-O-5b_RjJ3BgHnxjYV4VzyTg@mail.gmail.com>
References: <1411023787-11458-1-git-send-email-tianyu.lan@intel.com> <CAKohpokht4=7XCftPYa5PqpPMN-O-5b_RjJ3BgHnxjYV4VzyTg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 29, 2014 01:20:44 AM Viresh Kumar wrote:
> Sorry for being late on this. Was away for a week for Linaro Connect followed
> by a week of vacations :(
> 
> On 18 September 2014 00:03, Lan Tianyu <tianyu.lan@intel.com> wrote:
> > Cpufreq core introduces cpufreq_suspended flag to let cpufreq sysfs nodes
> > across S2RAM/S2DISK. But the flag is only set in the cpufreq_suspend()
> > for cpufreq drivers which have target or target_index callback. This
> > skips intel_pstate driver. This patch is to set the flag before checking
> > target or target_index callback.
> 
> Oh yes, this looks to be the right thing to do..
> 
> > Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> > ---
> >  drivers/cpufreq/cpufreq.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index d9fdedd..eb9bb78 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -1656,6 +1656,8 @@ void cpufreq_suspend(void)
> >         if (!cpufreq_driver)
> >                 return;
> >
> > +       cpufreq_suspended = true;
> > +
> >         if (!has_target())
> >                 return;
> >
> > @@ -1670,8 +1672,6 @@ void cpufreq_suspend(void)
> >                         pr_err("%s: Failed to suspend driver: %p\n", __func__,
> >                                 policy);
> >         }
> > -
> > -       cpufreq_suspended = true;
> 
> But this change is buggy.. Because you are updating 'cpufreq_suspended'
> before actually stopping the governor, any calls to __cpufreq_governor()
> will be converted to NO-operations because of this in __cpufreq_governor():
> 
> /* Don't start any governor operations if we are entering suspend */
> if (cpufreq_suspended)
>     return 0;
> 
> And so the governor's will never stop :(
> 
> So you need to keep the above line where it was :)

OK, so please send a fix for that against the Linus' tree.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
