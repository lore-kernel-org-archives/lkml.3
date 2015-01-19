Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbbASIpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:45:41 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:56808 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbASIph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:45:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Yijing Wang <wangyijing@huawei.com>, Liviu Dudau <liviu@dudau.co.uk>,
        Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-alpha@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-ia64@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH 18/28] PCI/sparc: Use pci_scan_root_bridge() for simplicity
Date: Mon, 19 Jan 2015 09:44:31 +0100
Message-ID: <7748275.Tf0dzsPZdA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54BC772E.6020103@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <2658988.B0VmbMPdJ9@wuerfel> <54BC772E.6020103@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:6u/nr1M5yk2zGXU6MeCD4GDrDSVqM5xSxV0mThOtpX++XH/yWTX
 W/YfDW6M67lUAX6fnPpo991fsHDukKs9dKhAdsIi6qoAT99WSsnCPnAzWFfyWCs6s4q6EuF
 rRNYGQ3gq2CQ8JX3iwOuiR8gNjr25WhT5YXHlFOYX8mXJJxdkrCd1pjeN0pbkklichILpBS
 oIgjwsaDxfYpLPcz+KhYQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2015 11:17:02 Yijing Wang wrote:
> On 2015/1/16 18:01, Arnd Bergmann wrote:
> > On Friday 16 January 2015 09:44:16 Yijing Wang wrote:
> >> +static void pci_host_bridge_probe_mode(
> >> +               struct pci_host_bridge *host)
> >> +{
> >> +       host->of_scan = true;
> >> +}
> >>
> > 
> > I probably missed something here, but where does host->of_scan
> > get used?
> > 
> 
> It is used in __pci_scan_root_bus() to detect whether of scan bus is needed in patch 11.

Ok, I see it now.

> @@ -2051,10 +2053,17 @@ static struct pci_bus *__pci_scan_root_bus(
>  		pci_bus_insert_busn_res(b, host->busnum, 255);
>  	}
> 
> -	max = pci_scan_child_bus(b);
> +	if (host->ops && host->ops->phb_probe_mode)
> +		host->ops->phb_probe_mode(host);
> 
> -	if (!found)
> -		pci_bus_update_busn_res_end(b, max);
> +	if (host->of_scan) {
> +		if (host->ops &&host->ops->phb_of_scan_bus)
> +			host->ops->phb_of_scan_bus(host);
> +	} else {
> +		max = pci_scan_child_bus(b);
> +		if (!found)
> +			pci_bus_update_busn_res_end(b, max);
> +	}
> 

I think we can simplify this based on the knowledge that this code
will remain powerpc specific. How about removing the phb_probe_mode()
callback and replacing it with just a phb_scan_bus() callback that
will always get set on sparc, and do this on powerpc:

+static void pci_host_bridge_of_scan_bus(struct pci_host_bridge *host)
+{
+       int mode = PCI_PROBE_NORMAL;
+       struct pci_bus *bus = host->bus;
+       struct pci_controller *hose = dev_get_drvdata(&host->dev);
+
+       /* Get probe mode and perform scan */
+       if (hose->dn && ppc_md.pci_probe_mode)
+               mode = ppc_md.pci_probe_mode(bus);
+
+       pr_debug("    probe mode: %d\n", mode);
+       if (mode == PCI_PROBE_DEVTREE) {
+               of_scan_bus(host->dn, bus);
+		return max; // XXX need to get this from somewhere
+	}
+	return pci_scan_child_bus(b);
+}

Would that work?

	Arnd
