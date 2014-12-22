Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaLVWM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:12:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60696 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932134AbaLVWM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:12:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PNP: Switch from __check_region() to __request_region()
Date: Mon, 22 Dec 2014 23:34:48 +0100
Message-ID: <2588457.Skz2ar9t5B@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <87vbl4lynj.fsf@frog.home>
References: <1418072517-5413-1-git-send-email-jsitnicki@gmail.com> <878uid5my1.fsf@frog.home> <87vbl4lynj.fsf@frog.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 22, 2014 12:19:44 PM Jakub Sitnicki wrote:
> On Fri, Dec 12, 2014 at 08:47 AM CET, Jakub Sitnicki wrote:
> > Rafael J. Wysocki <rjw@rjwysocki.net> writes:
> >
> >> On Monday, December 08, 2014 10:01:57 PM Jakub Sitnicki wrote:
> >>> diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
> >>> index 782e822..f980ff7 100644
> >>> --- a/drivers/pnp/resource.c
> >>> +++ b/drivers/pnp/resource.c
> >>> @@ -179,8 +179,9 @@ int pnp_check_port(struct pnp_dev *dev, struct resource *res)
> >>>  	/* check if the resource is already in use, skip if the
> >>>  	 * device is active because it itself may be in use */
> >>>  	if (!dev->active) {
> >>> -		if (__check_region(&ioport_resource, *port, length(port, end)))
> >>> +		if (!request_region(*port, length(port, end), "pnp"))
> >>>  			return 0;
> >>> +		release_region(*port, length(port, end));
> >>
> >> Shouldn't we also release the resource returned by request_region() if it is
> >> not NULL?
> >>
> >
> > Thanks for taking a look at this. I think we're good here. If you please
> > bear with me for a moment:
> >
> > release_resource() removes an element from the list of resource parent's
> > children (and makes it an orphan):
> >
> > 	p = &old->parent->child;
> > 	for (;;) {
> > 		tmp = *p;
> > 		if (!tmp)
> > 			break;
> > 		if (tmp == old) {
> > 			*p = tmp->sibling;
> > 			old->parent = NULL;
> > 			return 0;
> > 		}
> > 		p = &tmp->sibling;
> > 	}
> >
> > release_region() does the same but with additional checks, and also
> > frees the resource:
> >
> > 	p = &parent->child;
> >         /* ... */
> > 	for (;;) {
> > 		struct resource *res = *p;
> >
> > 		if (!res)
> > 			break;
> > 		if (res->start <= start && res->end >= end) {
> >                         /* ... */
> > 			*p = res->sibling;
> >                         /* ... */
> > 			free_resource(res);
> > 			return;
> > 		}
> > 		p = &res->sibling;
> > 	}
> >
> > When making the change I've based on other code in the kernel which also
> > make use of request_region().
> >
> > To quote one example, drivers/net/ethernet/8390/ne2k-pci.c cleans up its
> > I/O port region when initialization fails like so:
> >
> > static int ne2k_pci_init_one(struct pci_dev *pdev,
> > 			     const struct pci_device_id *ent)
> > {
> >         /* ... */
> >
> > 	if (request_region (ioaddr, NE_IO_EXTENT, DRV_NAME) == NULL) {
> > 		dev_err(&pdev->dev, "I/O resource 0x%x @ 0x%lx busy\n",
> > 			NE_IO_EXTENT, ioaddr);
> > 		return -EBUSY;
> > 	}
> >
> >         /* ... */
> >
> > 	dev = alloc_ei_netdev();
> > 	if (!dev) {
> > 		dev_err(&pdev->dev, "cannot allocate ethernet device\n");
> > 		goto err_out_free_res;
> > 	}
> >
> >         /* ... */
> >
> > err_out_free_res:
> > 	release_region (ioaddr, NE_IO_EXTENT);
> > 	return -ENODEV;
> > }
> 
> Just wondering, do you have any further thoughts on this?

I'll queue it up for 3.20 later in January.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
