Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3HBX4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:56:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:36870 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab3HBX4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:56:43 -0400
Message-ID: <1375487788.15999.75.camel@pasglop>
Subject: Re: RFC: vfio-pci API for PCI bus/slot (hot) resets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Sat, 03 Aug 2013 09:56:28 +1000
In-Reply-To: <1375486647.31262.351.camel@ul30vt.home>
References: <1375395497.31262.271.camel@ul30vt.home>
	 <1375420202.3743.97.camel@pasglop> <1375461387.31262.314.camel@ul30vt.home>
	 <1375478934.15999.33.camel@pasglop>
	 <CAErSpo42yK=K55J30V3xd_Ki6KEUOU6q7sUpNrAYe517=CdiDA@mail.gmail.com>
	 <1375485348.15999.66.camel@pasglop>
	 <1375486647.31262.351.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 17:37 -0600, Alex Williamson wrote:

> > Yes.
> > 
> > We have that similar issue with error handling, when the driver doesn't
> > have the right hooks, we simulate an unplug, reset, then replug.
> > 
> > Maybe we could provide generic helpers to do that...
> 
> Devices going away and coming back is pretty difficult for vfio to
> handle.  Perhaps helpers to rescan a device in-place would be easier.

Well, in the error handling case (and *maybe* in the "FW update" case)
we need to unbind and rebind the driver as well. The whole point is that
we have to do that because the driver doesn't have the right hooks.

In the VFIO case, we will have to implement something here so that the
VFIO driver stub doesn't get handled that treatment :-) We'll probably
need some arch specific stuff in vfio_pci unfortunately, so that the
errors get forwarded to the guest via our EEH interfaces, and let the
guest handle it's error handling.

Of course that leaves an interesting problem as to what state the device
is in when it comes back to the host ...

This is made a LOT more complicated in the VFIO model than it is in the
"pHyp" model (our proprietary hypervisor).

Under pHyp, the PE doesn't have a concept of being used outside of a
guest, and it always reset before being assigned/unassigned. The guest
can mess around all it wants (bus numbers, BARs, etc...) it can only
hurt itself. The hypervisor doesn't keep track of any of that.

> On the QEMU side we'd need to rescan the device after each reset, which
> would be rather tedious for the typical case where it doesn't change.

This is a direct consequence of your model :-) It makes things more
complex for us as well, but we have to bite that bullet now. Maybe we
can consider an alternate/simpler model in the future, more akin to what
pHyp does, where we "unplug" the device from the host when assigning it
to a guest (and the whole hierarchy below it if it's a bridge) and let
the guest do what it wants with it. 

Doing so means we no longer have to emulate/filter config space
(provided your HW handles MSI virtualization properly), care about bus
numbers, BARs, etc... nor do we need to keep track of a lot of this in
qemu. All we need is reset the whole & lot and re-probe the bus leg when
returning the devices to the host.
 
Cheers,
Ben.

> Thanks,
> 
> Alex
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


