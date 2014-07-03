Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbaGCJWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:08 -0400
Received: from mx0.aculab.com ([213.249.233.131]:33604 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932239AbaGCJWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:03 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        Alexander Gordeev <agordeev@redhat.com>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
Thread-Topic: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
Thread-Index: AQHPljNB2YNqvD5cNkq3/QaNLPhjzpuOEsDA
Date: Thu, 3 Jul 2014 09:20:52 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726BF4E@AcuExch.aculab.com>
References: <cover.1402405331.git.agordeev@redhat.com>
 <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com>
In-Reply-To: <20140702202201.GA28852@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s63A92u5007484

From: Bjorn Helgaas
> On Tue, Jun 10, 2014 at 03:10:30PM +0200, Alexander Gordeev wrote:
> > There are PCI devices that require a particular value written
> > to the Multiple Message Enable (MME) register while aligned on
> > power of 2 boundary value of actually used MSI vectors 'nvec'
> > is a lesser of that MME value:
> >
> > 	roundup_pow_of_two(nvec) < 'Multiple Message Enable'
> >
> > However the existing pci_enable_msi_block() interface is not
> > able to configure such devices, since the value written to the
> > MME register is calculated from the number of requested MSIs
> > 'nvec':
> >
> > 	'Multiple Message Enable' = roundup_pow_of_two(nvec)
> 
> For MSI, software learns how many vectors a device requests by reading
> the Multiple Message Capable (MMC) field.  This field is encoded, so a
> device can only request 1, 2, 4, 8, etc., vectors.  It's impossible
> for a device to request 3 vectors; it would have to round up that up
> to a power of two and request 4 vectors.
> 
> Software writes similarly encoded values to MME to tell the device how
> many vectors have been allocated for its use.  For example, it's
> impossible to tell the device that it can use 3 vectors; the OS has to
> round that up and tell the device it can use 4 vectors.
> 
> So if I understand correctly, the point of this series is to take
> advantage of device-specific knowledge, e.g., the device requests 4
> vectors via MMC, but we "know" the device is only capable of using 3.
> Moreover, we tell the device via MME that 4 vectors are available, but
> we've only actually set up 3 of them.
...

Even if you do that, you ought to write valid interrupt information
into the 4th slot (maybe replicating one of the earlier interrupts).
Then, if the device does raise the 'unexpected' interrupt you don't
get a write to a random kernel location.

Plausibly something similar should be done when a smaller number of
interrupts is assigned.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
