Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaEMWf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:35:29 -0400
Received: from sam.nabble.com ([216.139.236.26]:60999 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaEMWfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:35:21 -0400
Date: Tue, 13 May 2014 15:35:20 -0700 (PDT)
From: eddy0596 <eddy0596@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1400020520427-859747.post@n7.nabble.com>
In-Reply-To: <20140510145619.2997.429.stgit@bling.home>
References: <20140510145619.2997.429.stgit@bling.home>
Subject: Re: [PATCH v3 00/15] PCI/iommu: Fix DMA alias problems
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alex,

Thanks for working on a fix on this long standing issue. I have applied the
amd portion of the IOMMU patches against the 3.14.3 kernel and found the
followings:
1) The computer would not boot up if it's from a cold start. The kernel log
shows that it hangs at the point the kernel attempt to attach the scsi disk
[sdk] that connects to the LSI-SAS2008 controller at pci 04:00.0. I can use
Ctrl+Alt+Del to reboot the computer. So, I guess the kernel didn't "hang"
and I don't see any oops either.
2) After a warm reboot with Ctrl+Alt+Del, the kernel will boot up fine. And,
the Marvell controller behaves properly (More stress test needed) and so as
the two LSI-SAS2008. A warm reboot after a hard reset at BIOS prompt will
also boot up fine.
3) Removing sdk and perform a cold reboot, the kernel stops after attaching
all the ST3000DM001 harddisks that connects to the LSI-SAS2008 at pci
01:00:0. The kernel stops at "ata12: SATA link down (SStatus 0 SControl
300)".
4) Removing sda and sdl that connects to the Marvell 88SE9172 at pci
09:00.0, the kernel stops after attaching the eight ST3000DM001 that
connects to the LSI-SAS2008 at pci 01:00:0.
5) Cold start with a kernel without the IOMMU patches starts up fine except
a number of kernel oops related to the Marvell controller complaining about
invalid PCI access from the AMD IOMMU.

Attached is the kernel boot log that's obtained with all HDDs attached and
successfully boot up after a warm reboot and some information on my setup.
Let me know if you need more information/log to help with debuging. 


Best Regards,

Edward Cheung

Motherboard: Gigabyte GA-990FXA-UD5 Revision 1.0. Note that the kernel is
using software IO TLB belief due to broken IVRS table. I am still trying to
find a fix for this. If there's any ivrs kernel boot parameter I should use,
please let me know.
Kernel: 3.14.3 with SCST patches applied.
Base Distro and kernel compile environment: Ubuntu 14.04LTS
Following IOMMU patches applied (Marked with *).
      (*)PCI: Add DMA alias iterator 
      (*)PCI: quirk pci_for_each_dma_alias() 
      (*)PCI: quirk dma_func_alias for Ricoh devices 
      (*)PCI: quirk dma_func_alias for Marvell devices 
      (*)PCI: Quirk pci_for_each_dma_alias() for bridges 
      PCI: Add quirks for ASMedia and Tundra bridges 
      (*)PCI: Consolidate isolation domain code 
      (*)iommu/amd: Use pci_find_dma_isolation_root() for IOMMU groups 
      (*)iommu/amd: Update to use PCI DMA aliases 
      iommu/intel: Use pci_find_dma_isolation_root() for IOMMU groups 
      iommu/intel: Update to use PCI DMA aliases 
      iommu/fsl: Use pci_find_dma_isolation_root() for IOMMU groups 
      iommu: Remove pci.h 
      PCI: Remove pci_find_upstream_pcie_bridge() 
      PCI: Remove pci_get_dma_source() 

root@SAN-1:/mnt# lsscsi
[1:0:0:0]    disk    ATA      ST3000DM001-1CH1 CC24  /dev/sdb
[1:0:1:0]    disk    ATA      ST3000DM001-1CH1 CC24  /dev/sdc
[1:0:2:0]    disk    ATA      ST3000DM001-1CH1 CC24  /dev/sdd
[1:0:3:0]    disk    ATA      ST3000DM001-1CH1 CC24  /dev/sde
[1:0:4:0]    disk    ATA      ST3000DM001-1CH1 CC24  /dev/sdf
[1:0:5:0]    disk    ATA      ST3000DM001-1CH1 CC24  /dev/sdg
[1:0:6:0]    disk    ATA      ST3000DM001-1CH1 CC24  /dev/sdh
[1:0:7:0]    disk    ATA      ST3000DM001-1CH1 CC24  /dev/sdi
[9:0:0:0]    disk    ATA      WDC WD6400AAKS-0 01.0  /dev/sda
[10:0:0:0]   disk    ATA      WDC WD6400AAKS-0 01.0  /dev/sdl
[14:0:0:0]   disk    Kingston DataTraveler G2  1.00  /dev/sdj
[16:0:0:0]   disk    ATA      ST3750330NS      SN04  /dev/sdk

root@SAN-1:/mnt# lspci
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI
bridge (external gfx0 port B) (rev 02)
00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD/ATI] RD990 I/O Memory
Management Unit (IOMMU)
00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI
bridge (PCI express gpp port B)
00:09.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI
bridge (PCI express gpp port H)
00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI
bridge (external gfx1 port A)
00:0b.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890 PCI to PCI
bridge (NB-SB link)
00:0c.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD890S PCI
Express bridge for GPP2 port 1
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40)
00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller
(rev 42)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
LPC host controller (rev 40)
00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to PCI
Bridge (rev 40)
00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
00:15.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB700/SB800/SB900
PCI to PCI bridge (PCIE port 0)
00:15.1 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB700/SB800/SB900
PCI to PCI bridge (PCIE port 1)
00:15.2 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB900 PCI to PCI
bridge (PCIE port 2)
00:15.3 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB900 PCI to PCI
bridge (PCIE port 3)
00:16.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:16.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 0
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 1
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 2
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 3
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 4
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 5
01:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008
PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
02:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host Controller
(rev 01)
03:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s
Controller (rev 11)
04:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008
PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
05:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to PCI
Express HBA (rev 02)
05:00.1 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to PCI
Express HBA (rev 02)
06:06.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI]
Device 515a
07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
08:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host Controller
(rev 01)
09:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s
Controller (rev 11)
0a:00.0 SATA controller: ASMedia Technology Inc. ASM1062 Serial ATA
Controller (rev 01)





--
View this message in context: http://linux-kernel.2935.n7.nabble.com/PATCH-v3-00-15-PCI-iommu-Fix-DMA-alias-problems-tp857369p859747.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
