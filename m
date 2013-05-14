Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab3EOAoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 20:44:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:34542 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab3EOAoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 20:44:07 -0400
Message-ID: <1368574202.31689.54.camel@pasglop>
Subject: Re: [RFC PATCH v2, part 2 09/18] PCI, PPC: use hotplug-safe
 iterators to walk PCI buses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bill Pemberton <wfp5p@virginia.edu>, linuxppc-dev@lists.ozlabs.org
Date: Wed, 15 May 2013 09:30:02 +1000
In-Reply-To: <1368550322-1045-9-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
	 <1368550322-1045-9-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 00:51 +0800, Jiang Liu wrote:
> Enhance PPC architecture specific code to use hotplug-safe iterators
> to walk PCI buses.

I was about to ack it but then I saw:

> diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
> index 51a133a..a41c6dd 100644
> --- a/arch/powerpc/kernel/pci_64.c
> +++ b/arch/powerpc/kernel/pci_64.c
> @@ -208,7 +208,6 @@ long sys_pciconfig_iobase(long which, unsigned long in_bus,
>  			  unsigned long in_devfn)
>  {
>  	struct pci_controller* hose;
> -	struct list_head *ln;
>  	struct pci_bus *bus = NULL;
>  	struct device_node *hose_node;
>  
> @@ -229,18 +228,16 @@ long sys_pciconfig_iobase(long which, unsigned long in_bus,
>  	/* That syscall isn't quite compatible with PCI domains, but it's
>  	 * used on pre-domains setup. We return the first match
>  	 */
> -
> -	for (ln = pci_root_buses.next; ln != &pci_root_buses; ln = ln->next) {
> -		bus = pci_bus_b(ln);
> -		if (in_bus >= bus->number && in_bus <= bus->busn_res.end)
> +	for_each_pci_root_bus(bus)
> +		if (in_bus >= bus->number && in_bus <= bus->busn_res.end &&
> +		    bus->dev.of_node)
>  			break;
> -		bus = NULL;
> -	}
> -	if (bus == NULL || bus->dev.of_node == NULL)
> +	if (bus == NULL)
>  		return -ENODEV;

You just removed the NULL check for the of_node field...
 
>  	hose_node = bus->dev.of_node;
>  	hose = PCI_DN(hose_node)->phb;

Which is dereferrenced here.	

> +	pci_bus_put(bus);

On the other hand, the whole thing can probably be using
pci_bus_to_host() instead.... the above code is bitrotted.

>  	switch (which) {
>  	case IOBASE_BRIDGE_NUMBER:
 
Cheeers,
Ben.


