Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbbA2FjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:39:03 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbbA2FjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:39:00 -0500
Date: Wed, 28 Jan 2015 21:38:45 -0800
From: Darren Hart <dvhart@infradead.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        andy.shevchenko@gmail.com, boon.leong.ong@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Message-ID: <20150129053845.GB115032@vmdeb7>
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>
 <1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 06:36:25PM +0000, Bryan O'Donoghue wrote:
> Intel's Quark X1000 SoC contains a set of registers called Isolated Memory
> Regions. IMRs are accessed over the IOSF mailbox interface. IMRs are areas
> carved out of memory that define read/write access rights to the various
> system agents within the Quark system. For a given agent in the system it is
> possible to specify if that agent may read or write an area of memory
> defined by an IMR with a granularity of 1 KiB.
> 
> Quark_SecureBootPRM_330234_001.pdf section 4.5 details the concept of IMRs
> quark-x1000-datasheet.pdf section 12.7.4 details the implementation of IMRs
> in silicon.
> 
> eSRAM flush, CPU Snoop write-only, CPU SMM Mode, CPU non-SMM mode, RMU and
> PCIe Virtual Channels (VC0 and VC1) can have individual read/write access
> masks applied to them for a given memory region in Quark X1000. This
> enables IMRs to treat each memory transaction type listed above on an
> individual basis and to filter appropriately based on the IMR access mask
> for the memory region. Quark supports eight IMRs.
> 
> Since all of the DMA capable SoC components in the X1000 are mapped to VC0
> it is possible to define sections of memory as invalid for DMA write
> operations originating from Ethernet, USB, SD and any other DMA capable
> south-cluster component on VC0. Similarly it is possible to mark kernel
> memory as non-SMM mode read/write only or to mark BIOS runtime memory as SMM
> mode accessible only depending on the particular memory footprint on a given
> system.
> 
> On an IMR violation Quark SoC X1000 systems are configured to reset the
> system, so ensuring that the IMR memory map is consistent with the EFI
> provided memory map is critical to ensure no IMR violations reset the
> system.
> 
> The API for accessing IMRs is based on MTRR code but doesn't provide a /proc
> or /sys interface to manipulate IMRs. Defining the size and extent of IMRs
> is exclusively the domain of in-kernel code.
> 
> Quark firmware sets up a series of locked IMRs around pieces of memory that
> firmware owns such as ACPI runtime data. During boot a series of unlocked
> IMRs are placed around items in memory to guarantee no DMA modification of
> those items can take place. Grub also places an unlocked IMR around the
> kernel boot params data structure and compressed kernel image. It is
> necessary for the kernel to tear down all unlocked IMRs in order to ensure
> that the kernel's view of memory passed via the EFI memory map is consistent
> with the IMR memory map. Without tearing down all unlocked IMRs on boot
> transitory IMRs such as those used to protect the compressed kernel image
> will cause IMR violations and system reboots.
> 
> The IMR init code tears down all unlocked IMRs and sets a protective IMR
> around the kernel .text and .rodata as one contiguous block. This sanitizes
> the IMR memory map with respect to the EFI memory map and protects the
> read-only portions of the kernel from unwarranted DMA access.
> 
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>

Most of my concerns were addressed by V3 or so, but I've followed along and
concur with the subsequent improvements.

Reviewed-by: Darren Hart <dvhart@linux.intel.com>

-- 
Darren Hart
Intel Open Source Technology Center
