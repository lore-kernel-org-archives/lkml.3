Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3KEX0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:26:44 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44243 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab3KEX0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:26:42 -0500
Date: Tue, 5 Nov 2013 16:26:38 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Workaround missing pci_set_master in pci drivers
Message-ID: <20131105232638.GA3359@google.com>
References: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
 <1380399187-4962-1-git-send-email-yinghai@kernel.org>
 <20131003220628.GA14835@google.com>
 <CAE9FiQVYZ2pRTs5Xsc2MKgUiWfLbSExLA-vF0HK2iy=tVw2OHA@mail.gmail.com>
 <CAErSpo79xHn7RNNrbQBa49M464xryqjwi_iTPjTCnhEphkCvEg@mail.gmail.com>
 <1383569048.9623.16.camel@x220.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383569048.9623.16.camel@x220.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 01:44:08PM +0100, Paul Bolle wrote:
> On Fri, 2013-10-04 at 09:55 -0600, Bjorn Helgaas wrote:
> > On Thu, Oct 3, 2013 at 5:35 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > > On Thu, Oct 3, 2013 at 3:06 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > >> On Sat, Sep 28, 2013 at 01:13:07PM -0700, Yinghai Lu wrote:
> > >>> @@ -1156,8 +1156,14 @@ static void pci_enable_bridge(struct pci
> > >>>
> > >>>       pci_enable_bridge(dev->bus->self);
> > >>>
> > >>> -     if (pci_is_enabled(dev))
> > >>> +     if (pci_is_enabled(dev)) {
> > >>> +             if (!dev->is_busmaster) {
> > >>> +                     dev_warn(&dev->dev, "driver skip pci_set_master, fix it!\n");
> > >>
> > >> I know this is already in Linus' tree, but if we're going to enable
> > >> bus mastering here, what's the point of the warning?  If somebody
> > >> fixes the driver by adding a pci_set_master() call there, does that
> > >> improve something?
> > >
> > > Help us to catch other offender and fix them.
> > 
> > What is improved by doing it in the driver instead of here?
> 
> After booting v3.12 for the first time on a laptop I noticed two new
> warnings: 
>     <4>[    4.427959] pcieport 0000:00:1c.4: driver skip pci_set_master, fix it!
>     <4>[    4.448630] pcieport 0000:00:1c.1: driver skip pci_set_master, fix it!
> 
> These warnings aren't entirely clear, but luckily they are easily
> greppable. It turns out they can be traced back to this patch.
> 
> So some further grepping, looking at the code, etc. suggests these
> warnings could be silenced by calling pci_set_master() before calling
> pci_enable_device(). Ie, reverse the current order of those calls in
> drivers/pci/pcie/portdrv_core.c:pcie_port_device_register(). Is that
> correct? But what should then be done if pci_enable_device() fails?
> 
> And Bjorn's question - what's the point of this warning if
> pci_set_master() will be called anyway - also came up when I looked at
> that code segment for the first time. But I'm not familiar with the PCI
> code.

Unless somebody can point out a problem with doing the pci_set_master()
inside pci_enable_bridges(), I plan to merge the following patch to
remove the warning.


PCI: Drop warning about drivers that don't use pci_set_master()

From: Bjorn Helgaas <bhelgaas@google.com>

f41f064cf4 ("PCI: Workaround missing pci_set_master in pci drivers") made
pci_enable_bridge() turn on bus mastering if the driver hadn't done so
already.  It also added a warning in this case.  But there's no reason to
warn about it unless it's actually a problem to enable bus mastering here.

This patch drops the warning because I'm not aware of any such problem.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/pci/pci.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7a92d81..ac40f90 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1156,10 +1156,8 @@ static void pci_enable_bridge(struct pci_dev *dev)
 	pci_enable_bridge(dev->bus->self);
 
 	if (pci_is_enabled(dev)) {
-		if (!dev->is_busmaster) {
-			dev_warn(&dev->dev, "driver skip pci_set_master, fix it!\n");
+		if (!dev->is_busmaster)
 			pci_set_master(dev);
-		}
 		return;
 	}
 
