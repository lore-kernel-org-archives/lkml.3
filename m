Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3KDJxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:53:09 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45670 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3KDJxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:53:07 -0500
Date: Mon, 4 Nov 2013 01:52:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, dipankar@in.ibm.com,
        fweisbec@gmail.com, youquan.song@intel.com, riel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Tick: Introduce tick_nohz_check() to check nohz
 enable status
Message-ID: <20131104095258.GI3947@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1383036537-30362-1-git-send-email-tianyu.lan@intel.com>
 <20131029095135.GH4126@linux.vnet.ibm.com>
 <526F8E21.1030702@intel.com>
 <527710C8.8020908@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <527710C8.8020908@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110409-7182-0000-0000-000008FDFC25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 11:13:12AM +0800, Lan Tianyu wrote:
> On 2013年10月29日 18:29, Lan Tianyu wrote:
> > On 10/29/2013 05:51 PM, Paul E. McKenney wrote:
> >> On Tue, Oct 29, 2013 at 04:48:56PM +0800, Lan Tianyu wrote:
> >>> In some cases, nohz enable status needs to be checked. E.G, in RCU
> >>> and cpufreq
> >>> ondemand governor. So add tick_nohz_check() to return
> >>> tick_nohz_enabled value
> >>> And use tick_nohz_check() instead of referencing tick_nohz_enabled in
> >>> the rcutree_plugin.h.
> >>>
> >>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> >>
> >> NACK on the rcutree change unless you put the ACCESS_ONCE() in.
> >>
> >> Or is there some reason that ACCESS_ONCE() is not needed?  If so, what
> >> is that reason?
> > 
> > Hi Paul:
> > 
> > Thanks for review. When I change this code, I find the tick_nohz_enabled
> > isn't changed dynamically. It's only changed during parsing kernel
> > params when "nohz=off/on" is set. Except this, it will not be changed.
> > So I ignored ACCESS_ONCE(). If necessary, I can add it back.
> 
> Hi Paul:
> 	Does this reason make sense to you? Or you still prefer to add
> ACCESS_ONCE() in the new tick_nohz_check()?

I prefer the ACCESS_ONCE().  It adds little or no overhead, and Frederic
has been heard to say that he mkight allow tick_nohz_check() to change
in the future.

							Thanx, Paul

> >>> ---
> >>>   include/linux/tick.h     | 2 ++
> >>>   kernel/rcutree_plugin.h  | 4 +---
> >>>   kernel/time/tick-sched.c | 8 +++++++-
> >>>   3 files changed, 10 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/include/linux/tick.h b/include/linux/tick.h
> >>> index 5128d33..a9c5374 100644
> >>> --- a/include/linux/tick.h
> >>> +++ b/include/linux/tick.h
> >>> @@ -136,6 +136,7 @@ static inline int tick_nohz_tick_stopped(void)
> >>>   extern void tick_nohz_idle_enter(void);
> >>>   extern void tick_nohz_idle_exit(void);
> >>>   extern void tick_nohz_irq_exit(void);
> >>> +extern int tick_nohz_check(void);
> >>>   extern ktime_t tick_nohz_get_sleep_length(void);
> >>>   extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
> >>>   extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
> >>> @@ -155,6 +156,7 @@ static inline ktime_t
> >>> tick_nohz_get_sleep_length(void)
> >>>
> >>>       return len;
> >>>   }
> >>> +static inline int tick_nohz_check(void) { return 0; }
> >>>   static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) {
> >>> return -1; }
> >>>   static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) {
> >>> return -1; }
> >>>   # endif /* !CONFIG_NO_HZ_COMMON */
> >>> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> >>> index 130c97b..af167ec 100644
> >>> --- a/kernel/rcutree_plugin.h
> >>> +++ b/kernel/rcutree_plugin.h
> >>> @@ -1627,8 +1627,6 @@ module_param(rcu_idle_gp_delay, int, 0644);
> >>>   static int rcu_idle_lazy_gp_delay = RCU_IDLE_LAZY_GP_DELAY;
> >>>   module_param(rcu_idle_lazy_gp_delay, int, 0644);
> >>>
> >>> -extern int tick_nohz_enabled;
> >>> -
> >>>   /*
> >>>    * Try to advance callbacks for all flavors of RCU on the current CPU.
> >>>    * Afterwards, if there are any callbacks ready for immediate
> >>> invocation,
> >>> @@ -1718,7 +1716,7 @@ static void rcu_prepare_for_idle(int cpu)
> >>>       int tne;
> >>>
> >>>       /* Handle nohz enablement switches conservatively. */
> >>> -    tne = ACCESS_ONCE(tick_nohz_enabled);
> >>> +    tne = tick_nohz_check();
> >>>       if (tne != rdtp->tick_nohz_enabled_snap) {
> >>>           if (rcu_cpu_has_callbacks(cpu, NULL))
> >>>               invoke_rcu_core(); /* force nohz to see update. */
> >>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> >>> index 3612fc7..d381a22 100644
> >>> --- a/kernel/time/tick-sched.c
> >>> +++ b/kernel/time/tick-sched.c
> >>> @@ -361,7 +361,13 @@ void __init tick_nohz_init(void)
> >>>   /*
> >>>    * NO HZ enabled ?
> >>>    */
> >>> -int tick_nohz_enabled __read_mostly  = 1;
> >>> +static int tick_nohz_enabled __read_mostly  = 1;
> >>> +
> >>> +int tick_nohz_check(void)
> >>> +{
> >>> +    return    tick_nohz_enabled;
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(tick_nohz_check);
> >>>
> >>>   /*
> >>>    * Enable / Disable tickless mode
> >>> -- 
> >>> 1.8.4.rc0.1.g8f6a3e5.dirty
> >>>
> >>
> > 
> 
> 
> -- 
> Best regards
> Tianyu Lan
> 

