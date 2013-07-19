Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224Ab3GSTP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:15:26 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:12635 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3GSTPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:15:23 -0400
Message-ID: <1374261318.1830.6.camel@j-VirtualBox>
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Date: Fri, 19 Jul 2013 12:15:18 -0700
In-Reply-To: <20130719183717.GP27075@twins.programming.kicks-ass.net>
References: <1374048701.6000.21.camel@j-VirtualBox>
	 <20130717093913.GP23818@dyad.programming.kicks-ass.net>
	 <1374076741.7412.35.camel@j-VirtualBox>
	 <20130717161815.GR23818@dyad.programming.kicks-ass.net>
	 <51E6D9B7.1030705@redhat.com>
	 <20130717180156.GS23818@dyad.programming.kicks-ass.net>
	 <1374120144.1816.45.camel@j-VirtualBox>
	 <20130718093218.GH27075@twins.programming.kicks-ass.net>
	 <51E7D89A.8010009@redhat.com> <1374174399.1792.42.camel@j-VirtualBox>
	 <20130719183717.GP27075@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 20:37 +0200, Peter Zijlstra wrote:
> On Thu, Jul 18, 2013 at 12:06:39PM -0700, Jason Low wrote:
> 
> > N = 1
> > -----
> > 19.21%  reaim  [k] __read_lock_failed                     
> > 14.79%  reaim  [k] mspin_lock                             
> > 12.19%  reaim  [k] __write_lock_failed                    
> > 7.87%   reaim  [k] _raw_spin_lock                          
> > 2.03%   reaim  [k] start_this_handle                       
> > 1.98%   reaim  [k] update_sd_lb_stats                      
> > 1.92%   reaim  [k] mutex_spin_on_owner                     
> > 1.86%   reaim  [k] update_cfs_rq_blocked_load              
> > 1.14%   swapper  [k] intel_idle                              
> > 1.10%   reaim  [.] add_long                                
> > 1.09%   reaim  [.] add_int                                 
> > 1.08%   reaim  [k] load_balance                            
> 
> But but but but.. wth is causing this? The only thing we do more of with
> N=1 is idle_balance(); where would that cause __{read,write}_lock_failed
> and or mspin_lock() contention like that.
> 
> There shouldn't be a rwlock_t in the entire scheduler; those things suck
> worse than quicksand.
> 
> If, as Rik thought, we'd have more rq->lock contention, then I'd
> expected _raw_spin_lock to be up highest.

For this particular fserver workload, that mutex was acquired in the
function calls from ext4_orphan_add() and ext4_orphan_del(). Those read
and write lock calls were from start_this_handle(). 

Although these functions are not called within the idle_balance() code
path, update_sd_lb_stats(), tg_load_down(), idle_cpu(), spin_lock(),
ect... increases the time spent in the kernel and that appears to be
indirectly causing more time to be spent acquiring those other kernel
locks.

Thanks,
Jason



