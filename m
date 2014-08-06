Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaHFEF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:05:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40537 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730AbaHFEF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:05:27 -0400
X-Sasl-enc: zR/AdFVKYCH1jdRljlZxAmEuNzTADHKIfwUKWQ5IEqGk 1407297921
Date: Tue, 5 Aug 2014 21:04:50 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20140806040450.GA7859@kroah.com>
References: <20140724170755.035cea1c@canb.auug.org.au>
 <20140724074452.GB11963@kroah.com>
 <20140806113935.6728d15c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806113935.6728d15c@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 11:39:35AM +1000, Stephen Rothwell wrote:
> Hi,
> 
> On Thu, 24 Jul 2014 00:44:52 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, Jul 24, 2014 at 05:07:55PM +1000, Stephen Rothwell wrote:
> > > Hi Greg,
> > > 
> > > After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> > > failed like this:
> > > 
> > > drivers/phy/phy-spear1310-miphy.c: In function 'spear1310_miphy_probe':
> > > drivers/phy/phy-spear1310-miphy.c:232:14: warning: passing argument 2 of 'devm_phy_create' from incompatible pointer type
> > >   priv->phy = devm_phy_create(dev, &spear1310_miphy_ops, NULL);
> > >               ^
> > > In file included from drivers/phy/phy-spear1310-miphy.c:21:0:
> > > include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' but argument is of type 'struct phy_ops *'
> > >  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> > >              ^
> > > drivers/phy/phy-spear1310-miphy.c:232:14: error: too few arguments to function 'devm_phy_create'
> > >   priv->phy = devm_phy_create(dev, &spear1310_miphy_ops, NULL);
> > >               ^
> > > In file included from drivers/phy/phy-spear1310-miphy.c:21:0:
> > > include/linux/phy/phy.h:164:13: note: declared here
> > >  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> > >              ^
> > > drivers/phy/phy-spear1340-miphy.c: In function 'spear1340_miphy_probe':
> > > drivers/phy/phy-spear1340-miphy.c:264:14: warning: passing argument 2 of 'devm_phy_create' from incompatible pointer type
> > >   priv->phy = devm_phy_create(dev, &spear1340_miphy_ops, NULL);
> > >               ^
> > > In file included from drivers/phy/phy-spear1340-miphy.c:21:0:
> > > include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' but argument is of type 'struct phy_ops *'
> > >  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> > >              ^
> > > drivers/phy/phy-spear1340-miphy.c:264:14: error: too few arguments to function 'devm_phy_create'
> > >   priv->phy = devm_phy_create(dev, &spear1340_miphy_ops, NULL);
> > >               ^
> > > In file included from drivers/phy/phy-spear1340-miphy.c:21:0:
> > > include/linux/phy/phy.h:164:13: note: declared here
> > >  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> > >              ^
> > > 
> > > Caused by commit f0ed817638b5 ("phy: core: Let node ptr of PHY point to
> > > PHY and not of PHY provider") interacting with commit 64562e99477f
> > > ("phy: Add drivers for PCIe and SATA phy on SPEAr13xx") from the
> > > arm-soc tree.
> > > 
> > > I fixed that up and then got:
> > > 
> > > drivers/pinctrl/pinctrl-tegra-xusb.c: In function 'tegra_xusb_padctl_probe':
> > > drivers/pinctrl/pinctrl-tegra-xusb.c:913:8: warning: passing argument 2 of 'devm_phy_create' from incompatible pointer type
> > >   phy = devm_phy_create(&pdev->dev, &pcie_phy_ops, NULL);
> > >         ^
> > > In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
> > > include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' but argument is of type 'const struct phy_ops *'
> > >  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> > >              ^
> > > drivers/pinctrl/pinctrl-tegra-xusb.c:913:8: error: too few arguments to function 'devm_phy_create'
> > >   phy = devm_phy_create(&pdev->dev, &pcie_phy_ops, NULL);
> > >         ^
> > > In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
> > > include/linux/phy/phy.h:164:13: note: declared here
> > >  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> > >              ^
> > > drivers/pinctrl/pinctrl-tegra-xusb.c:922:8: warning: passing argument 2 of 'devm_phy_create' from incompatible pointer type
> > >   phy = devm_phy_create(&pdev->dev, &sata_phy_ops, NULL);
> > >         ^
> > > In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
> > > include/linux/phy/phy.h:164:13: note: expected 'struct device_node *' but argument is of type 'const struct phy_ops *'
> > >  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> > >              ^
> > > drivers/pinctrl/pinctrl-tegra-xusb.c:922:8: error: too few arguments to function 'devm_phy_create'
> > >   phy = devm_phy_create(&pdev->dev, &sata_phy_ops, NULL);
> > >         ^
> > > In file included from drivers/pinctrl/pinctrl-tegra-xusb.c:18:0:
> > > include/linux/phy/phy.h:164:13: note: declared here
> > >  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
> > >              ^
> > > 
> > > From an interaction with commit dc0a39386687 ("pinctrl: Add NVIDIA
> > > Tegra XUSB pad controller support") from the arm-soc tree.
> > > 
> > > Final merge fix patch:
> > 
> > Ugh, what a mess, sorry about that.  I'll keep this around for if I end
> > up merging with Linus after these other trees get merged.
> 
> Since the usb tree has gone upstream, this merge fix patch is now
> needed when the arm-soc tree is merged.

I'll let the arm developers worry about this :)

thanks,

greg k-h
