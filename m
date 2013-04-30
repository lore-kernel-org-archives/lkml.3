Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586Ab3D3MlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 08:41:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34316 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab3D3MlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 08:41:21 -0400
Date: Tue, 30 Apr 2013 14:40:58 +0200
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
Subject: Re: [PATCH v2 1/2] xen/balloon: Notify a host about a guest memory
 size limit
Message-ID: <20130430124058.GC9904@debian70-amd64.local.net-space.pl>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
 <1367235468-8360-2-git-send-email-daniel.kiper@oracle.com>
 <1367246111.3142.309.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367246111.3142.309.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 03:35:11PM +0100, Ian Campbell wrote:
> On Mon, 2013-04-29 at 12:37 +0100, Daniel Kiper wrote:
> > Notify a host about a guest memory size limit.
> >
> > Idea of this patch was discussed with Ian Campbell and Ian Jackson.
> >
> > Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> > ---
> >  drivers/xen/balloon.c |   25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >
> > diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> > index a56776d..856661f 100644
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
> > @@ -586,6 +587,9 @@ static void __init balloon_add_region(unsigned long start_pfn,
> >  static int __init balloon_init(void)
> >  {
> >  	int i;
> > +#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
> > +	int rc;
> > +#endif
> >
> >  	if (!xen_domain())
> >  		return -ENODEV;
> > @@ -621,6 +625,27 @@ static int __init balloon_init(void)
> >  			balloon_add_region(PFN_UP(xen_extra_mem[i].start),
> >  					   PFN_DOWN(xen_extra_mem[i].size));
> >
> > +#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
> > +	/*
> > +	 * Notify a host about our memory size limit.
> > +	 *
> > +	 * The guest-max value is in KiB, so MAX_DOMAIN_PAGES should
> > +	 * be converted respectively. PAGE_SHIFT converts pages to bytes,
> > +	 * hence PAGE_SHIFT - 10.
> > +	 */
> > +	rc = xenbus_printf(XBT_NIL, "memory", "guest-max", "%lu",
> > +				MAX_DOMAIN_PAGES << (PAGE_SHIFT - 10));
> > +
> > +	if (rc < 0)
> > +		pr_info("xen/balloon: Memory hotplug may not be supported "
> > +			"in some environments: %i\n", rc);
> > +#else
> > +	xenbus_printf(XBT_NIL, "memory", "guest-max", "%lu",
>
> Would it be OK to not do anything in the non-hotplug case? That's just

As I stated earlier I think that every new polite guest, with or without
memory hotplug, should inform about its maximum supported memory size.

> the historical behaviour right?

Yes, it is.

> Would you expect this value to differ from static-max?

On my test system it is static-max + 8 MiB.

Daniel
