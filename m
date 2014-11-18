Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaKRJbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:31:40 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:64662 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaKRJbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:31:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Yijing Wang <wangyijing@huawei.com>
Cc: linuxppc-dev@lists.ozlabs.org, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Suravee.Suthikulpanit@amd.com, linux-ia64@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Wuyun <wuyun.wu@huawei.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 07/16] PCI: Separate pci_host_bridge creation out of pci_create_root_bus()
Date: Tue, 18 Nov 2014 10:30:10 +0100
Message-ID: <1936415.emTbbPeHqx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546B041A.4060403@huawei.com>
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <2507218.mHliopJb05@wuerfel> <546B041A.4060403@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zyrY0qw6MhZEqgwID3XCVMHKLVhZoYKMfgkLatvmSuD
 yb7AfxNvhPzXipWKuYgbmx5LdN/zvvdzqDu9ReZEL2qS/pluSV
 Q/byTX183GVZY8H+XPtKhjxeKfGlftRasbjRLl0I+5PM0q4vI8
 6YJliBFWWmaIXi7PQQuvX2FZXaPgIHA6KwWzcDkO/t///qJdji
 jsEgaTJlH3U3AlgAe8qZss6Pb1goPrhgX7ycp7yB/nEnmuATS6
 S9YOqabuYkMdMwLiZwlDzI4n9Zuq0roCeO3uySE/+EZy4Tk9R4
 2thTbbts/qpZ7so9MjrV8G1KgMgYYUddZfXmmJXl/PkkN7u2ym
 kGhDekExlPTuuILvkHIU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2014 16:32:26 Yijing Wang wrote:

> >> +static struct resource busn_resource = {
> >> +	.name	= "PCI busn",
> >> +	.start	= 0,
> >> +	.end	= 255,
> >> +	.flags	= IORESOURCE_BUS,
> >> +};
> > 
> > I think it would be better to require callers to pass the bus resource
> > down to the function.
> 
> Hmm, I think most of caller will provide the bus resource, but some others
> will not give any bus resource, extremely, no any resources :(. But we still
> need properly configure their resources for compatibility.

I think that is what the conversion to pci_scan_bus_parented() is about:
The idea is that we add the correct bus resource to callers of
pci_scan_bus_parented or pci_scan_bus and then change them to call
pci_scan_root_bus instead.

> >> +struct pci_host_bridge *pci_create_host_bridge(
> >> +		struct device *parent, u32 db, 
> >> +		struct pci_ops *ops, void *sysdata, 
> >> +		struct list_head *resources)
> >> +{
> > 
> > Do we still need to pass the 'sysdata' in here? If we are guaranteed to
> > have a device pointer, we should always be able to get the driver
> > private data from dev_get_drvdata(host->dev->parent).
> 
> We need, some platforms pass NULL pointer as host bridge parent.

But those don't have to use the new pci_create_host_bridge() function,
right?

> >> +	host = kzalloc(sizeof(*host), GFP_KERNEL);
> >> +	if (!host)
> >> +		return NULL;
> > 
> > devm_kzalloc maybe?
> 
> I don't know much detail about devm_kzalloc(), but we have no pci host driver
> here, and I found no devm_kzalloc() uses in core PCI code before.

It also depends on having a valid device pointer. The idea is that the memory
is automatically freed if the probe() function returns with an error, or
the device driver gets unloaded. For the classic PCI hosts that are not
connected to a device, that wouldn't work of course.

	Arnd
