Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3FLO7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:59:23 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33829 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3FLO7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:59:22 -0400
Date: Wed, 12 Jun 2013 06:48:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/rcutorture.c:1243 rcu_torture_printk
Message-ID: <20130612134835.GA25093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130610074728.GA20886@localhost>
 <20130610145110.GL5146@linux.vnet.ibm.com>
 <20130611021455.GB8872@localhost>
 <20130611230322.GL5146@linux.vnet.ibm.com>
 <20130611233725.GA30531@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611233725.GA30531@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061213-2876-0000-0000-000009C3B2D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 04:37:25PM -0700, Paul E. McKenney wrote:
> On Tue, Jun 11, 2013 at 04:03:22PM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 11, 2013 at 10:14:55AM +0800, Fengguang Wu wrote:
> > > Paul,
> > > 
> > > On Mon, Jun 10, 2013 at 07:51:10AM -0700, Paul E. McKenney wrote:
> > > > On Mon, Jun 10, 2013 at 03:47:28PM +0800, Fengguang Wu wrote:
> > > > > Greetings,
> > > > > 
> > > > > I got the below dmesg and the first bad commit is
> > > > > 
> > > > > commit 911af505ef407c2511106c224dd640f882f0f590
> > > > > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > Date:   Mon Feb 11 10:23:27 2013 -0800
> > > > > 
> > > > >     rcu: Provide compile-time control for no-CBs CPUs
> > > > >     
> > > > >     Currently, the only way to specify no-CBs CPUs is via the rcu_nocbs
> > > > >     kernel command-line parameter.  This is inconvenient in some cases,
> > > > >     particularly for randconfig testing, so this commit adds a new set of
> > > > >     kernel configuration parameters.  CONFIG_RCU_NOCB_CPU_NONE (the default)
> > > > >     retains the old behavior, CONFIG_RCU_NOCB_CPU_ZERO offloads callback
> > > > >     processing from CPU 0 (along with any other CPUs specified by the
> > > > >     rcu_nocbs boot-time parameter), and CONFIG_RCU_NOCB_CPU_ALL offloads
> > > > >     callback processing from all CPUs.
> > > > >     
> > > > >     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > However I guess it's a wrong bisect, the commit should be unmasking an
> > > > > old bug because it merely provides more kconfig options.
> > > > > 
> > > > > This warning happened only once in 74 boots of the kernel.
> > > > > 
> > > > > I also attached the 2nd dmesg which shows boot hang for the same
> > > > > kernel.
> > > > > 
> > > > > Note that there are also 2 kernel hangs in the 74 boots.  It should
> > > > > not be an RCU problem, however for completeness, I also attach a dmesg
> > > > > for your reference when considering this RCU warning.
> > > > 
> > > > Either way, that is a nasty warning!  You get this on recent kernels as
> > > > well, I take it?
> > > 
> > > Yes, the warning is still in recent kernels, indicated from the last
> > > lines of the bisect log.
> > > 
> > > 911af505ef407c2511106c224dd640f882f0f590 is bad and its parent
> > > 34ed62461ae4970695974afb9a60ac3df0086830 is good:
> > > > > git bisect  bad 911af505ef407c2511106c224dd640f882f0f590  #    65  2013-06-07 16:14:41  rcu: Provide compile-time control for no-CBs CPUs
> > > > > git bisect good 34ed62461ae4970695974afb9a60ac3df0086830  #   900  2013-06-08 04:57:34  rcu: Remove restrictions on no-CBs CPUs
> > > 
> > > After bisect, the script tries to confirm that
> > > 34ed62461ae4970695974afb9a60ac3df0086830 is really good by boot
> > > testing it 2700 more times:
> > > 
> > > > > git bisect good 34ed62461ae4970695974afb9a60ac3df0086830  #  2700  2013-06-10 14:33:56  rcu: Remove restrictions on no-CBs CPUs
> > > 
> > > And continue to find out whether the linus/master and
> > > linux-next/master are good/bad (here the results are both bad):
> > > 
> > > > > git bisect  bad f43e7a34255a387930bc2bb826ec17c052ce975e  # 14:34      0  Merge branch 'for-next'
> > > > > git bisect  bad c04efed734409f5a44715b54a6ca1b54b0ccf215  # 14:41     11  Add linux-next specific files for 20130607
> > 
> > Just to let you know that I am putting some time into this...
> > 
> > Well, I got a panic, but it turned out to be the kernel being unable to
> > locate init.  Why your .config should have this effect, I have no idea --
> > I don't see any Kconfig parameters that look to me like they should be
> > specifying where init lives.  Any hints?
> > 
> > Left to myself, my next step will be to try just the RCU-related Kconfig
> > parameters.
> 
> Which gets rid of the "unable to locate init" panic.  One strange thing
> in your .config:
> 
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ_FULL is not set
> CONFIG_NO_HZ=y
> 
> Seems harmless, though.
> 
> I will do repeated runs with this config fragment to see if I can reproduce
> your warning:
> 
> 	CONFIG_TREE_PREEMPT_RCU=y
> 	CONFIG_PREEMPT_RCU=y
> 	CONFIG_RCU_STALL_COMMON=y
> 	CONFIG_RCU_USER_QS=n
> 	CONFIG_RCU_FANOUT=64
> 	CONFIG_RCU_FANOUT_LEAF=16
> 	CONFIG_RCU_FANOUT_EXACT=n
> 	CONFIG_RCU_BOOST=y
> 	CONFIG_RCU_BOOST_PRIO=1
> 	CONFIG_RCU_BOOST_DELAY=500
> 	CONFIG_RCU_NOCB_CPU=y
> 	CONFIG_RCU_NOCB_CPU_NONE=n
> 	CONFIG_RCU_NOCB_CPU_ZERO=y
> 	CONFIG_RCU_NOCB_CPU_ALL=n
> 	CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
> 	CONFIG_SPARSE_RCU_POINTER=n
> 	CONFIG_RCU_TORTURE_TEST=y
> 	CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
> 	CONFIG_RCU_CPU_STALL_TIMEOUT=21
> 	CONFIG_RCU_CPU_STALL_VERBOSE=y
> 	CONFIG_RCU_CPU_STALL_INFO=y
> 	CONFIG_RCU_TRACE=n
> 	CONFIG_NR_CPUS=8
> 	CONFIG_HZ_PERIODIC=y
> 	CONFIG_NO_HZ_IDLE=n
> 	CONFIG_NO_HZ_FULL=n
> 	CONFIG_NO_HZ=y
> 	CONFIG_PREEMPT_NONE=n
> 	CONFIG_PREEMPT_VOLUNTARY=n
> 	CONFIG_PREEMPT=y
> 	CONFIG_PREEMPT_COUNT=y

And my system completed 200 boots with two minutes of rcutorture without
failure.  Any thoughts on what I should try next?

							Thanx, Paul

