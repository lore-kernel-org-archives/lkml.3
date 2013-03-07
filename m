Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab3CGO0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:26:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33135 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab3CGO0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:26:04 -0500
Date: Thu, 7 Mar 2013 15:25:35 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        ian.jackson@eu.citrix.com, ian.campbell@citrix.com
Subject: Re: [PATCH 1/1] xen/balloon: Enforce various limits on target
Message-ID: <20130307142535.GD11217@debian70-amd64.local.net-space.pl>
References: <1362431691-5167-1-git-send-email-daniel.kiper@oracle.com>
 <513722DF.6010204@citrix.com>
 <20130306164744.GB11217@debian70-amd64.local.net-space.pl>
 <5137825C.4030805@citrix.com>
 <20130307112854.GC11217@debian70-amd64.local.net-space.pl>
 <513882ED.8040208@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513882ED.8040208@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 12:07:09PM +0000, David Vrabel wrote:
> On 07/03/13 11:28, Daniel Kiper wrote:
> > On Wed, Mar 06, 2013 at 05:52:28PM +0000, David Vrabel wrote:
> >
> >> If you set the target above d->max_pages you won't be able to populate them.
> >>
> >> So, using the maximum_reservation call seems like the right thing to me.
> >
> > Please look above. If you use this value you would not
> > be able to increase reservation.
>
> I don't think I'm understanding the use case you're talking about.
>
> Do you mean we should allow a target <= d->tot_pages even if this is
> above d->max_pages?  I agree with this.
>
> Something like this:
>
> void balloon_set_new_target(unsigned long target)
> {
> 	domid_t domid = DOMID_SELF;
> 	int rc;
> 	unsigned long host_limit;
>
> 	target = min(target, MAX_DOMAIN_PAGES);
>
> 	/* Prevent target from attempting the expand the reservation
> 	   above the max enforced by the hypervisor. */
> 	rc = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
> 	if (rc > 0) {
> 		host_limit = rc;
> 		target = min(target,
> 			max(host_limit, balloon_stats.current_pages));
> 	}
>
> 	balloon_stats.target_pages = target;
> 	schedule_delayed_work(&balloon_worker, 0);
> }

I dug deeper into Xen source and found some strange things for me.

If you call xl mem-set it does two things:
  - sets target in xenstore,
  - sets d->max_pages (sic!).

Last thing is very confusing because at least command comment
does mention nothing about this behavior. Comment for this
command states: "Set the current memory usage for a domain".
It does say nothing about setting memory usage limit. IMO it is
the role of xl mem-max (another strange thing is that xl mem-max
sets d->max_pages but does not touch static-max; I think it should
be changed too; now it is not possible to increase limit above
maxmem defined at startup which makes memory hotplug practically
unusable). That is why xl mem-set behavior should be changed
(IIRC xm sets only target in xenstore) or comment should be aligned
to what xl code doas in real. Then we could back to discussion about
new balloon_set_new_target().

Daniel
