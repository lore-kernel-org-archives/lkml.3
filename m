Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3GJChV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:37:21 -0400
Received: from ozlabs.org ([203.10.76.45]:37374 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab3GJChT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:37:19 -0400
Date: Wed, 10 Jul 2013 12:37:16 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, mingo@kernel.org,
        Stephane Eranian <eranian@google.com>, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130710023715.GC7491@concordia>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
 <20130704125218.GA21134@concordia>
 <20130704125700.GM18898@dyad.programming.kicks-ass.net>
 <20130709012952.GA7185@concordia>
 <alpine.DEB.2.10.1307082204550.26280@vincent-weaver-1.um.maine.edu>
 <20130709033402.GA8543@concordia>
 <alpine.DEB.2.10.1307091113010.675@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307091113010.675@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 11:20:50AM -0400, Vince Weaver wrote:
> On Tue, 9 Jul 2013, Michael Ellerman wrote:
> 
> > On Mon, Jul 08, 2013 at 10:24:34PM -0400, Vince Weaver wrote:
> > > why is it a hack to use cpuid?
> > 
> > Because you're assuming that the PMU the kernel has exposed is for the
> > cpu you happen to be executing on.
> > 
> > But the real issue is with PMUs that are not in the CPU - there is no
> > easy way for userspace to detect them and determine which event list it
> > should be consulting.
> 
> what kind of devices are you talking about?  

GPUs, PCI host bridges, memory controllers, PCI attached accelerators,
strange devices on non standard buses, you name it.

> If they have kernel/perf_event support then they'd be putting a
> directory entry with a unique name into
> /sys/bus/event_source/devices/, right?

Yes. But although the name is unique it's not sufficient to actually
identify the list of events.

For example the CPU PMU is called "cpu" on most architectures, so userspace
needs to work out which exact CPU it is - and I know that's possible,
but it means the "simple little" event parsing library is not so simple
anymore.

Then imagine you have a GPU on PCI which registers its PMU as "gpu" -
how do you work out which GPU it is? Userspace can probably work it out
by trawling through sysfs and finding the vendor and device ids and
matching that with a lookup table. The library just got less simple
again.

Now say you have a PMU in your memory controller, it's not represented
in sysfs except for the PMU. Which memory controller is it? Maybe you
can infer it from the CPU you're on, but maybe you can't.

> > This whole thread is about making the event list not the kernel's job?
> 
> Yes.  This has been debated forever here; I'm firmly in the "event lists 
> should be entirely in userspace" camp but that's not the majority 
> position.

Yes we agree on the event list being in userspace, you can stop trying
to convince me.

What shouldn't be in userspace is the logic to detect which PMUs are
available on the system.

cheers
