Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3LRJvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:51:40 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59052 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab3LRJv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:51:28 -0500
Date: Wed, 18 Dec 2013 17:51:16 +0800
From: Guo Chao <yan@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/5] PCI: Try best to allocate pref mmio 64bit above 4g
Message-ID: <20131218095116.GA961@yanx>
References: <1386658484-15774-1-git-send-email-yinghai@kernel.org>
 <1386658484-15774-5-git-send-email-yinghai@kernel.org>
 <20131216082329.GA4926@yanx>
 <CAE9FiQWONC84f35_Jyvs=nwXdj4QWCBdokOgiFWDgWSSpcf_NA@mail.gmail.com>
 <CAE9FiQVQUsvYuRJQyvbyCkGjwwaKsgF2b8wTzi-KV4vex7Y5mg@mail.gmail.com>
 <CAE9FiQV8kJZz0oaiZOvfWce_bu+8nZB2Qtw7KjLeASTkwUrjug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV8kJZz0oaiZOvfWce_bu+8nZB2Qtw7KjLeASTkwUrjug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121809-0260-0000-0000-0000041C6BFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:
On Mon, Dec 16, 2013 at 04:36:32PM -0800, Yinghai Lu wrote:
> On Mon, Dec 16, 2013 at 1:36 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Mon, Dec 16, 2013 at 10:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>>
> >>> 64-bit non-prefetchable BARs are missed from caculation in the scheme,
> >>> causing assign failed eventually.
> 
> >>>
> >>> Will you figure out a better way to cover them or just add a 'type3' parameter?
> >
> > Looks like we have add type3 for that case.
> 
> please check attached delta patch.
> 

It works, thank you.

Guo Chao

> Thanks
> 
> Yinghai

> ---
>  drivers/pci/setup-bus.c |   17 +++++++++++------
>  drivers/pci/setup-res.c |    8 ++++++--
>  2 files changed, 17 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -916,6 +916,7 @@ static inline resource_size_t calculate_
>   */
>  static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  			 unsigned long type, unsigned long type2,
> +			 unsigned long type3,
>  			 resource_size_t min_size, resource_size_t add_size,
>  			 struct list_head *realloc_head)
>  {
> @@ -946,7 +947,8 @@ static int pbus_size_mem(struct pci_bus
>  			resource_size_t r_size;
>  
>  			if (r->parent || ((r->flags & mask) != type &&
> -					  (r->flags & mask) != type2))
> +					  (r->flags & mask) != type2 &&
> +					  (r->flags & mask) != type3))
>  				continue;
>  			r_size = resource_size(r);
>  #ifdef CONFIG_PCI_IOV
> @@ -1119,7 +1121,7 @@ void __ref __pci_bus_size_bridges(struct
>  			struct list_head *realloc_head)
>  {
>  	struct pci_dev *dev;
> -	unsigned long mask, prefmask, type2 = 0;
> +	unsigned long mask, prefmask, type2 = 0, type3 = 0;
>  	resource_size_t additional_mem_size = 0, additional_io_size = 0;
>  	struct resource *b_res;
>  
> @@ -1171,26 +1173,29 @@ void __ref __pci_bus_size_bridges(struct
>  		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
>  		if (b_res[2].flags & IORESOURCE_MEM_64) {
>  			prefmask |= IORESOURCE_MEM_64;
> -			if (pbus_size_mem(bus, prefmask, prefmask, prefmask,
> +			if (pbus_size_mem(bus, prefmask, prefmask,
> +				  prefmask, prefmask,
>  				  realloc_head ? 0 : additional_mem_size,
>  				  additional_mem_size, realloc_head)) {
>  					/* Success, size non-pref64 only. */
>  					mask = prefmask;
>  					type2 = prefmask & ~IORESOURCE_MEM_64;
> +					type3 = prefmask & ~IORESOURCE_PREFETCH;
>  			}
>  		}
>  		if (!type2) {
>  			prefmask &= ~IORESOURCE_MEM_64;
> -			if (pbus_size_mem(bus, prefmask, prefmask, prefmask,
> +			if (pbus_size_mem(bus, prefmask, prefmask,
> +					 prefmask, prefmask,
>  					 realloc_head ? 0 : additional_mem_size,
>  					 additional_mem_size, realloc_head)) {
>  				/* Success, size non-prefetch only. */
>  				mask = prefmask;
>  			} else
>  				additional_mem_size += additional_mem_size;
> -			type2 = IORESOURCE_MEM;
> +			type2 = type3 = IORESOURCE_MEM;
>  		}
> -		pbus_size_mem(bus, mask, IORESOURCE_MEM, type2,
> +		pbus_size_mem(bus, mask, IORESOURCE_MEM, type2, type3,
>  				realloc_head ? 0 : additional_mem_size,
>  				additional_mem_size, realloc_head);
>  		break;
> Index: linux-2.6/drivers/pci/setup-res.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-res.c
> +++ linux-2.6/drivers/pci/setup-res.c
> @@ -212,7 +212,8 @@ static int __pci_assign_resource(struct
>  				     pcibios_align_resource, dev);
>  
>  	if (ret < 0 &&
> -	    (res->flags & (IORESOURCE_PREFETCH | IORESOURCE_MEM_64))) {
> +	    (res->flags & (IORESOURCE_PREFETCH | IORESOURCE_MEM_64)) ==
> +	     (IORESOURCE_PREFETCH | IORESOURCE_MEM_64)) {
>  		/*
>  		 * That failed.
>  		 *
> @@ -223,12 +224,15 @@ static int __pci_assign_resource(struct
>  					     pcibios_align_resource, dev);
>  	}
>  
> -	if (ret < 0 && (res->flags & IORESOURCE_PREFETCH)) {
> +	if (ret < 0 &&
> +	    (res->flags & (IORESOURCE_PREFETCH | IORESOURCE_MEM_64))) {
>  		/*
>  		 * That failed.
>  		 *
>  		 * But a prefetching area can handle a non-prefetching
>  		 * window (it will just not perform as well).
> +		 *
> +		 * Also can put 64bit under 32bit range. (below 4g).
>  		 */
>  		ret = pci_bus_alloc_resource(bus, res, size, align, min, 0,
>  					     pcibios_align_resource, dev);

