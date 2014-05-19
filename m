Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaESXgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:36:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:52849 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaESXgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:36:02 -0400
Date: Tue, 20 May 2014 08:35:35 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC Patch Part1 V1 00/30] use irqdomain to dynamically allocate
 IRQ for IOAPIC pin
In-Reply-To: <alpine.DEB.2.02.1405192250170.22305@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1405200823300.5204@ionos.tec.linutronix.de>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.02.1405161601060.4039@ionos.tec.linutronix.de> <53787F09.9000200@linux.intel.com> <alpine.DEB.2.02.1405192250170.22305@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiang,

On Mon, 19 May 2014, Thomas Gleixner wrote:
> > We may build hierarchy irqdomains as below for x86,
> > [IOAPIC]      [MSI/MSI-x]  [HPET]  [DMAR] [Legacy]
> >     |            |           |       |       |
> >     v            v           v       |       |
> > [           Remapping           ]    |       |
> >                  |                   |       |
> >                  v                   v       v
> > [                   Root/vector                ]
> > 
> > For x86, irq_alloc_info_t structure will be used to host CPU mask,
> > device pointer, IOAPIC pin attributes, NUMA node info etc.
> 
> Do we really need to hand all of this down?

having recovered from a 24hr travel, I think we really only need to
hand down cpumask.

If you want to allocate a vector, all the vector domain needs to know
is the cpumask and the number of consecutive vectors you want to
allocate.

The IOAPIC pin attribute is only interesting inside the ioapic domain,
there is no need to have it elsewhere.

Numa node is encoded in the cpumask, IOW the node info selects only
bits for that node in the mask.

Same for the device. It's only relevant for setting up MSI[x] or
legacy PCI interrupts. But the underlying vector domain does not care
at all about it.

Thanks,

	tglx
