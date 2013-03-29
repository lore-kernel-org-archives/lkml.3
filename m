Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3C2T5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:57:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48432 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756769Ab3C2T47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:56:59 -0400
Date: Fri, 29 Mar 2013 15:56:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Geoff Levand <geoff@infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        USB list <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 4/7] USB: EHCI: export ehci_shutdown
In-Reply-To: <1364507705-22012-5-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1303291541460.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Arnd Bergmann wrote:

> The ehci_shutdown function is used by the platform specific ehci backends
> for at91, tegra and ps3. In order to turn any of these into separate
> modules, we need to make this function globally visible and export it.

Actually, I think this is not necessary.  Instead those three glue
files ought to be changed.  They should not need to call
ehci_shutdown() directly.

The references to ehci_shutdown() in ehci-atmel.c and ehci-ps3.c seem
totally unnecesary.  That routine does a hard shutdown -- but the calls
are immediately followed by usb_remove_hcd(), which calls ehci_stop(),
which does an orderly shutdown followed by a reset.  While it certainly
would be good to check with the authors of these drivers, it would be
surprising if removing those calls led to any trouble.

The reference in ehci-tegra.c is there only so that
tegra_ehci_shutdown() can call tegra_ehci_power_up() before doing its
real work.  Instead, tegra_ehci_power_up() should be called by 
tegra_ehci_hcd_shutdown().  Then there would be no need to have the 
tegra_ehci_shutdown() routine at all.

Alan Stern

