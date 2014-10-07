Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaJGVj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:39:59 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63577 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaJGVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:39:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Tue, 07 Oct 2014 23:39:47 +0200
Message-ID: <3978481.XNAIA6gzAG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141007144750.GB30590@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <3659934.boXsmm8jcn@wuerfel> <20141007144750.GB30590@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U7YUBW/9j2nFXpMz3nKVgHX8m5M2ycFrnbRKwU1M6g8
 Y6GTMpWumBMj0VColp2TRQaNz3hnYsXfELrFPtBjnRfT14ghUK
 7OTxxzJ+Jqnb19eZQmxr6m9s7T+Nop6z/fy9N4lTb3FI6zMYE2
 eOhMbGEa02a8VgV1zlR0m/it9HzUMX1pRFjhHa3+v6oPOpiF56
 NUn5bP75eeXoZJI21lkM5/0Z4ETZLwCdGxxH/ZT9pvS+D5MVdE
 Hd+byP+bEOObSCdrPav9A2ZiEqPMzUburXqicR/cSatvIM9/88
 WdoEHeputhGhY160U+jyzuob0WjLAcnxyO+VVinoZ5LDacL+A/
 TBuz0tLp5rTnPPWt3q+U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2014 15:47:50 Lorenzo Pieralisi wrote:
> On Tue, Oct 07, 2014 at 02:52:27PM +0100, Arnd Bergmann wrote:
> > On Tuesday 07 October 2014 13:06:59 Lorenzo Pieralisi wrote:
> > > On Wed, Oct 01, 2014 at 10:38:45AM +0100, Arnd Bergmann wrote:
> > > 
> > > [...]
> > > 
> > > > pci_mmap_page_range could either get generalized some more in an attempt
> > > > to have a __weak default implementation that works on ARM, or it could
> > > > be changed to lose the dependency on pci_sys_data instead. In either
> > > > case, the change would involve using the generic pci_host_bridge_window
> > > > list.
> > > 
> > > On ARM pci_mmap_page_range requires pci_sys_data to retrieve its
> > > mem_offset parameter. I had a look, and I do not understand *why*
> > > it is required in that function, so I am asking. That function
> > > is basically used to map PCI resources to userspace, IIUC, through
> > > /proc or /sysfs file mappings. As far as I understand those mappings
> > > expect VMA pgoff to be the CPU address when files representing resources
> > > are mmapped from /proc and 0 when mmapped from /sys (I mean from
> > > userspace, then VMA pgoff should be updated by the kernel to map the
> > > resource).
> > 
> > Applying the mem_offset is certainly the more intuitive way, since
> > that lets you read the PCI BAR values from a device and access the
> > device with the appropriate offsets.
> 
> Ok, but I am referring to this snippet (drivers/pci/pci-sysfs.c):
> 
> /* pci_mmap_page_range() expects the same kind of entry as coming
>  * from /proc/bus/pci/ which is a "user visible" value. If this is
>  * different from the resource itself, arch will do necessary fixup.
>  */
> pci_resource_to_user(pdev, i, res, &start, &end);
> 
> --> Here start represents a CPU physical address, if pci_resource_to_user()
>     does not fix it up, correct ?
> 
> vma->vm_pgoff += start >> PAGE_SHIFT;
> 
> [...]
> 
> return pci_mmap_page_range(...);
> 
> pci_mmap_page_range() applies (mem_offset >> PAGE_SHIFT) to pgoff in the
> ARM implemention.
> 
> Is not there a mismatch here on platforms where mem_offset != 0 ?

Yes, I think that's right: ARM never gained its own pci_resource_to_user()
implementation, presumably because nobody ran into this problem and
debugged it all the way.

	Arnd
