Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3CFQsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:48:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21339 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3CFQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:48:18 -0500
Date: Wed, 6 Mar 2013 17:47:44 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/1] xen/balloon: Enforce various limits on target
Message-ID: <20130306164744.GB11217@debian70-amd64.local.net-space.pl>
References: <1362431691-5167-1-git-send-email-daniel.kiper@oracle.com>
 <513722DF.6010204@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513722DF.6010204@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 11:05:03AM +0000, David Vrabel wrote:
> On 04/03/13 21:14, Daniel Kiper wrote:
> > This patch enforces on target limit statically defined in Linux Kernel
> > source and limit defined by hypervisor or host.
> >
> > Particularly this patch fixes bug which led to flood
> > of dom0 kernel log with messages similar to:
> >
> > System RAM resource [mem 0x1b8000000-0x1bfffffff] cannot be added
> > xen_balloon: reserve_additional_memory: add_memory() failed: -17
>
> I think this helps in some cases, but because
> reserve_additional_memory() places the hotplugged memory after max_pfn
> without checking if there is anything already there, there are still
> ways it can repeatedly fail.
>
> e.g.,
>
> 1. If dom0 has had its maximum reservation limited initially (with the
> dom0_mem option) /and/ the max reservation and target is subsequently
> raised then the balloon driver will attempt to hotplug memory that
> overlaps with E820_UNUSABLE regions in the e820 map and the hotplug will
> fail.
>
> 2. If a domU has passed-through PCI devices max_pfn is before the PCI
> memory window then the balloon driver will attempt to hotplug memory
> over the PCI device BARs.

You are right. During work on this patch I discovered that but decided
to enforce limits because it is more generic. Please look below why.
However, I stated that it should be fixed too. I added it to my todo list.
It requires a bit more work because I think new algorithm should cover
many different cases. Probably add_memory() (it requires changes in
mm/memory_hotplug.c) should be modified to look for range having
sufficient size and not conflicting with others.

> I think reserve_additional_memory() should check the current resource
> map and the e820 map to find a large enough unused region.  This can be
> done as an additional patch at a later date.
>
> > It does not allow balloon driver to execute infinite
> > loops when target exceeds limits in other cases too.
>
> This sentence confuses me.

For example:
  - boot guest domain with memory = 2048 and maxmem = 2048,
  - xl mem-set 1024,
  - xl mem-max 1536,
  - echo 2097152 > /sys/devices/system/xen_memory/xen_memory0/target_kb,
  - ...and balloon driver without this patch attempts to increase
    reservation until limit is not set to at least 2048...

That is why this patch is more generic.

> > Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> > ---
> >  drivers/xen/balloon.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 46 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> > index a56776d..07da753 100644
> > --- a/drivers/xen/balloon.c
> > +++ b/drivers/xen/balloon.c
> > @@ -65,6 +65,7 @@
> >  #include <xen/balloon.h>
> >  #include <xen/features.h>
> >  #include <xen/page.h>
> > +#include <xen/xenbus.h>
> >
> >  /*
> >   * balloon_process() state:
> > @@ -490,11 +491,55 @@ static void balloon_process(struct work_struct *work)
> >  	mutex_unlock(&balloon_mutex);
> >  }
> >
> > -/* Resets the Xen limit, sets new target, and kicks off processing. */
> > +/* Enforce limits, set new target and kick off processing. */
> >  void balloon_set_new_target(unsigned long target)
> >  {
> > +	domid_t domid = DOMID_SELF;
> > +	int rc;
> > +	unsigned long long host_limit;
> > +
> > +	/* Enforce statically defined limit. */
> > +	target = min(target, MAX_DOMAIN_PAGES);
> > +
> > +	if (xen_initial_domain()) {
> > +		rc = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
> > +
> > +		/* Limit is not enforced by hypervisor. */
> > +		if (rc == -EPERM)
> > +			goto no_host_limit;
> > +
> > +		if (rc <= 0) {
> > +			pr_info("xen_balloon: %s: Initial domain target limit "
> > +				"could not be established: %i\n", __func__, rc);
> > +			goto no_host_limit;
> > +		}
> > +
> > +		host_limit = rc;
>
> I think you should use this method for both dom0 and domUs.  No need to
> check static-max from xenstore.

Sadly XENMEM_maximum_reservation for domU returns value which is set by xl mem-set
not by xl mem-max :-(((... That is why I get this value from xenstore.

> > +	} else {
> > +		rc = xenbus_scanf(XBT_NIL, "memory", "static-max",
> > +							"%llu", &host_limit);
> > +
> > +		if (rc != 1) {
> > +			pr_info("xen_balloon: %s: Guest domain target limit "
> > +				"could not be established: %i\n", __func__, rc);
> > +			goto no_host_limit;
> > +		}
> > +
> > +		/*
> > +		 * The given memory target limit value is in KiB, so it needs
> > +		 * converting to pages. PAGE_SHIFT converts bytes to pages,
> > +		 * hence PAGE_SHIFT - 10.
> > +		 */
> > +		host_limit >>= (PAGE_SHIFT - 10);
> > +	}
> > +
> > +	/* Enforce hypervisor/host defined limit. */
> > +	target = min(target, (unsigned long)host_limit);
>
> With the change above, you can change host_limit to unsigned long and
> avoid the cast.

It is not possible. Please look above why...

Daniel
