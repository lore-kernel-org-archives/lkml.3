Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab3KMPbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:31:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32747 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754173Ab3KMPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:31:36 -0500
Date: Wed, 13 Nov 2013 10:31:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, mwhitehe@redhat.com
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20131113103134.5b8cf02f@gandalf.local.home>
In-Reply-To: <20131113102153.5f10e6b5@gandalf.local.home>
References: <20131113113927.GA13875@mwhitehe.csb>
	<alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
	<20131113102153.5f10e6b5@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 10:21:53 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
trace-cmd record -p function -l '*nohz*' -l account_process_tick -e sched_switch
> 
> rcu_sche-9       0d...  6858.618033: sched_switch:         rcu_sched:9 [120] S ==> swapper/0:0 [120]
>   <idle>-0       0....  6858.618082: function:             tick_nohz_idle_enter <-- cpu_startup_entry
>   <idle>-0       0d...  6858.618101: function:                __tick_nohz_idle_enter <-- tick_nohz_idle_enter
>   <idle>-0       0d.s.  6858.621499: function:             tick_nohz_stop_idle <-- tick_check_idle
>   <idle>-0       0d.h.  6858.621550: function:             account_process_tick <-- update_process_times
>   <idle>-0       0d...  6858.621769: function:             tick_nohz_irq_exit <-- irq_exit
>   <idle>-0       0d...  6858.621787: function:             __tick_nohz_idle_enter <-- irq_exit
>   <idle>-0       0d.s.  6858.625500: function:             tick_nohz_stop_idle <-- tick_check_idle
>   <idle>-0       0d.h.  6858.625574: function:             account_process_tick <-- update_process_times
>   <idle>-0       0d...  6858.625818: function:             tick_nohz_irq_exit <-- irq_exit
>   <idle>-0       0d...  6858.625847: function:             __tick_nohz_idle_enter <-- irq_exit
>   <idle>-0       0d.s.  6858.629295: function:             tick_nohz_stop_idle <-- tick_check_idle
>   <idle>-0       0d...  6858.629351: function:             tick_nohz_irq_exit <-- irq_exit
>   <idle>-0       0d...  6858.629373: function:             __tick_nohz_idle_enter <-- irq_exit
>   <idle>-0       0d.s.  6858.629503: function:             tick_nohz_stop_idle <-- tick_check_idle
>   <idle>-0       0d.h.  6858.629569: function:             account_process_tick <-- update_process_times
>   <idle>-0       0d...  6858.629851: function:             tick_nohz_irq_exit <-- irq_exit
>   <idle>-0       0d...  6858.629881: function:             __tick_nohz_idle_enter <-- irq_exit
>   <idle>-0       0d.s.  6858.630412: function:             tick_nohz_stop_idle <-- tick_check_idle
>   <idle>-0       0.N..  6858.630550: function:             tick_nohz_idle_exit <-- cpu_startup_entry
>   <idle>-0       0d...  6858.630605: sched_switch:         swapper/0:0  [120] R ==> rcu_sched:9 [120]
> 
> I'm not saying that we are actually getting into nohz, but something
> with the nohz code is messing with cpu accounting.

The trace does indeed show that a tick is happening, as the config has
HZ=250 (4ms) and we see a tick happen every 4ms. But for some reason,
we don't update the the idle time correctly when nohz is enabled.

When I say nohz is enabled, I mean that we don't have nohz=off in the
command line. There seems to be some difference between having nohz=off
and having nohz disabled at runtime.

-- Steve
