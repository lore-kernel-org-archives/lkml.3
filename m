Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbbAPJUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:20:08 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:57645 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbbAPJT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:19:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-alpha@vger.kernel.org,
        linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH 10/28] PCI: Save sysdata in pci_host_bridge drvdata
Date: Fri, 16 Jan 2015 10:18:59 +0100
Message-ID: <18973877.BYCS6vtzoq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421372666-12288-11-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-11-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:WX6Yn1iHM3R/b6JUpLxw7Tt0J8wzpOvL7qMQKilG9F/D5NudRMA
 TqXNDFiQDXInR4/eT1as1PMF96bUa7Wxb2t9m9iSmfalAHwb7fZWM8TB4BbmhtQWzhx8plU
 PLl3qiDl65CdVvwRZOXajIyOSfXOfCJLTbPBWc9hTTjNe4r2AFELce8s6CVmqqvi0Um5IY3
 IFNpr8kfaDcoyZNfCSugg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 09:44:08 Yijing Wang wrote:
> @@ -2066,11 +2064,11 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, u32 db,
>  {
>         struct pci_host_bridge *host;
>  
> -       host = pci_create_host_bridge(parent, db, resources);
> +       host = pci_create_host_bridge(parent, db, resources, sysdata);
>         if (!host)
>                 return NULL;
>  
> -       return __pci_scan_root_bus(host, ops, sysdata);
> +       return __pci_scan_root_bus(host, ops);
>  }
>  EXPORT_SYMBOL(pci_scan_root_bus);
> 

How about keeping the sysdata out of the pci_create_host_bridge interface, and
refactoring it so that the call sequence becomes

	host = pci_create_host_bridge(parent, db, resources);
	host->sysdata = sysdata;
	__pci_scan_root_bus(host, ops);

This way, we can make sysdata completely option. I assume that more of the
fields we have in sysdata today can get moved into pci_host_bridge
over time, so a host bridge driver can just assign those members individually
between pci_create_host_bridge and __pci_scan_root_bus.

	Arnd
