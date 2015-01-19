Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbbASML0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:11:26 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:53630 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbASMLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:11:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Yijing Wang <wangyijing@huawei.com>, Liviu Dudau <liviu@dudau.co.uk>,
        Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-alpha@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-ia64@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 10/28] PCI: Save sysdata in pci_host_bridge drvdata
Date: Mon, 19 Jan 2015 10:52:06 +0100
Message-ID: <20928659.d8sezC2Vk4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54BC7632.1080003@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <18973877.BYCS6vtzoq@wuerfel> <54BC7632.1080003@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:oBNNhJaq1neXDGQcHpcZkdM4gCigPbWcQM1zKNDa9CPWFlt2GCV
 ldV3i9Gc5TH+SuAHD9VtYdVFQt5pes4wn/Z4l906bIQUULPns63a9TQF4GakxP/we9tbkUq
 S0oFsYKV7sJhalBXgCvgMWu9hY/K/UQVumrWQY20B8cyQyt++xiogFFcSKiS3qHUbomwFVz
 2ySiqqWb9h46fd41bi/EQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2015 11:12:50 Yijing Wang wrote:
> On 2015/1/16 17:18, Arnd Bergmann wrote:
> > On Friday 16 January 2015 09:44:08 Yijing Wang wrote:
> >> @@ -2066,11 +2064,11 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, u32 db,
> >>  {
> >>         struct pci_host_bridge *host;
> >>  
> >> -       host = pci_create_host_bridge(parent, db, resources);
> >> +       host = pci_create_host_bridge(parent, db, resources, sysdata);
> >>         if (!host)
> >>                 return NULL;
> >>  
> >> -       return __pci_scan_root_bus(host, ops, sysdata);
> >> +       return __pci_scan_root_bus(host, ops);
> >>  }
> >>  EXPORT_SYMBOL(pci_scan_root_bus);
> >>
> > 
> > How about keeping the sysdata out of the pci_create_host_bridge interface, and
> > refactoring it so that the call sequence becomes
> > 
> >       host = pci_create_host_bridge(parent, db, resources);
> >       host->sysdata = sysdata;
> >       __pci_scan_root_bus(host, ops);
> > 
> > This way, we can make sysdata completely option. I assume that more of the
> > fields we have in sysdata today can get moved into pci_host_bridge
> > over time, so a host bridge driver can just assign those members individually
> > between pci_create_host_bridge and __pci_scan_root_bus.
> 
> I put the sysdata in pci_host_bridge, because some platforms x86/ia64
> need to call pcibios_root_bridge_prepare() before pci_host_bridge registration
> in pci_create_host_bridge(), and pcibios_root_bridge_prepare() need the companion
> acpi device pointer which is stored in sysdata.
> 
> I like you idea, but I haven't find a better way yet.

Ok, fair enough. We can always try to find ways for getting rid of
pcibios_root_bridge_prepare() later, though I suspect as soon as we
have the callback, it will get used for other things as well ;-)

	Arnd
