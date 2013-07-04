Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab3GDExn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:53:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:40969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab3GDExl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:53:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,992,1363158000"; 
   d="scan'208";a="263932181"
Date: Thu, 4 Jul 2013 12:53:16 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haicheng Li <haicheng.lee@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI: Add hide_device support to pci subsystem.
Message-ID: <20130704045316.GC3244@hli22-desktop>
References: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com>
 <CAErSpo5dR_2tUDFoFO49N3Ut569+6Cfosx8Q=91U_w-8mvFVkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5dR_2tUDFoFO49N3Ut569+6Cfosx8Q=91U_w-8mvFVkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 10:09:32AM -0600, Bjorn Helgaas wrote:
> On Wed, Jul 3, 2013 at 9:16 AM, Haicheng Li <haicheng.li@linux.intel.com> wrote:
> > With more and more SOCs having pci device integrated into chip (e.g. Intel
> > Atom series), it's useful to add an interface to cleanly hide pci devices from
> > pci device scanning, which is because:
> >
> > 1. phone or tablet OEMs may choose disabling some pci device in the SOC,
> >    such as camera ISP in Intel Atom Z2580 chip, and etc.
> > 2. if such disabled devices are not cleanly removed from pci device tree,
> >    then pci-core will still try to operate on the relative device control
> >    registers while S3 suspend and resume.
> > 3. so hiding such devices from early begining will not only reduce the kernel
> >    boot time, but also optimize the latency of system suspend and resume.
> 
> Normally the chip provides a way to disable devices by writing a
> configuration register.  Then the device doesn't respond when Linux
> enumerates devices, so nothing special is required in the kernel.
Agreed, this is true.

> What's different about the Z2580?  I'd be surprised if Intel forgot to
> include such a register. 
A pci shim faked by firmware was introduced to help easily port Linux onto Z2XXX
SOC chips, which enumerates both real and fake PCI devices inside the SOC (The camera ISP
I mentioned above is a real PCI device in this case) 

A detailed tech talk about this technology by Jacob Pan in elc2010 can be found online
here: http://elinux.org/images/e/ee/Jacob-Pan-x86MID-elc2010.pdf

> Maybe the firmware just isn't smart enough
> to disable the device?  If so, it would be better to fix the firmware
> than to add kludges in the kernel.
On PC or server, end-user/OEM can disable/hide a pci device easily thru BIOS setting or
by hacking BIOS code directly when they find some device is broken or useless.

However on phone or tablet equipment, there is no BIOS-setting alike UI exposed to end-user/developer
to disable broken device easily (and physically removing the device is not doable on Phone or tablet)

OTOH, this i/f is really *helpful* for kernel developer to power-on a new platform, debug system
problem, or to do performance tuning of suspend/resume. At least it makes my daily job easier:).

So if people are strongly against this, I would still suggest accept this i/f as a debug i/f
at least:).
 
> > To hide pci devices, just pass such parameters to kernel at boot stage:
> >         pci=hide=[<domain>:]<bus>:<slot>.<func>[; ...]
