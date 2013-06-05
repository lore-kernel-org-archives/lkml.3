Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3FEO6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:58:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17674 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3FEO6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:58:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 07:57:48 -0700
From: Jay Agarwal <jagarwal@nvidia.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "olof@lixom.net" <olof@lixom.net>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
Date: Wed, 5 Jun 2013 20:27:44 +0530
Subject: RE: [PATCH V3 2/4] ARM: tegra: pcie: Add tegra3 support
Thread-Topic: [PATCH V3 2/4] ARM: tegra: pcie: Add tegra3 support
Thread-Index: Ac5hWCY/2YYDO2K2RJy7xwoWdDrb0wApMUxg
Message-ID: <C79B248886DD134989C8FF6B096A91AB91B616BECE@BGMAIL01.nvidia.com>
References: <1370372252-4332-1-git-send-email-jagarwal@nvidia.com>
 <1370372252-4332-2-git-send-email-jagarwal@nvidia.com>
 <51AE3D3B.6080102@wwwdotorg.org>
In-Reply-To: <51AE3D3B.6080102@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git
> > a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> > b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> 
> > +- avdd-supply: Power supply for controller (1.05V)
> 
> > +  "cml": The Tegra clock of that name
> 
> Both those changes need to mention that those additions are only required
> for Tegra30, not Tegra20. In other words,
> 
> +- avdd-supply: Power supply for controller (1.05V) (not required for
> Tegra20)
> 
> +  "cml": The Tegra clock of that name (not required for Tegra20)
> 
> You probably also want to explicitly mention nvidia,tegra30-pcie as a legal
> compatible value.
> 
> > diff --git a/drivers/pci/host/pci-tegra.c
> > b/drivers/pci/host/pci-tegra.c
> 
> > +/* used to differentiate tegra chips code */ struct
> > +tegra_pcie_soc_data {
> > +	unsigned int num_max_ports;
> 
> nit: "num max" seems redundant. max_ports or num_ports would be better.
> 
> >  struct tegra_pcie_port {
> > @@ -384,7 +408,7 @@ static int tegra_pcie_read_conf(struct pci_bus *bus,
> unsigned int devfn,
> >  		struct tegra_pcie_port *port;
> >
> >  		list_for_each_entry(port, &pcie->ports, list) {
> > -			if (port->index + 1 == slot) {
> > +			if (port->index == slot) {
> 
> This and the equivalent change in tegra_pcie_write_conf() seem like a bug-
> fix unrelated to the addition of Tegra30 support. Hence, they should be a
> separate patch.
> 
> 
> > @@ -398,7 +422,6 @@ static int tegra_pcie_read_conf(struct pci_bus *bus,
> unsigned int devfn,
> >  			*value = 0xffffffff;
> >  			return PCIBIOS_DEVICE_NOT_FOUND;
> >  		}
> > -
> >  		addr += tegra_pcie_conf_offset(devfn, where);
> 
> Unnecessary white-space change.
> 
> > @@ -1549,10 +1660,9 @@ static int tegra_pcie_remove(struct
> platform_device *pdev)
> >  	struct tegra_pcie_bus *bus;
> >  	int err;
> >
> > -	list_for_each_entry(bus, &pcie->busses, list) {
> > +	list_for_each_entry(bus, &pcie->busses, list)
> >  		vunmap(bus->area->addr);
> > -		kfree(bus);
> > -	}
> > +	kfree(bus);
> 
> This doesn't look right. Can you please explain it further? This is looping
> over every bus in a dynamic list, so surely each entry needs to be freed? Did
> you do this to avoid a crash? If so, the issue is likely that the loop should use
> list_for_each_entry_safe() rather than list_for_each_entry().
Yes you are right, it is not required. I will revert it along with taking care of other comments.
