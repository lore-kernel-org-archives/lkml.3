Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaA3MpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:45:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59829 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaA3MpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:45:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pratyush Anand <pratyush.anand@st.com>
Subject: Re: [PATCH V3 4/8] phy: Initialize phy core with subsys_initcall
Date: Thu, 30 Jan 2014 13:44:58 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "spear-devel" <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <cover.1391077731.git.mohit.kumar@st.com> <52EA3AE9.3030000@ti.com> <20140130115212.GA1171@pratyush-vbox>
In-Reply-To: <20140130115212.GA1171@pratyush-vbox>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401301344.59196.arnd@arndb.de>
X-Provags-ID: V02:K0:sAYBIHVtQLcIzFYAp7C0RoqTjHiJzmXh1vm/pKHOFlV
 hOcgQOvBXBKjB+OdbGfuufjojCbHYgbufTOtJ17h65qeBR0DCO
 VcJCRo5AXWIOYm4C/64cmFb5Dq2+7PFlL8CY684vBYqZpv0QU7
 prfjKK1HCT6JVIDxyCqvYfH+Wim3Qf8VUpVJPU/sQ14latkiFb
 h84tBLjNhz57X97OkIf1fyDmpDvGTLbjfYk0BLeGCKdDikY5SJ
 Cveu+CnSb23O3POqI40zZ/DL1fY7RsZKwNRWAujMjnBqHIh7Xu
 Rqk2omotrYja7H4ex60xPjQoRbx2wkzjB4/PJkXBGDqEd0KJ3U
 +I+otS+sqQZGTHuXz3+diS6qqmXs8BuSVQwiiKfew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 January 2014, Pratyush Anand wrote:
> On Thu, Jan 30, 2014 at 07:43:37PM +0800, Kishon Vijay Abraham I wrote:
> > Hi,
> > 
> > On Thursday 30 January 2014 04:18 PM, Mohit Kumar wrote:
> > > From: Pratyush Anand <pratyush.anand@st.com>
> > > 
> > > PCIe RC drivers are initialized with subsys_initcall. Few PCIe drivers
> > > like SPEAr13xx needs phy drivers to be initialized.
> > 
> > Instead change PCIe RC drivers to module init. Phy drivers should be loaded
> > very early otherwise. (Hint: drivers/Makefile).
> 
> I think PCIe RC driver can not be made module init. Bjorn can comment
> better.

I don't think there is any problem here: the PCI devices will only appear
after the PCIe root bus has been probed. All drivers using the regular
pci_driver framework should work fine even if they are loaded before the
device is found. There are a handful of drivers using 'pci_get_device'
rather than pci_register_driver, and those will break. As far as I can
tell, those drivers are all x86 specific, and you should not worry about
them.

Having the PHY driver get initialized after the PCI root driver should
also work, but it requires correct handling of -EPROBE_DEFER: if phy_get
returns this error, the PCI driver must silently return the same error
from its probe() function so it will get called again at a later time
(after some other devices have been probed successfully).

	Arnd
