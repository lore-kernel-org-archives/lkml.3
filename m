Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaETRCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:02:37 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:51545 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaETRCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:02:34 -0400
Date: Tue, 20 May 2014 11:02:21 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on
 designware core driver
Message-ID: <20140520170221.GA5130@obsidianresearch.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <6048322.x3M3sdDEWO@wuerfel>
 <5374FD24.8000806@ti.com>
 <22200719.Jb5jnJylJH@wuerfel>
 <20140515183919.GC11650@obsidianresearch.com>
 <53751DDF.40304@ti.com>
 <20140515205210.GB14722@obsidianresearch.com>
 <3E54258959B69E4282D79E01AB1F32B704742133@DFLE11.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B704742133@DFLE11.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 08:29:56PM +0000, Karicheri, Muralidharan wrote:

> But pcie_bus_configure_settings just make sure the mrrs for a device
> is not greater than the max payload size. 

Not quite, it first scans the network checking the Maximum Payload Size
Supported (MPSS) for each device, and chooses the highest supported by
all as the MPS for all.

PCI-E requires that an end point support all packets up to the MPS, so
if your bridge can't generate a 512 byte read response packet, then it
must not advertise a MPSS greater than 256 bytes.

Setting your MPSS to 128, 256, then using the
pcie_bus_configure_settings to run the standard algorithm should
properly limit the readrq to 256 and be able to properly support all
the fun edge cases like hot plug.

If the config space in your root port bridge is correct and already
declares a MPSS of 256 then you have nothing else to do but make sure
pcie_bus_configure_settings gets calls.

If it is broken and claims a higher MPSS than it can support then you
need to use a quirk only for the root port bridge or edit the config
reply in the driver only to fix the MPSS.

Jason
