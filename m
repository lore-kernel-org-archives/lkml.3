Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaJYSWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:22:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49861 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaJYSWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:22:20 -0400
Date: Sat, 25 Oct 2014 11:18:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Yanko Kaneti <yaneti@declera.com>, Josh Boyer <jwboyer@fedoraproject.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cong Wang <cwang@twopensource.com>, Kevin Fenzi <kevin@scrye.com>,
        netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        mroos@linux.ee, tj@kernel.org
Subject: Re: localed stuck in recent 3.18 git in copy_net_ns?
Message-ID: <20141025181827.GE28247@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141024212557.GA15537@declera.com>
 <20141024214927.GA4977@linux.vnet.ibm.com>
 <8915.1414190047@famine>
 <20141024225931.GC4977@linux.vnet.ibm.com>
 <20141024230524.GA16023@linux.vnet.ibm.com>
 <10136.1414196448@famine>
 <20141025020324.GA28247@linux.vnet.ibm.com>
 <11813.1414211613@famine>
 <20141025051602.GB28247@linux.vnet.ibm.com>
 <15891.1414255096@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15891.1414255096@famine>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102518-0033-0000-0000-00000276EDD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 09:38:16AM -0700, Jay Vosburgh wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> >On Fri, Oct 24, 2014 at 09:33:33PM -0700, Jay Vosburgh wrote:
> >> 	Looking at the dmesg, the early boot messages seem to be
> >> confused as to how many CPUs there are, e.g.,
> >> 
> >> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> >> [    0.000000] Hierarchical RCU implementation.
> >> [    0.000000]  RCU debugfs-based tracing is enabled.
> >> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> >> [    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
> >> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
> >> [    0.000000] NR_IRQS:16640 nr_irqs:456 0
> >> [    0.000000]  Offload RCU callbacks from all CPUs
> >> [    0.000000]  Offload RCU callbacks from CPUs: 0-3.
> >> 
> >> 	but later shows 2:
> >> 
> >> [    0.233703] x86: Booting SMP configuration:
> >> [    0.236003] .... node  #0, CPUs:      #1
> >> [    0.255528] x86: Booted up 1 node, 2 CPUs
> >> 
> >> 	In any event, the E8400 is a 2 core CPU with no hyperthreading.
> >
> >Well, this might explain some of the difficulties.  If RCU decides to wait
> >on CPUs that don't exist, we will of course get a hang.  And rcu_barrier()
> >was definitely expecting four CPUs.
> >
> >So what happens if you boot with maxcpus=2?  (Or build with
> >CONFIG_NR_CPUS=2.) I suspect that this might avoid the hang.  If so,
> >I might have some ideas for a real fix.
> 
> 	Booting with maxcpus=2 makes no difference (the dmesg output is
> the same).
> 
> 	Rebuilding with CONFIG_NR_CPUS=2 makes the problem go away, and
> dmesg has different CPU information at boot:
> 
> [    0.000000] smpboot: 4 Processors exceeds NR_CPUS limit of 2
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
>  [...]
> [    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
>  [...]
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU debugfs-based tracing is enabled.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] NR_IRQS:4352 nr_irqs:440 0
> [    0.000000] 	Offload RCU callbacks from all CPUs
> [    0.000000] 	Offload RCU callbacks from CPUs: 0-1.

Thank you -- this confirms my suspicions on the fix, though I must admit
to being surprised that maxcpus made no difference.

							Thanx, Paul

