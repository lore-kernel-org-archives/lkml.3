Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaIXHog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:44:36 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:60139 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaIXHoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:44:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Chen <peter.chen@freescale.com>
Cc: balbi@ti.com, Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, sebastian.hesselbarth@gmail.com,
        p.zabel@pengutronix.de, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Wed, 24 Sep 2014 09:44:19 +0200
Message-ID: <2990737.4KzKXPZhaB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140924022736.GA5307@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <62705234.gKJDtUQLyT@wuerfel> <20140924022736.GA5307@peterchendt>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FUODaKiPeH0eL3DnNAkUKL9sjFx9IbA9jf/dcOJSetu
 WeaJVA3qFgLDg2PEm/IXHbOxH+23DvuBJahl8JrNcdtuxT4Q1S
 8GwaLCTg4N73gtL/fJLkPqohpGULS3whFy3KefuUP/J49YkVWg
 EJZB4Ed10Qp2XvnuDmYu/YM29u+UnSOb+Q0tlXFsY5dxzOzZs+
 /EzU0vxtfFFI33+i2yFEClDnHBB0VW01R5DlvhJHliPO9cSOkg
 V3SwfUZhqB5kXGEMCs8NaGCRD2ac798XScGRoUXhiZTe1477tk
 LsfuwH9RLY1M7aTSkwMH/3EmWK8lDIioLQMFJDjgYLz8Htv129
 O/4cxxyIE6kQNxcFmz88=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 10:27:52 Peter Chen wrote:
> 
> Antoine is adding a generic chipdea glue layer driver, which like ehci generic
> platform driver: drivers/usb/host/ehci-platform.c, since other architectures
> like MIPS (Someone submitted mips chipidea driver before) may not have device
> tree support, I think non-dt support is also needed.

Right.

> It is a good suggestion for adding DT support for core driver, Since we did
> not do it at the first, it is a little embarrass at current situation.
> 
> - For the new chipidea glue drivers, it is ok we can have a child node
> for core device at glue device node, and some common entries can be there
> like: phy, vbus, dr_mode, etc. We need to add support for getting
> these common things for both through device tree and platform data
> (parent is DT support and parent is non-DT support) at core driver.

I don't really want to see the child devices show up in DT, as this is
really an implementation detail of the way that the driver currently works,
and IMHO we should change that.

I know that Felipe disagrees with me on this, but almost every other
driver that has soc-specific specializations does not use parent/child
nodes, neither in DT nor in Linux. Instead you have a single device
node that gets distinguished by "compatible" string.

> - For the existing glue drivers, since we can't change existed dts, we can
> only do it from future SoC support. Then, in this kinds of glue drivers,
> we need to support for both create core driver by node and by current
> calling platform_device_add way.

We should be able to easily change the ci_hdrc_add_device call into
a different exported function that calls a version of the probe()
code directly, as we do in all sorts of other drivers (ehci, ohci,
dwc2, ..., but not dwc3 and musb as they are maintained by Felipe).

We can also gradually move in some of the other glue drivers into
the main driver if the differences are small enough.

Moving the PCI driver over to this model requires a little more
work but is absolutely doable (again, see ehci, ahci, sdhci examples)
by moving the platform_device handling out of core.c and changing
it just operate on the plain 'struct device', with an exported
probe function that gets called on either the platform device
or the pci device.

	Arnd
