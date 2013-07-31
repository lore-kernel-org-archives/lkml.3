Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab3GaWSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:18:15 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:55411
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab3GaWSO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:18:14 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh146fI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Wed, 31 Jul 2013 15:18:00 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <ff4d40be-7177-4a55-ab2f-dff11fa18642@DB9EHSMHS009.ehs.local>
 <51ED8DF2.60600@codeaurora.org>
 <20130722201348.GI453@xsjandreislx>
 <0735ab8c-0f80-4b64-b2b2-8d4553482c2a@CO9EHSMHS013.ehs.local>
 <51F66565.7010600@linaro.org>
 <8d56935e-2a20-46c7-b80a-f779572dd839@CO1EHSMHS014.ehs.local>
 <51F77D93.4030505@linaro.org>
 <51F97842.6050200@linaro.org>
 <068436c6-ff98-428f-8875-bb1c6f86466b@TX2EHSMHS008.ehs.local>
 <51F97CE3.9030306@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <51F97CE3.9030306@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 11:08:51PM +0200, Daniel Lezcano wrote:
> On 07/31/2013 10:58 PM, Sören Brinkmann wrote:
> > On Wed, Jul 31, 2013 at 10:49:06PM +0200, Daniel Lezcano wrote:
> >> On 07/31/2013 12:34 AM, Sören Brinkmann wrote:
> >>> On Tue, Jul 30, 2013 at 10:47:15AM +0200, Daniel Lezcano wrote:
> >>>> On 07/30/2013 02:03 AM, Sören Brinkmann wrote:
> >>>>> Hi Daniel,
> >>>>>
> >>>>> On Mon, Jul 29, 2013 at 02:51:49PM +0200, Daniel Lezcano wrote:
> >>>>> (snip)
> >>>>>>
> >>>>>> the CPUIDLE_FLAG_TIMER_STOP flag tells the cpuidle framework the local
> >>>>>> timer will be stopped when entering to the idle state. In this case, the
> >>>>>> cpuidle framework will call clockevents_notify(ENTER) and switches to a
> >>>>>> broadcast timer and will call clockevents_notify(EXIT) when exiting the
> >>>>>> idle state, switching the local timer back in use.
> >>>>>
> >>>>> I've been thinking about this, trying to understand how this makes my
> >>>>> boot attempts on Zynq hang. IIUC, the wrongly provided TIMER_STOP flag
> >>>>> would make the timer core switch to a broadcast device even though it
> >>>>> wouldn't be necessary. But shouldn't it still work? It sounds like we do
> >>>>> something useless, but nothing wrong in a sense that it should result in
> >>>>> breakage. I guess I'm missing something obvious. This timer system will
> >>>>> always remain a mystery to me.
> >>>>>
> >>>>> Actually this more or less leads to the question: What is this
> >>>>> 'broadcast timer'. I guess that is some clockevent device which is
> >>>>> common to all cores? (that would be the cadence_ttc for Zynq). Is the
> >>>>> hang pointing to some issue with that driver?
> >>>>
> >>>> If you look at the /proc/timer_list, which timer is used for broadcasting ?
> >>>
> >>> So, the correct run results (full output attached).
> >>>
> >>> The vanilla kernel uses the twd timers as local timers and the TTC as
> >>> broadcast device:
> >>> 	Tick Device: mode:     1                                                         
> >>> 	Broadcast device  
> >>> 	Clock Event Device: ttc_clockevent
> >>>
> >>> When I remove the offending CPUIDLE flag and add the DT fragment to
> >>> enable the global timer, the twd timers are still used as local timers
> >>> and the broadcast device is the global timer:
> >>> 	Tick Device: mode:     1                                                         
> >>> 	Broadcast device                                                                 
> >>> 	Clock Event Device: arm_global_timer
> >>>
> >>> Again, since boot hangs in the actually broken case, I don't see way to
> >>> obtain this information for that case.
> >>
> >> Can't you use the maxcpus=1 option to ensure the system to boot up ?
> > 
> > Right, that works. I forgot about that option after you mentioned, that
> > it is most likely not that useful.
> > 
> > Anyway, this are those sysfs files with an unmodified cpuidle driver and
> > the gt enabled and having maxcpus=1 set.
> > 
> > /proc/timer_list:
> > 	Tick Device: mode:     1
> > 	Broadcast device
> > 	Clock Event Device: arm_global_timer
> > 	 max_delta_ns:   12884902005
> > 	 min_delta_ns:   1000
> > 	 mult:           715827876
> > 	 shift:          31
> > 	 mode:           3
> 
> Here the mode is 3 (CLOCK_EVT_MODE_ONESHOT)
> 
> The previous timer_list output you gave me when removing the offending
> cpuidle flag, it was 1 (CLOCK_EVT_MODE_SHUTDOWN).
> 
> Is it possible you try to get this output again right after onlining the
> cpu1 in order to check if the broadcast device switches to SHUTDOWN ?

How do I do that? I tried to online CPU1 after booting with maxcpus=1
and that didn't end well:
	# echo 1 > online && cat /proc/timer_list 
	[ 4689.992658] CPU1: Booted secondary processor
	[ 4690.986295] CPU1: failed to come online
	sh: write error: Input/output error
	# [ 4691.045945] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
	[ 4691.045986] 
	[ 4691.052972] ===============================
	[ 4691.057349] [ INFO: suspicious RCU usage. ]
	[ 4691.061413] 3.11.0-rc3-00001-gc14f576-dirty #139 Not tainted
	[ 4691.067026] -------------------------------
	[ 4691.071129] kernel/sched/fair.c:5477 suspicious rcu_dereference_check() usage!
	[ 4691.078292] 
	[ 4691.078292] other info that might help us debug this:
	[ 4691.078292] 
	[ 4691.086209] 
	[ 4691.086209] RCU used illegally from offline CPU!
	[ 4691.086209] rcu_scheduler_active = 1, debug_locks = 0
	[ 4691.097216] 1 lock held by swapper/1/0:
	[ 4691.100968]  #0:  (rcu_read_lock){.+.+..}, at: [<c00679b4>] set_cpu_sd_state_idle+0x0/0x1e4
	[ 4691.109250] 
	[ 4691.109250] stack backtrace:
	[ 4691.113531] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-rc3-00001-gc14f576-dirty #139
	[ 4691.121755] [<c0016a88>] (unwind_backtrace+0x0/0x128) from [<c0012d58>] (show_stack+0x20/0x24)
	[ 4691.130263] [<c0012d58>] (show_stack+0x20/0x24) from [<c045bd50>] (dump_stack+0x80/0xc4)
	[ 4691.138264] [<c045bd50>] (dump_stack+0x80/0xc4) from [<c007ad78>] (lockdep_rcu_suspicious+0xdc/0x118)
	[ 4691.147371] [<c007ad78>] (lockdep_rcu_suspicious+0xdc/0x118) from [<c0067ac0>] (set_cpu_sd_state_idle+0x10c/0x1e4)
	[ 4691.157605] [<c0067ac0>] (set_cpu_sd_state_idle+0x10c/0x1e4) from [<c0078238>] (tick_nohz_idle_enter+0x48/0x80)
	[ 4691.167583] [<c0078238>] (tick_nohz_idle_enter+0x48/0x80) from [<c006dc5c>] (cpu_startup_entry+0x28/0x388)
	[ 4691.177127] [<c006dc5c>] (cpu_startup_entry+0x28/0x388) from [<c0014acc>] (secondary_start_kernel+0x12c/0x144)
	[ 4691.187013] [<c0014acc>] (secondary_start_kernel+0x12c/0x144) from [<000081ec>] (0x81ec)


	Sören


