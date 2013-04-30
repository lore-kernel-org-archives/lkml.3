Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616Ab3D3NAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:00:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49281 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848Ab3D3NAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:00:22 -0400
Date: Tue, 30 Apr 2013 14:59:52 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Jackson <Ian.Jackson@eu.citrix.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2 2/2] xen/balloon: Enforce various limits on target
Message-ID: <20130430125952.GD9904@debian70-amd64.local.net-space.pl>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
 <1367235468-8360-3-git-send-email-daniel.kiper@oracle.com>
 <1367246649.3142.316.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367246649.3142.316.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 03:44:09PM +0100, Ian Campbell wrote:
> On Mon, 2013-04-29 at 12:37 +0100, Daniel Kiper wrote:
>
> > This patch enforces on target limit statically defined in Linux Kernel
> > source and limit defined by hypervisor or host. This way the balloon
> > driver should not attempt to populate pages above given limits
> > because they may fail.
> >
> > Particularly this patch fixes bug which led to flood
> > of dom0 kernel log with messages similar to:
> >
> > System RAM resource [mem 0x1b8000000-0x1bfffffff] cannot be added
> > xen_balloon: reserve_additional_memory: add_memory() failed: -17
>
> I think it would be OK to simply tone down this message (and perhaps add
> the failed pages to the balloon, if that makes sense). This isn't
> dissimilar to increase_reservation failing.

If add_memory() fails it is hard error. It means that we do not
know where new or ballooned pages should be placed.

> > +/*
> > + * Extra internal memory reserved by libxl.
> > + * Check tools/libxl/libxl_memory.txt file in Xen source for more details.
> > + */
> > +#define LIBXL_MAXMEM_CONSTANT_PAGES	(1024 * 1024 / PAGE_SIZE)
>
> I think we need to find a way to achieve your aims which doesn't require
> leaking internal implementation details of libxl into the guest kernels.
> What happens if libxl decides to double this?

I agree that this is not elegant solution. However, if we would like to
be in line with docs/misc/libxl_memory.txt (this is correct path) this
is a must. Once I thought that this value could be passed via xenstore
but I think it is rather small chance it would be changed in near
future. As I know this slack is reserved now just in case (correct me
if I am wrong). If this value will be changed we could pass new value
via xenstore (or other convenient mechanism).

> > +
> >  #ifdef CONFIG_HIGHMEM
> >  #define inc_totalhigh_pages() (totalhigh_pages++)
> >  #define dec_totalhigh_pages() (totalhigh_pages--)
> > @@ -491,11 +496,42 @@ static void balloon_process(struct work_struct *work)
> >  	mutex_unlock(&balloon_mutex);
> >  }
> >
> > -/* Resets the Xen limit, sets new target, and kicks off processing. */
> > +/* Enforce limits, set new target and kick off processing. */
> >  void balloon_set_new_target(unsigned long target)
> >  {
> > +	domid_t domid = DOMID_SELF;
> > +	int rc;
> > +
> > +	/* Enforce statically defined limit. */
> > +	target = min(target, MAX_DOMAIN_PAGES);
> > +
> > +	rc = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
> > +
> > +	if (xen_initial_domain()) {
> > +		if (rc <= 0) {
> > +			pr_debug("xen_balloon: %s: Initial domain target limit "
> > +					"could not be established: %i\n",
> > +					__func__, rc);
> > +			goto no_host_limit;
> > +		}
> > +	} else {
> > +		if (rc <= 0) {
> > +			pr_info("xen_balloon: %s: Guest domain target limit "
> > +				"could not be established: %i\n", __func__, rc);
> > +			goto no_host_limit;
> > +		}
> > +
> > +		/* Do not take into account memory reserved for internal stuff. */
> > +		rc -= LIBXL_MAXMEM_CONSTANT_PAGES;
> > +	}
>
> Why is this needed? Wouldn't it be a toolstack bug to set the target
> greater than this limit? But if it did ask then it would no doubt be
> expecting the guest to try and reach that limit (perhaps it intends to
> raise the maximum later?).

For domU XENMEM_maximum_reservation is always equal
<user_requested_maximum> + LIBXL_MAXMEM_CONSTANT_PAGES.
Acording to docs/misc/libxl_memory.txt LIBXL_MAXMEM_CONSTANT_PAGES
is reserved for extra internal. It means that we should not allow
balloon driver to reserve more than user_requested_maximum.

Daniel
