Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3FLNpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:45:21 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43740 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3FLNpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:45:18 -0400
Date: Wed, 12 Jun 2013 09:45:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: George Dunlap <george.dunlap@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/pci: Deal with toolstack missing an
 'XenbusStateClosing'.
Message-ID: <20130612134504.GG2918@phenom.dumpdata.com>
References: <20130610202456.GA17822@phenom.dumpdata.com>
 <1370898399-20968-1-git-send-email-konrad.wilk@oracle.com>
 <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com>
 <51B743EA.5020800@eu.citrix.com>
 <51B74B77.1000806@oracle.com>
 <51B74DA9.7060509@eu.citrix.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <51B74DA9.7060509@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2013 at 05:17:45PM +0100, George Dunlap wrote:
> On 06/11/2013 05:08 PM, konrad wilk wrote:
> >
> >On 6/11/2013 11:36 AM, George Dunlap wrote:
> >>On 06/10/2013 10:06 PM, Konrad Rzeszutek Wilk wrote:
> >>>There are two tool-stack that can instruct the Xen PCI frontend
> >>>and backend to change states: 'xm' (Python code with a daemon),
> >>>and 'xl' (C library - does not keep state changes).
> >>>
> >>>With the 'xm', the path to disconnect a PCI device (xm pci-detach
> >>><guest> <BDF>)is:
> >>>
> >>>4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)->
> >>>4(Connected)->5(Closing*).
> >>>
> >>>The * is for states that the tool-stack sets. For 'xl', it is similar:
> >>>
> >>>4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)
> >>>
> >>>Both of them also tear down the XenBus structure, so the backend
> >>>state ends up going in the 3(Initialised) and calls
> >>>pcifront_xenbus_remove.
> >>
> >>So I looked a little bit into this; there are actually two different
> >>states that happen as part of this handshake.  In order to disonnect a
> >>*device*, xl signals using the *bus* state, like this:
> >>* Wait for the *bus* to be in state 4(Connected)
> >>* Set the *device* state to 5(Closing)
> >>* Set the *bus* state to 7(Reconfiguring)
> >>* Wait for the *bus* state to return to 4(Connected)
> >>
> >>So are all of these states you see the *bus* state?  And why would you
> >>disconnect the whole pci bus if you're only removing one device?
> >
> >Correct. The stats I enumerated are *bus* states. Not per-device states.
> >I presume (and I hadn't checked xm) that Xend has some logic to only
> >disconnect the bus if all of the PCI devices have been disconnected. In
> >'xl' it does not do that.
> >
> >The testing I did was just with one PCI device.
> 
> Ah, OK -- I see now.  The problem is that the code in the Linux side
> didn't know about the whole "4->7->8->4" thing to unplug a device.
> In all likelihood, if you had used xm with two devices (so that the
> bus didn't get disconnected), then you would have run across the
> same error.
> 
> So at least part of the problem *is* a bug in Linux.

Good! Bjorn, would you be OK Ack-ing the patch I sent (attached here
for reference) or putting it in your queue for Linus?

My plan would be to send it to Linus in the 3.11 merge window.

--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-xen-pci-Deal-with-toolstack-missing-an-XenbusStateCl.patch"

>From efdfbd66b4f0ff6f005f9d30891adb8bd3f3eefa Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 10 Jun 2013 16:48:09 -0400
Subject: [PATCH] xen/pci: Deal with toolstack missing an 'XenbusStateClosing'.

There are two tool-stack that can instruct the Xen PCI frontend
and backend to change states: 'xm' (Python code with a daemon),
and 'xl' (C library - does not keep state changes).

With the 'xm', the path to disconnect a PCI device (xm pci-detach
<guest> <BDF>)is:

4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)->5(Closing*).

The * is for states that the tool-stack sets. For 'xl', it is similar:

4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)

Both of them also tear down the XenBus structure, so the backend
state ends up going in the 3(Initialised) and calls pcifront_xenbus_remove.

When a PCI device is plugged in (xm pci-attach <guest> <BDF>)
both of them follow the same pattern:
2(InitWait*), 3(Initialized*), 4(Connected*)->4(Connected).

[xen-pcifront ignores the 2,3 state changes and only acts when
4 (Connected) has been reached]

The problem is that git commit 3d925320e9e2de162bd138bf97816bda8c3f71be
("xen/pcifront: Use Xen-SWIOTLB when initting if required") introduced
a mechanism to initialize the SWIOTLB when the Xen PCI front moves to
Connected state. It also had some aggressive seatbelt code check that
would warn the user if one tried to change to Connected state without
hitting first the Closing state:

 pcifront pci-0: PCI frontend already installed!

However, that code can be relaxed and we can continue on working
even if the frontend is instructed to be the 'Connected' state with
no devices and then gets tickled to be in 'Connected' state again.

In other words, this 4(Connected)->5(Closing)->4(Connected) state
was expected, while 4(Connected)->.... anything but 5(Closing)->4(Connected)
was not. This patch removes that aggressive check and allows
Xen pcifront to work with the 'xl' toolstack.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/xen-pcifront.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index ac99515..cc46e253 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -675,10 +675,9 @@ static int pcifront_connect_and_init_dma(struct pcifront_device *pdev)
 	if (!pcifront_dev) {
 		dev_info(&pdev->xdev->dev, "Installing PCI frontend\n");
 		pcifront_dev = pdev;
-	} else {
-		dev_err(&pdev->xdev->dev, "PCI frontend already installed!\n");
+	} else
 		err = -EEXIST;
-	}
+
 	spin_unlock(&pcifront_dev_lock);
 
 	if (!err && !swiotlb_nr_tbl()) {
@@ -846,7 +845,7 @@ static int pcifront_try_connect(struct pcifront_device *pdev)
 		goto out;
 
 	err = pcifront_connect_and_init_dma(pdev);
-	if (err) {
+	if (err && err != -EEXIST) {
 		xenbus_dev_fatal(pdev->xdev, err,
 				 "Error setting up PCI Frontend");
 		goto out;
-- 
1.8.1.4


--jI8keyz6grp/JLjh--
