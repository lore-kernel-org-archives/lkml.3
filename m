Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbaAaDsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 22:48:19 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:48118 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753609AbaAaDsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 22:48:17 -0500
Date: Fri, 31 Jan 2014 09:18:03 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH V3 4/8] phy: Initialize phy core with subsys_initcall
Message-ID: <20140131034803.GA2618@pratyush-vbox>
References: <cover.1391077731.git.mohit.kumar@st.com>
 <52EA3AE9.3030000@ti.com>
 <20140130115212.GA1171@pratyush-vbox>
 <201401301344.59196.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201401301344.59196.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 08:44:58PM +0800, Arnd Bergmann wrote:
> On Thursday 30 January 2014, Pratyush Anand wrote:
> > On Thu, Jan 30, 2014 at 07:43:37PM +0800, Kishon Vijay Abraham I wrote:
> > > Hi,
> > > 
> > > On Thursday 30 January 2014 04:18 PM, Mohit Kumar wrote:
> > > > From: Pratyush Anand <pratyush.anand@st.com>
> > > > 
> > > > PCIe RC drivers are initialized with subsys_initcall. Few PCIe drivers
> > > > like SPEAr13xx needs phy drivers to be initialized.
> > > 
> > > Instead change PCIe RC drivers to module init. Phy drivers should be loaded
> > > very early otherwise. (Hint: drivers/Makefile).
> > 
> > I think PCIe RC driver can not be made module init. Bjorn can comment
> > better.
> 
> I don't think there is any problem here: the PCI devices will only appear
> after the PCIe root bus has been probed. All drivers using the regular
> pci_driver framework should work fine even if they are loaded before the
> device is found. There are a handful of drivers using 'pci_get_device'
> rather than pci_register_driver, and those will break. As far as I can
> tell, those drivers are all x86 specific, and you should not worry about
> them.
> 
> Having the PHY driver get initialized after the PCI root driver should
> also work, but it requires correct handling of -EPROBE_DEFER: if phy_get

I had issue with phy-core driver getting initialized after pcie rc
driver. I found a kernel crash, as devm_phy_get was called before
phy_class was created. I think this too need to be fixed, we should
not see a crash.

Anyway, I will keep spear phy and rc driver both with module_init and
-EPROBE_DEFER implementation.

Regards
Pratyush
> returns this error, the PCI driver must silently return the same error
> from its probe() function so it will get called again at a later time
> (after some other devices have been probed successfully).
> 
> 	Arnd
