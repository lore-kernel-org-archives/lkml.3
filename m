Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbaEFCmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 22:42:31 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51708 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbaEFCm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 22:42:29 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "bhelgaas@google.com" <bhelgaas@google.com>
CC: "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU
 address to phys_addr_t
Thread-Topic: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU
 address to phys_addr_t
Thread-Index: AQHPZLNvK1nxQSaf0ES3zCf+oGYc5JssOYIAgABS9ACAALo/AIAAKhYAgAWm7gCAAD3VAA==
Date: Tue, 6 May 2014 02:42:22 +0000
Message-ID: <1399344142.2164.67.camel@dabdike.int.hansenpartnership.com>
References: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com>
	 <CAErSpo7zjXg8xrV7=q36rNp_g573P93HiXTB72Z1cZfjGeeBmg@mail.gmail.com>
	 <1399011100.2174.45.camel@dabdike> <11081303.OBX0h8mIfH@wuerfel>
	 <20140505230104.GB8883@google.com>
In-Reply-To: <20140505230104.GB8883@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.150.111]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <B5AF9EB96D51E24285DCC27EE95338C1@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 17:01 -0600, Bjorn Helgaas wrote:
> On Fri, May 02, 2014 at 10:42:18AM +0200, Arnd Bergmann wrote:

> > I don't know about NCR_Q720, but all others are only used on machines
> > where physical addresses and bus addresses are in the same space.
> 
> In general, the driver doesn't know whether physical and bus addresses
> are in the same space.  At least, I *hope* it doesn't have to know,
> because it can't be very generic if it does.

The API was designed for the case where the memory resides on a PCI
device (the Q720 case), the card config gives us a bus address, but if
the system has an IOMMU, we'd have to do a dma_map of the entire region
to set up the IOMMU before we can touch it.  The address it gets back
from the dma_map (the dma_addr_t handle for the IOMMU mapping) is what
we pass into dma_declare_coherent_memory().  The reason it does an
ioremap is because this IOMMU mapped address is now physical to the CPU
and we want to make the region available to virtual space.  Essentially
the memory the allocator hands out behaves as proper virtual memory but
it's backed by physical memory on the card behind the PCI bridge.

I'm still not that fussed about the difference between phys_addr_t and
dma_addr_t, but if the cookie returned from a dma_map is a dma_addr_t
then that's what dma_declare_coherent_memory() should use.  If it's a
phys_addr_t, then likewise.

James

