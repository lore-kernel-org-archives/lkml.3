Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3F1UjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:39:25 -0400
Received: from mout2.freenet.de ([195.4.92.92]:47047 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab3F1UjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:39:24 -0400
Date: Fri, 28 Jun 2013 22:37:01 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
Message-ID: <20130628223701.78d17df2@dualc.maya.org>
In-Reply-To: <1372441744.30572.765.camel@ul30vt.home>
References: <lhtAZ-q1-5@gated-at.bofh.it> <lhtB1-q1-53@gated-at.bofh.it>  <20130628181136.52d00e9c@dualc.maya.org> <1372441744.30572.765.camel@ul30vt.home>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson wrote:
> On Fri, 2013-06-28 at 18:11 +0200, Andreas Hartmann wrote:
>> Hello Joerg, hello Alex,
>>
>> the subsequent patch and the patch "iommu/amd: Re-enable IOMMU event log
>> interrupt after handling." 925fe08bce38d1ff052fe2209b9e2b8d5fbb7f98
>> spread /var/log/messages with the following line (> 700 lines/second)
>> right after loading vfio:
>>
>> AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.0 domain=0x0000 address=0x000000fdf9103300 flags=0x0600]
> 
> That's interesting, I PXE boot my system from one NIC then use a
> different NIC for the iSCSI root.  The PXE boot NIC now screams like
> this, _until_ I attach it to vfio, then it quiets down.

Hmm, I just remembered an active workaround I implemented to "resolve"
an error like this when starting my VM to passthrough my intel pci
ethernet device since I applied a new kvm version:


qemu-kvm: -device vfio-pci,host=06:06.0: vfio: failed to set iommu for
container: Device or resource busy

qemu-kvm: -device vfio-pci,host=06:06.0: vfio: failed to setup container
for group 12

qemu-kvm: -device vfio-pci,host=06:06.0: vfio: failed to get group 12

qemu-kvm: -device vfio-pci,host=06:06.0: Device 'vfio-pci' could not be
initialized


The workaround was to bind the individual multifunction devices during
boot one time to vfio and release them after 2 seconds again and rebind
them to the original drivers as they where bound before (if it was bound
to any).

I did this with a script beginning like this:

#!/bin/sh
modprobe vfio-pci

echo "1002 4385" > /sys/bus/pci/drivers/vfio-pci/new_id
echo 0000:00:14.0 > /sys/bus/pci/devices/0000:00:14.0/driver/unbind
echo 0000:00:14.0 > /sys/bus/pci/drivers/vfio-pci/bind
...

sleep 2

echo 0000:00:14.0 > /sys/bus/pci/drivers/vfio-pci/unbind
echo "1002 4385" > /sys/bus/pci/drivers/vfio-pci/remove_id
...

The logs in messages:

Jun 28 15:54:12 . kernel: [   48.860147] VFIO - User Level meta-driver version: 0.3
Jun 28 15:54:12 . kernel: [   48.875243] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.0 domain=0x0000 address=0x000000fdf9103300 flags=0x0600]
...

Therefore, the logoutput most probably started after device 14.0 was
bound to vfio. If it would have started after removing vfio, I would
have expected 2 seconds between the start messages of vfio and the first
occurrence of the IO_PAGE_FAULT.

Today, I'm using kvm 1.3.1 and it isn't necessary to use the complete
workaround anymore. It is enough to bind / unbind the pci bridge
as described above before starting the VM with the passed through pci
ethernet device.
Because I now don't touch the 14.0 device any more, the IO_PAGE_FAULT
messages disappeared completely.

@Joerg:
Anyway, I'm going to test your provided patch tomorrow!

BTW: what does it mean: IO_PAGE_FAULT - what do I have to expect if I
see this message?



Thanks,
regards,
Andreas
