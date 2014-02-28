Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaB1COC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:14:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:6896 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaB1COA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:14:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="491264953"
From: "Du, Yuyang" <yuyang.du@intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: [RFC] Splitting scheduler into two halves
Thread-Topic: [RFC] Splitting scheduler into two halves
Thread-Index: Ac80Kq2aoa1KkBsvRPK/b91papdg8g==
Date: Fri, 28 Feb 2014 02:13:32 +0000
Message-ID: <0DA73B5D686AEC4AAEF6054BE04DA1CD116C50EA@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter/Ingo and all,

With the advent of more cores and heterogeneous architectures, the scheduler is required to be more complex (power efficiency) and diverse (big.little). For the scheduler to address that challenge as a whole, it is costly but not necessary. This proposal argues that the scheduler be spitted into two parts: top half (task scheduling) and bottom half (load balance). Let the bottom half take charge of the incoming requirements.

The two halves are rather orthogonal in functionality. The task scheduling (top half) seeks for *ONE* CPU to execute running tasks fairly (priority included), while the load balance (bottom half) aims for *ALL* CPUs to maximize the throughput of the computing power. The goal of task scheduling is pretty unique and clear, and CFS and RT in that part are exactly approaching the goal. The load balance, however, is constrained to meet more goals, to name a few, performance (throughput/responsiveness), power consumption, architecture differences, etc. Those things are often hard to achieve because they may conflict and are difficult to estimate and plan. So, shall we declare the independence of the two, give them freedom to pursue their own "happiness".

We take an incremental development method. As a starting point, we did three things (but did not change one single line of real-work code):
	1)	Remove load balance from fair.c into load_balance.c (~3000 lines of codes). As a result, fair.c/rt.c and load_balance.c have very little intersection.
	2)	Define struct sched_lb_class that consists of the following members to umbrella the load balance entry points.
		a.	const struct sched_lb_class *next;
		b.	int (*fork_balance) (struct task_struct *p, int sd_flags, int wake_flags);
		c.	int (*exec_balance) (struct task_struct *p, int sd_flags, int wake_flags);
		d.	int (*wakeup_balance) (struct task_struct *p, int sd_flags, int wake_flags);
		e.	void (*idle_balance) (int this_cpu, struct rq *this_rq);
		f.	void (*periodic_rebalance) (int cpu, enum cpu_idle_type idle);
		g.	void (*nohz_idle_balance) (int this_cpu, enum cpu_idle_type idle);
		h.	void (*start_periodic_balance) (struct rq *rq, int cpu);
		i.	void (*check_nohz_idle_balance) (struct rq *rq, int cpu);
	3)	Insert another layer of indirection to wrap the implemented functions in sched_lb_class. Implement a default load balance class that is just the previous load balance.

The next to do is to continue redesigning and refactoring to make life easier toward more powerful and diverse load balance. And more importantly, this RFC solicits a discussion to get early feedback on the big proposed change.

Thanks,
Yuyang
