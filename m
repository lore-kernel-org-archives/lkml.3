Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3GLMO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:14:27 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:44175 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab3GLMOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:14:24 -0400
Date: Fri, 12 Jul 2013 14:14:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>, Joerg Roedel <joro@8bytes.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: next-20130709 DMAR issues
Message-ID: <20130712121419.GA22945@gmail.com>
References: <29624.1373475702@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29624.1373475702@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed a few DMAR people.)

* Valdis Kletnieks <Valdis.Kletnieks@vt.edu> wrote:

> Dell Latitude E6530.
> 
> Seeing a new error message crop up in next-0709 that wasn't there with 0703.
> Particularly odd, last person to touch dmar.c was on 05/20/2013, so no smoking
> guns there...
> 
> egrep -i 'dmar|linux ver' /var/log/messages  gives me:
> 
> Jul  9 21:47:15 turing-police kernel: [    0.000000] Linux version 3.10.0-next-20130703 (valdis@turing-police.cc.vt.edu) (gcc version 4.8.1 20130612 (Red Hat 4.8.1-2) (GCC) ) #99 SMP PREEMPT Wed Jul 3 17:40:09 EDT 2013
> Jul  9 21:47:15 turing-police kernel: [    0.000000] ACPI: DMAR 00000000cb7fd298 00080 (v01 INTEL      SNB  00000001 INTL 00000001)
> Jul  9 21:47:15 turing-police kernel: [    0.021530] dmar: Host address width 36
> Jul  9 21:47:15 turing-police kernel: [    0.021536] dmar: DRHD base: 0x000000fed90000 flags: 0x1
> Jul  9 21:47:15 turing-police kernel: [    0.021569] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 ecap f0105a
> Jul  9 21:47:15 turing-police kernel: [    0.021576] dmar: RMRR base: 0x000000ce761000 end: 0x000000ce780fff
> Jul  9 21:47:15 turing-police kernel: [    1.023235] DMAR: No ATSR found
> 
> That's what it usually says.  But now I have:
> 
> Jul 10 12:20:19 turing-police kernel: [    0.000000] Linux version 3.10.0-next-20130709 (valdis@turing-police.cc.vt.edu) (gcc version 4.8.1 20130612 (Red Hat 4.8.1-2) (GCC) ) #100 SMP PREEMPT Tue Jul 9 16:01:59 EDT 2013
> Jul 10 12:20:19 turing-police kernel: [    0.000000] ACPI: DMAR 00000000cb7fd298 00080 (v01 INTEL      SNB  00000001 INTL 00000001)
> Jul 10 12:20:19 turing-police kernel: [    0.021453] dmar: Host address width 36
> Jul 10 12:20:19 turing-police kernel: [    0.021456] dmar: DRHD base: 0x000000fed90000 flags: 0x1
> Jul 10 12:20:19 turing-police kernel: [    0.021485] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 ecap f0105a
> Jul 10 12:20:19 turing-police kernel: [    0.021487] dmar: RMRR base: 0x000000ce761000 end: 0x000000ce780fff
> Jul 10 12:20:19 turing-police kernel: [    0.021575] dmar: DRHD: handling fault status reg 2
> Jul 10 12:20:19 turing-police kernel: [    0.021583] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr ce71d000
> Jul 10 12:20:19 turing-police kernel: [    0.021583] DMAR:[fault reason 06] PTE Read access is not set
> Jul 10 12:20:19 turing-police kernel: [    1.034643] DMAR: No ATSR found
> 
> Now I have 3 extra messages talking about handling a fault status.  lspci says 00:1f.2 is:
> 
> 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
> 
> I found similar in a thread here: http://lkml.indiana.edu/hypermail/linux/kernel/1212.1/02319.html
> which ended with Don Dutile saying:
> 
> "DMAR table does not have an entry for this device to this region.
> Once the driver reconfigs/resets the device to stop polling bios-boot
> cmd rings and use (new) OS (dma-mapped) rings, there's a period of time
> during this transition that the hw is babbling away to an area that is no
> longer mapped."
> 
> But I'm not convinced this is the same issue - why did it change between 0703 and 0709,
> when I haven't updated the firmware. No relevant .config changes between the two, either.
> 
> If this doesn't ring any bells, I'l go do the bisect thing...


