Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaCEITf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:19:35 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34131 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaCEITd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:19:33 -0500
Date: Wed, 5 Mar 2014 08:19:29 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Yijing Wang'" <wangyijing@huawei.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>
Subject: Re: [PATCH v5 3/7] pci: Create pci_host_bridge before its associated
 bus in pci_create_root_bus.
Message-ID: <20140305081929.GE1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Jingoo Han <jg1.han@samsung.com>,
	'Yijing Wang' <wangyijing@huawei.com>,
	'linux-pci' <linux-pci@vger.kernel.org>,
	'Bjorn Helgaas' <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	'linaro-kernel' <linaro-kernel@lists.linaro.org>,
	'Benjamin Herrenschmidt' <benh@kernel.crashing.org>,
	'LKML' <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	'LAKML' <linux-arm-kernel@lists.infradead.org>,
	'Tanmay Inamdar' <tinamdar@apm.com>,
	'Arnd Bergmann' <arnd@arndb.de>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
 <1393948204-11555-4-git-send-email-Liviu.Dudau@arm.com>
 <53169E86.1090609@huawei.com>
 <002401cf382d$3062aa50$9127fef0$%han@samsung.com>
MIME-Version: 1.0
In-Reply-To: <002401cf382d$3062aa50$9127fef0$%han@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 05 Mar 2014 08:19:30.0691 (UTC) FILETIME=[A1E58530:01CF384B]
X-MC-Unique: 114030508193103701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 04:41:35AM +0000, Jingoo Han wrote:
> On Wednesday, March 05, 2014 12:48 PM, Yijing Wang wrote:
> > On 2014/3/4 23:50, Liviu Dudau wrote:
> > > Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
> > > As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
> > > the creation order has been changed for no good reason. Revert the order of
> > > creation as we are going to depend on the pci_host_bridge structure to retrieve the
> > > domain number of the root bus.
> > >
> > > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > >
> > > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > > index 6e34498..78ccba0 100644
> > > --- a/drivers/pci/probe.c
> > > +++ b/drivers/pci/probe.c
> > > @@ -505,7 +505,7 @@ static void pci_release_host_bridge_dev(struct device *dev)
> > >  	kfree(bridge);
> > >  }
> > >
> > > -static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
> > > +static struct pci_host_bridge *pci_alloc_host_bridge(void)
> > >  {
> > >  	struct pci_host_bridge *bridge;
> > >
> > > @@ -514,7 +514,6 @@ static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
> > >  		return NULL;
> > >
> > >  	INIT_LIST_HEAD(&bridge->windows);
> > > -	bridge->bus = b;
> > >  	return bridge;
> > >  }
> > >
> > > @@ -1727,9 +1726,21 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> > >  	char bus_addr[64];
> > >  	char *fmt;
> > >
> > > +	bridge = pci_alloc_host_bridge();
> > > +	if (!bridge)
> > > +		return NULL;
> > > +
> > > +	bridge->dev.parent = parent;
> > > +	bridge->dev.release = pci_release_host_bridge_dev;
> > > +	error = pcibios_root_bridge_prepare(bridge);
> > > +	if (error) {
> > > +		kfree(bridge);
> > > +		return NULL;
> > 
> > What about use goto err_out?
> 
> +1
> 
> I agree with your opinion.
> It makes the code simpler.

Hi Yijing and Jingoo,

Thanks for reviewing these patches, I will make the change for the next version.

Best regards,
Liviu

> 
> Best regards,
> Jingoo Han
> 
> > 
> > > +	}
> > > +
> > >  	b = pci_alloc_bus();
> > >  	if (!b)
> > > -		return NULL;
> > > +		goto err_out;
> > >
> > >  	b->sysdata = sysdata;
> > >  	b->ops = ops;
> > > @@ -1738,26 +1749,15 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> > >  	if (b2) {
> > >  		/* If we already got to this bus through a different bridge, ignore it */
> > >  		dev_dbg(&b2->dev, "bus already known\n");
> > > -		goto err_out;
> > > +		goto err_bus_out;
> > >  	}
> > >
> > > -	bridge = pci_alloc_host_bridge(b);
> > > -	if (!bridge)
> > > -		goto err_out;
> > > -
> > > -	bridge->dev.parent = parent;
> > > -	bridge->dev.release = pci_release_host_bridge_dev;
> > > +	bridge->bus = b;
> > >  	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
> > > -	error = pcibios_root_bridge_prepare(bridge);
> > > -	if (error) {
> > > -		kfree(bridge);
> > > -		goto err_out;
> > > -	}
> > > -
> > >  	error = device_register(&bridge->dev);
> > >  	if (error) {
> > >  		put_device(&bridge->dev);
> > > -		goto err_out;
> > > +		goto err_bus_out;
> > >  	}
> > >  	b->bridge = get_device(&bridge->dev);
> > >  	device_enable_async_suspend(b->bridge);
> > > @@ -1814,8 +1814,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> > >  class_dev_reg_err:
> > >  	put_device(&bridge->dev);
> > >  	device_unregister(&bridge->dev);
> > > -err_out:
> > > +err_bus_out:
> > >  	kfree(b);
> > > +err_out:
> > > +	kfree(bridge);
> > >  	return NULL;
> > >  }
> > >
> > >
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

