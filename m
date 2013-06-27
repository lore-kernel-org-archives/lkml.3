Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3F0Iy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:54:56 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53014 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753262Ab3F0Iyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:54:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 15/45] rcu: Use get/put_online_cpus_atomic() to prevent CPU offline
Date: Thu, 27 Jun 2013 09:54:41 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B72AB@saturn3.aculab.com>
In-Reply-To: <51CB3159.8000509@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 15/45] rcu: Use get/put_online_cpus_atomic() to prevent CPU offline
thread-index: Ac5ympKrkc7SHUweQxex3RwLfAPpSAAdzsqg
References: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com> <20130625202755.16593.67819.stgit@srivatsabhat.in.ibm.com> <20130625220026.GG3828@linux.vnet.ibm.com> <51CAF624.6060004@linux.vnet.ibm.com> <AE90C24D6B3A694183C094C60CF0A2F6026B72AA@saturn3.aculab.com> <20130626143424.GN3828@linux.vnet.ibm.com> <1372258271.18733.256.camel@gandalf.local.home> <20130626152148.GA4405@mtj.dyndns.org> <51CB3159.8000509@linux.vnet.ibm.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Tejun Heo" <tj@kernel.org>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, <paulmck@linux.vnet.ibm.com>,
        <peterz@infradead.org>, <fweisbec@gmail.com>,
        <linux-kernel@vger.kernel.org>, <walken@google.com>,
        <mingo@kernel.org>, <linux-arch@vger.kernel.org>,
        <vincent.guittot@linaro.org>, <xiaoguangrong@linux.vnet.ibm.com>,
        <wangyun@linux.vnet.ibm.com>, <nikunj@linux.vnet.ibm.com>,
        <linux-pm@vger.kernel.org>, <rusty@rustcorp.com.au>,
        <namhyung@kernel.org>, <tglx@linutronix.de>, <laijs@cn.fujitsu.com>,
        <zhong@linux.vnet.ibm.com>, <netdev@vger.kernel.org>,
        <oleg@redhat.com>, <sbw@mit.edu>, <akpm@linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> It would also increase the latency of CPU-hotunplug operations.
> >>
> >> Is that a big deal?
> >
> > I thought that was the whole deal with this patchset - making cpu
> > hotunplugs lighter and faster mostly for powersaving.  That said, just
> > removing stop_machine call would be a pretty good deal and I don't
> > know how meaningful reducing CPU hotunplug latency is.  Srivatsa?
> >
> 
> Keeping the hotunplug latency is important for suspend/resume, where
> we take all non-boot CPUs in a loop. That's an interesting use-case
> where intrusiveness doesn't matter much, but latency does. So yes,
> making CPU hotplug faster is also one of the goals of this patchset.

If you are removing all but one of the cpu, the you only need
one rcu cycle (remove everything from the list first).

I'd also guess that you can't suspend a cpu until you can sleep
the process that is running on it - so if a process has pre-emption
disabled you aren't going to complete suspend until the process
sleeps (this wouldn't be true if you suspended the cpu with its
current stack - but if suspend is removing the non-boot cpus first
it must be doing so from the scheduler idle loop).

If you are doing suspend for aggressive power saving, then all the
processes (and processors) will already be idle. However you
probably wouldn't want the memory accesses to determine this on
a large NUMA system with 1024+ processors.

	David



