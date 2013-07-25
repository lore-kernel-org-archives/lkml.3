Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3GYDbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:31:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:16250 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3GYDbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:31:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,740,1367971200"; 
   d="scan'208";a="37265805"
Message-ID: <1374723067.32286.34.camel@hastur.hellion.org.uk>
Subject: Re: [PATCH v3 1/2] xen/balloon: set a mapping for ballooned out
 pages
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <alex@alex.org.uk>,
        <dcrisan@flexiant.com>, <linux-kernel@vger.kernel.org>
Date: Thu, 25 Jul 2013 04:31:07 +0100
In-Reply-To: <20130724145838.GM2518@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1307231820570.4893@kaball.uk.xensource.com>
	 <1374600466-3229-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1374602409.6623.138.camel@hastur.hellion.org.uk>
	 <20130723190521.GA7073@phenom.dumpdata.com>
	 <alpine.DEB.2.02.1307241203240.4893@kaball.uk.xensource.com>
	 <20130724145838.GM2518@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 10:58 -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Jul 24, 2013 at 12:05:05PM +0100, Stefano Stabellini wrote:
> > On Tue, 23 Jul 2013, Konrad Rzeszutek Wilk wrote:
> > > On Tue, Jul 23, 2013 at 07:00:09PM +0100, Ian Campbell wrote:
> > > > On Tue, 2013-07-23 at 18:27 +0100, Stefano Stabellini wrote:
> > > > > +static int __cpuinit balloon_cpu_notify(struct notifier_block *self,
> > > > > +				    unsigned long action, void *hcpu)
> > > > > +{
> > > > > +	int cpu = (long)hcpu;
> > > > > +	switch (action) {
> > > > > +	case CPU_UP_PREPARE:
> > > > > +		if (per_cpu(balloon_scratch_page, cpu) != NULL)
> > > > > +			break;
> > > > 
> > > > Thinking about this a bit more -- do we know what happens to the per-cpu
> > > > area for a CPU which is unplugged and then reintroduced? Is it preserved
> > > > or is it reset?
> > > > 
> > > > If it is reset then this gets more complicated :-( We might be able to
> > > > use the core mm page reference count, so that when the last reference is
> > > > removed the page is automatically reclaimed. We can obviously take a
> > > > reference whenever we add a mapping of the trade page, but I'm not sure
> > > > we are always on the path which removes such mappings... Even then you
> > > > could waste pages for some potentially large amount of time each time
> > > > you replug a VCPU.
> > > > 
> > > > Urg, I really hope the per-cpu area is preserved!
> > > 
> > > It is. During bootup time you see this:
> > > 
> > > [    0.000000] smpboot: Allowing 128 CPUs, 96 hotplug CPU
> > > [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:128 nr_node_ids:1
> > > 
> > > which means that all of the per_CPU are shrunk down to 128 (from 
> > > CONFIG_NR_CPUS=512 was built with) and stays for the lifetime of the kernel.
> > > 
> > > You might have to clear it when the vCPU comes back up though - otherwise you
> > > will have garbage.
> > 
> > I don't see anything in the hotplug code that would modify the value of
> > the per_cpu area of offline cpus.
> 
> You might have never onlined the CPUs and the kernel is built with DEBUG options
> which poison the page.
> 
> Anyhow, doing a memset seems like a prudent thing to do? Perhaps when
> built with CONFG_DEBUG_XENFS you add poison values to it?

The point is that the patches need for the per-cpu areas to *not* be
reinitialised over a vcpu unplug+plug, otherwise we will leak the
original page when we allocate the new one on plug.

We can't just free the page on vcpu unplug because it might still be in
use.

Ian.

