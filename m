Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbaHVRjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487AbaHVRjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:39:12 -0400
Date: Fri, 22 Aug 2014 23:07:52 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140822173752.GA25807@grmbl.mre>
References: <20140813130049.GS4752@linux.vnet.ibm.com>
 <20140815052411.GF1934@grmbl.mre>
 <20140815150402.GD4752@linux.vnet.ibm.com>
 <20140818175345.GD31856@grmbl.mre>
 <20140819040149.GJ4752@linux.vnet.ibm.com>
 <20140822122453.GG16198@grmbl.mre>
 <20140822123651.GH16198@grmbl.mre>
 <20140822125649.GI16198@grmbl.mre>
 <20140822144819.GG2663@linux.vnet.ibm.com>
 <20140822171405.GJ16198@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822171405.GJ16198@grmbl.mre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 22 Aug 2014 [22:44:05], Amit Shah wrote:
> Hm, found it:
> 
> The stall happens in do_initcalls().
> 
> pm_sysrq_init() is the function that causes the hang.  When I #if 0
> the line
> 
>     register_sysrq_key('o', &sysrq_poweroff_op);
> 
> in pm_sysrq_init(), the boot proceeds normally.
> 
> Now what this is, and what relation this has to rcu and that patch in
> particular is next...

... and enabling the following debug options makes the bug disappear:

CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1

Anyway, so it looks like a race somewhere in the schedule_work_on()
chain.  Not sure how to capture the debug messages there w/o disabling
these debug options.  I'll keep trying, though.


		Amit
