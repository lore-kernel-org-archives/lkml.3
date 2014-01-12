Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaALVTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 16:19:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaALVTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 16:19:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ravi Patel <rapatel@apm.com>
Subject: Re: [PATCH V2 0/4] misc: xgene: Add support for APM X-Gene SoC Queue Manager/Traffic Manager
Date: Sun, 12 Jan 2014 22:19:11 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, Loc Ho <lho@apm.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
References: <1387594651-25771-1-git-send-email-rapatel@apm.com> <CAN1v_PsaAeDiLaiP7FfTHFbNRG=UHuom6-2L6NMwzyOOyB+5cA@mail.gmail.com> <CAN1v_PuySRzi6r9aT_SJrQRMBh9gj-5yXOOY1QpyZ6V4wXyZCA@mail.gmail.com>
In-Reply-To: <CAN1v_PuySRzi6r9aT_SJrQRMBh9gj-5yXOOY1QpyZ6V4wXyZCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401122219.11593.arnd@arndb.de>
X-Provags-ID: V02:K0:fYUu9/3kShSbm0gO8TSK6Z9HihCaZ0jkbZ1KrNxC6l/
 odeG0fOrjs5W7qps3QWCDi45uu8ogb6hKfGM+edTZYYGdwtYqG
 uvcgpZi00pN6z/h0fhdonHquOE81Z1WgduxdRBiHHrHjaZFDx3
 Y+8I96fxox6UoBUmbulNmf7ip/A1AY5+whPDkVjBBPdIHxe+NN
 G/kovi3a7wLn5/QUVGcas1rS8hwgEHkVDVKXtLDGCK09IhUA+a
 4GR5Zoi7qTLC2IqG4zo26F+4UgNTXVs+yR5fRh3UKrDyfcXbps
 rA+Nnqqg5rh7we8s1YGqjXyabP0fVPtWND0CB3y2hgVxzX2TdG
 +3rH4QH+AM1GVu5Z19g8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 January 2014, Ravi Patel wrote:

> Do you want any further clarification or document related to QMTM.
> We want to make sure everyone is on same page, understand and
> conclude upon that QMTM is a device and and not a bus or a dma
> engine.

I have a much better understanding now, but there are still a few open
questions from my side. Let me try to explain in my own words what I
think is the relevant information (part of this is still guessing).
It took me a while to figure out what it does from your description,
and then some more time to see what it's actually good for (as
opposed to adding complexity).

Please confirm or correct the individual statements in this
description:

The QMTM serves as a relay for short (a few bytes) messages between
the OS software and various slave hardware blocks on the SoC.
The messages are typically but not always DMA descriptors used by the
slave device used for starting bus master transactions by the slave,
or for notifying sofware about the competion of a DMA transaction.

The message format is specific to the slave device and the QMTM
only understands the common header of the message.

OS software sees the messages in cache-coherent memory and does
not require any cache flushes or MMIO access for inbound messages
and only a single posted MMIO write for outbound messages.

The queues are likely designed to be per-thread and don't require
software-side locking.

For outbound messages, the QMTM is the bus master of a device-to-device
DMA transaction that gets started once a message is queued and the
device has signaled that it is ready for receiving it. The QMTM needs
to know the bus address of the device as well as a slave ID for
the signal pin.
For inbound messages, the QMTM slave initiates a busmaster transaction
and needs to know the bus address of its QMTM port, while the QMTM
needs to know only the slave ID that is associated with the queue.

In addition to those hardware properties, the QMTM driver needs to
set up a memory buffer for the message queue as seen by the CPU,
and needs tell the QMTM the location as well as some other
properties such as the message length.

For inbound messages, the QMTM serves a similar purpose as an MSI
controller, ensuring that inbound DMA data has arrived in RAM
before an interrupt is delivered to the CPU and thereby avoiding
the need for an expensive MMIO read to serialize the DMA.

The resources managed by the QMTM are both SoC-global (e.g. bus
bandwidth) and slave specific (e.g. ethernet bandwith or buffer space).
Global resource management is performed to prevent one slave
device from monopolizing the system or preventing other slaves
from making forward progress.
Examples for local resource management (I had to think about this 
a long time, but probably some of these are wrong) would be
* balancing between multiple non-busmaster devices connected to
  a dma-engine
* distributing incoming ethernet data to the available CPUs based on
  a flow classifier in the MAC, e.g. by IOV MAC address, VLAN tag
  or even individual TCP connection depending on the NIC's capabilities.
* 802.1p flow control for incoming ethernet data based on the amount
  of data queued up between the MAC and the driver
* interrupt mitigation for both inbound data and outbound completion,
  by delaying the IRQ to the OS until multiple messages have arrived
  or a queue specific amount of time has passed.
* controlling the amount of outbound buffer space per flow to minimize
  buffer-bloat between an ethernet driver and the NIC hardware.
* reordering data from outbound flows based on priority.

This is basically my current interpretation, I hope I got at least
some of it right this time ;-)

	Arnd
