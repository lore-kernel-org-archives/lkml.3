Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaBMUlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:41:09 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:53417 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaBMUlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:41:06 -0500
Date: Thu, 13 Feb 2014 15:41:02 -0500
From: Tejun Heo <tj@kernel.org>
To: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140213204102.GC17608@htj.dyndns.org>
References: <52F4F01C.1070800@linux.vnet.ibm.com>
 <20140207165113.GD3304@htj.dyndns.org>
 <52F51E10.8050208@linux.vnet.ibm.com>
 <20140207193604.GA8833@htj.dyndns.org>
 <52F8F0FB.3080206@linux.vnet.ibm.com>
 <20140210231742.GK25350@mtj.dyndns.org>
 <52FB90C6.4010701@linux.vnet.ibm.com>
 <52FC3C83.8020303@cn.fujitsu.com>
 <52FD07B2.5080402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FD07B2.5080402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Ingo and Peter)

On Thu, Feb 13, 2014 at 12:58:10PM -0500, Jason J. Herne wrote:
> [ 5779.795687] ------------[ cut here ]------------
> [ 5779.795695] WARNING: at kernel/workqueue.c:2159
....
> [ 5779.795844] XXX: worker->flags=0x1 pool->flags=0x0 cpu=4 pool->cpu=5(1) rescue_wq=          (null)
> [ 5779.795848] XXX: last_unbind=-44 last_rebind=0 last_rebound_clear=0 nr_exected_after_rebound_clear=0
> [ 5779.795852] XXX: sleep=-39 wakeup=0
> [ 5779.795855] XXX: cpus_allowed=5
> [ 5779.795857] XXX: cpus_allowed_after_rebinding=5
> [ 5779.795861] XXX: after schedule(), cpu=4
> 
> You had asked about reproducing this. This is on the S390 platform,
> I'm not sure if that makes any difference.
> 
> The workload is:
> 2 processes onlining random cpus in a tight loop by using 'echo 1 > /sys/bus/cpu.../online'
> 2 processes offlining random cpus in a tight loop by using 'echo 0 > /sys/bus/cpu.../online'
> Otherwise, fairly idle system. load average: 5.82, 6.27, 6.27
> 
> The machine has 10 processors.
> The warning message some times hits within a few minutes on starting
> the workload. Other times it takes several hours.

Ingo, Peter, Jason is reporting workqueue triggering warning because a
worker is running on the wrong CPU, which is relatively reliably
reproducible with the above workload on s390.  The weird thing is that
everything looks correct from workqueue side.  The worker has proper
cpus_allowed set and the CPU it's supposed to run on is online and yet
the worker is on the wrong CPU and even doing explicit schedule()
after detecting the condition doesn't change the situation.  Any
ideas?

Jason, I don't have much idea from workqueue side.  Have you been
running this test with older kernels too?  Can you confirm whether
this failure is something recent?  Bisection would be awesome but just
confirming, say, 3.12 doesn't have this issue would be very helpful.

Thanks!

-- 
tejun
