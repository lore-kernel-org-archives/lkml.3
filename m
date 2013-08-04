Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3HDOax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:30:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28659 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab3HDOaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:30:52 -0400
X-IronPort-AV: E=Sophos;i="4.89,812,1367971200"; 
   d="scan'208";a="41259101"
Date: Sun, 4 Aug 2013 15:30:36 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <alex@alex.org.uk>,
        <dcrisan@flexiant.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] xen/balloon: set a mapping for ballooned out
 pages
In-Reply-To: <20130729141036.GB5848@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1308041530000.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307231820570.4893@kaball.uk.xensource.com> <1374600466-3229-1-git-send-email-stefano.stabellini@eu.citrix.com> <1374602409.6623.138.camel@hastur.hellion.org.uk> <20130723190521.GA7073@phenom.dumpdata.com>
 <alpine.DEB.2.02.1307241203240.4893@kaball.uk.xensource.com> <20130724145838.GM2518@phenom.dumpdata.com> <1374723067.32286.34.camel@hastur.hellion.org.uk> <20130729141036.GB5848@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 25, 2013 at 04:31:07AM +0100, Ian Campbell wrote:
> > On Wed, 2013-07-24 at 10:58 -0400, Konrad Rzeszutek Wilk wrote:
> > > On Wed, Jul 24, 2013 at 12:05:05PM +0100, Stefano Stabellini wrote:
> > > > On Tue, 23 Jul 2013, Konrad Rzeszutek Wilk wrote:
> > > > > On Tue, Jul 23, 2013 at 07:00:09PM +0100, Ian Campbell wrote:
> > > > > > On Tue, 2013-07-23 at 18:27 +0100, Stefano Stabellini wrote:
> > > > > > > +static int __cpuinit balloon_cpu_notify(struct notifier_block *self,
> > > > > > > +				    unsigned long action, void *hcpu)
> > > > > > > +{
> > > > > > > +	int cpu = (long)hcpu;
> > > > > > > +	switch (action) {
> > > > > > > +	case CPU_UP_PREPARE:
> > > > > > > +		if (per_cpu(balloon_scratch_page, cpu) != NULL)
> > > > > > > +			break;
> > > > > > 
> > > > > > Thinking about this a bit more -- do we know what happens to the per-cpu
> > > > > > area for a CPU which is unplugged and then reintroduced? Is it preserved
> > > > > > or is it reset?
> > > > > > 
> > > > > > If it is reset then this gets more complicated :-( We might be able to
> > > > > > use the core mm page reference count, so that when the last reference is
> > > > > > removed the page is automatically reclaimed. We can obviously take a
> > > > > > reference whenever we add a mapping of the trade page, but I'm not sure
> > > > > > we are always on the path which removes such mappings... Even then you
> > > > > > could waste pages for some potentially large amount of time each time
> > > > > > you replug a VCPU.
> > > > > > 
> > > > > > Urg, I really hope the per-cpu area is preserved!
> > > > > 
> > > > > It is. During bootup time you see this:
> > > > > 
> > > > > [    0.000000] smpboot: Allowing 128 CPUs, 96 hotplug CPU
> > > > > [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:128 nr_node_ids:1
> > > > > 
> > > > > which means that all of the per_CPU are shrunk down to 128 (from 
> > > > > CONFIG_NR_CPUS=512 was built with) and stays for the lifetime of the kernel.
> > > > > 
> > > > > You might have to clear it when the vCPU comes back up though - otherwise you
> > > > > will have garbage.
> > > > 
> > > > I don't see anything in the hotplug code that would modify the value of
> > > > the per_cpu area of offline cpus.
> > > 
> > > You might have never onlined the CPUs and the kernel is built with DEBUG options
> > > which poison the page.
> > > 
> > > Anyhow, doing a memset seems like a prudent thing to do? Perhaps when
> > > built with CONFG_DEBUG_XENFS you add poison values to it?
> > 
> > The point is that the patches need for the per-cpu areas to *not* be
> > reinitialised over a vcpu unplug+plug, otherwise we will leak the
> > original page when we allocate the new one on plug.
> 
> OK.
> > 
> > We can't just free the page on vcpu unplug because it might still be in
> > use.
> 
> I am still worried about before-the-cpu-is-up-the-per-cpu-has-garbage case.
> We could add code in the boot-before-smp (so when there is only one CPU) to
> do:
> 
> for_each_possible(cpu)
> 	memset(__per_cpu(some_memory),0,sizeof...);
> 
> and then I think it satisfies your concerns and mine?

OK, I'll add an early_initcall.
