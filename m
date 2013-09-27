Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3I0I25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:28:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:34106 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab3I0I2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:28:55 -0400
Message-ID: <1380270519.27811.10.camel@pasglop>
Subject: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 27 Sep 2013 18:28:39 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Yinghai !

Please consider reverting:

928bea964827d7824b548c1f8e06eccbbc4d0d7d
PCI: Delay enabling bridges until they're needed

(I'd suggest to revert now and maybe merge a better patch later)

This breaks PCI on the PowerPC "powernv" platform (which is booted via
kexec) and probably x86 as well under similar circumstances. It will
basically break PCIe if the bus master bit of the bridge isn't set at
boot (by the firmware for example, or because kexec'ing cleared it).

The reason is that the PCIe port driver will call pci_enable_device() on
the bridge (on everything under the sun actually), which will marked the
device enabled (but will not do a set_master).

Because of that, pci_enable_bridge() later on (called as a result of the
child device driver doing pci_enable_device) will see the bridge as
already enabled and will not call pci_set_master() on it.

Now, this could probably be fixed by simply doing pci_set_master() in
the PCIe port driver, but I find the whole logic very fragile (anything
that "enables" the bridge without setting master or for some reason
clears master will forever fail to re-enable it).

Maybe a better option is to unconditionally do pci_set_mater() in
pci_enable_bridge(), ie, move the call to before the enabled test.

However I am not too happy with that either. My experience with bridges
is that if bus master isn't set, they will also fail to report AER
errors and other similar upstream transactions. We might want to get
these reported properly even if no downstream device got successfully
enabled.

So I think the premises of the patches are flawed, at least on PCI
express, and we should stick to always enabling bridges (at least the
bus master bit on them).

Cheers,
Ben.


