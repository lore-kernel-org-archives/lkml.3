Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933961Ab3GWTFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:05:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50127 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab3GWTFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:05:53 -0400
Date: Tue, 23 Jul 2013 15:05:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, alex@alex.org.uk, dcrisan@flexiant.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xen/balloon: set a mapping for ballooned out pages
Message-ID: <20130723190521.GA7073@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1307231820570.4893@kaball.uk.xensource.com>
 <1374600466-3229-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1374602409.6623.138.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374602409.6623.138.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 07:00:09PM +0100, Ian Campbell wrote:
> On Tue, 2013-07-23 at 18:27 +0100, Stefano Stabellini wrote:
> > +static int __cpuinit balloon_cpu_notify(struct notifier_block *self,
> > +				    unsigned long action, void *hcpu)
> > +{
> > +	int cpu = (long)hcpu;
> > +	switch (action) {
> > +	case CPU_UP_PREPARE:
> > +		if (per_cpu(balloon_scratch_page, cpu) != NULL)
> > +			break;
> 
> Thinking about this a bit more -- do we know what happens to the per-cpu
> area for a CPU which is unplugged and then reintroduced? Is it preserved
> or is it reset?
> 
> If it is reset then this gets more complicated :-( We might be able to
> use the core mm page reference count, so that when the last reference is
> removed the page is automatically reclaimed. We can obviously take a
> reference whenever we add a mapping of the trade page, but I'm not sure
> we are always on the path which removes such mappings... Even then you
> could waste pages for some potentially large amount of time each time
> you replug a VCPU.
> 
> Urg, I really hope the per-cpu area is preserved!

It is. During bootup time you see this:

[    0.000000] smpboot: Allowing 128 CPUs, 96 hotplug CPU
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:128 nr_node_ids:1

which means that all of the per_CPU are shrunk down to 128 (from 
CONFIG_NR_CPUS=512 was built with) and stays for the lifetime of the kernel.

You might have to clear it when the vCPU comes back up though - otherwise you
will have garbage.

Or you can use the zalloc_cpumask_var_node which will allocate a dynamic
version of this. (based on the possible_cpus - so in this case 128).
> 
> Ian.
> 
