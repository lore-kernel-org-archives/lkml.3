Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3CGL3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:29:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45386 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3CGL3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:29:14 -0500
Date: Thu, 7 Mar 2013 12:28:54 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/1] xen/balloon: Enforce various limits on target
Message-ID: <20130307112854.GC11217@debian70-amd64.local.net-space.pl>
References: <1362431691-5167-1-git-send-email-daniel.kiper@oracle.com>
 <513722DF.6010204@citrix.com>
 <20130306164744.GB11217@debian70-amd64.local.net-space.pl>
 <5137825C.4030805@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5137825C.4030805@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 05:52:28PM +0000, David Vrabel wrote:
> On 06/03/13 16:47, Daniel Kiper wrote:

[...]

> >> I think reserve_additional_memory() should check the current resource
> >> map and the e820 map to find a large enough unused region.  This can be
> >> done as an additional patch at a later date.
> >>
> >>> It does not allow balloon driver to execute infinite
> >>> loops when target exceeds limits in other cases too.
> >>
> >> This sentence confuses me.
>
> I'm just confused by the English.  Perhaps it should say:
>
> "The balloon driver will limit target to the maximum reservation as any
> attempt to populate pages above the maximum reservation will always fail."
>
> ?

That is OK.

[...]

> >>> +	if (xen_initial_domain()) {
> >>> +		rc = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
> >>> +
> >>> +		/* Limit is not enforced by hypervisor. */
> >>> +		if (rc == -EPERM)
> >>> +			goto no_host_limit;
> >>> +
> >>> +		if (rc <= 0) {
> >>> +			pr_info("xen_balloon: %s: Initial domain target limit "
> >>> +				"could not be established: %i\n", __func__, rc);
> >>> +			goto no_host_limit;
> >>> +		}
> >>> +
> >>> +		host_limit = rc;
> >>
> >> I think you should use this method for both dom0 and domUs.  No need to
> >> check static-max from xenstore.
> >
> > Sadly XENMEM_maximum_reservation for domU returns value which is set by xl mem-set
> > not by xl mem-max :-(((... That is why I get this value from xenstore.
>
> It gets d->max_pages which the limit for d->tot_pages. d->max_pages is
> set by xl mem-max (and xl mem-set as it uses the enforce option to

No, it was tested by me and d->max_pages is set by xl mem-set (it is
current target). d->tot_pages has count of pages for a given moment.
It is confusing for me but this is the reality.

> libxl_set_memory_target()).
>
> If you set the target above d->max_pages you won't be able to populate them.
>
> So, using the maximum_reservation call seems like the right thing to me.

Please look above. If you use this value you would not
be able to increase reservation.

Daniel
