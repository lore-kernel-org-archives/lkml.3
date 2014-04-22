Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaDVB4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:56:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49648 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaDVB4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:56:20 -0400
Date: Mon, 21 Apr 2014 18:56:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [rcu] 10a94227ba2: -2.0% will-it-scale.per_process_ops
Message-ID: <20140422015614.GA4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140419082622.GA29303@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140419082622.GA29303@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042201-8236-0000-0000-000001B23097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 04:26:22PM +0800, Fengguang Wu wrote:
> Paul,
> 
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git next.2014.04.16b
> commit 10a94227ba229f1b05672754dc318a8fe7982c95 ("rcu: Update cpu_needs_another_gp() for futures from non-NOCB CPUs")
> 
> test case: nhm4/micro/will-it-scale/lseek1
> 
> 11ba5ab363b9359  10a94227ba229f1b05672754d  
> ---------------  -------------------------  
>   11210675 ~ 0%      -2.0%   10985451 ~ 0%  TOTAL will-it-scale.per_process_ops
>       1.24 ~ 5%     -33.4%       0.83 ~ 5%  TOTAL perf-profile.cpu-cycles.trace_hardirqs_off_caller.lseek64
>       3.88 ~ 2%     +49.0%       5.79 ~ 0%  TOTAL perf-profile.cpu-cycles.trace_hardirqs_on_thunk.lseek64
>        295 ~16%     +27.0%        375 ~ 8%  TOTAL cpuidle.C1E-NHM.usage
>      45061 ~ 2%     +16.7%      52590 ~ 2%  TOTAL cpuidle.C6-NHM.usage
>       1.21 ~ 4%      +5.8%       1.28 ~ 4%  TOTAL perf-profile.cpu-cycles.shmem_file_llseek.sys_lseek.system_call_fastpath.lseek64
>       4206 ~ 1%     -78.6%        900 ~ 8%  TOTAL interrupts.IWI
>      14303 ~ 1%     +26.7%      18120 ~ 1%  TOTAL interrupts.0:IO-APIC-edge.timer
>       3228 ~ 4%     -17.2%       2672 ~ 6%  TOTAL interrupts.RES
>        182 ~ 2%      -8.1%        167 ~ 3%  TOTAL time.user_time
>        235 ~ 2%      +6.2%        250 ~ 2%  TOTAL time.system_time
>     379471 ~ 0%      +1.2%     384127 ~ 0%  TOTAL interrupts.LOC
> 
> Legend:
> 	~XX%    - stddev percent
> 	[+-]XX% - change percent
> 
> It does effectively eliminate interrupts.IWI:
> 
>                                    interrupts.IWI
> 
>    4500 ++-*-----*-------*--------------------------------------------------+
>         |..   *.  +  .*.      .*..*.  .*..*..*..          .*..*..*..*.*..*..*
>    4000 *+         *.       *.      *.          *.. .*..*.                  |
>    3500 ++                                         *                        |
>         |                                                                   |
>    3000 ++                                                                  |
>    2500 ++                                                                  |
>         |                                                                   |
>    2000 ++                                                                  |
>    1500 ++                                                                  |
>         |                                                                   |
>    1000 ++                                              O  O  O  O    O  O  O
>     500 ++                                                          O       |
>         |                                                                   |
>       0 O+-O--O--O-O--O--O--O--O--O-O--O--O--O--O--O-O----------------------+
> 
> 
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample

OK, so we get rid of interrupts.IWI (not sure what those are), and
we also seem to increase the idle time (cpuidle.C1E-NHM.usage and
cpuidle.C6-NHM.usage), which also seem like good things.  The overall
benchmark number looks to get a bit worse, though.  Not sure why lseek()
would incur more hardirqs, but also unsure what the units are (3.88 of
what exactly?).  Not sure why there would be more timer interrutpts,
unless my interpretation of the cpuidle stats is backwards, in which
case it would be a natural consequence of there being less idle time.

Any of this speculation at all relevant?  ;-)

							Thanx, Paul

