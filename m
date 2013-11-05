Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3KEI1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:27:37 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:12722 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3KEI1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:27:25 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Joerg Roedel <joro@8bytes.org>
CC: <linux-pci@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        "Hanjun Guo" <guohanjun@huawei.com>
Subject: [PATCH 0/1] IOMMU: Enhance IOMMU to support device hotplug
Date: Tue, 5 Nov 2013 16:24:57 +0800
Message-ID: <1383639898-48776-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cover letter help to find the issue and review the patch.

Reproduce the issue:
linux-rh5885:~ # echo 1 > /sys/bus/pci/devices/0000\:80\:05.0/remove ----> I remove this device because 80:05.0 device pointer saved in drhd->devices[index]
linux-rh5885:~ # echo 1 > /sys/bus/pci/rescan
linux-rh5885:~ # dmesg
...[snip]...
[  611.857095] dmar: DRHD: handling fault status reg 2
[  611.857109] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff7000
[  611.857109] DMAR:[fault reason 02] Present bit in context entry is clear
[  611.857524] dmar: DRHD: handling fault status reg 102
[  611.857534] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff6000
[  611.857534] DMAR:[fault reason 02] Present bit in context entry is clear
[  611.857936] dmar: DRHD: handling fault status reg 202
[  611.857947] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff5000
[  611.857947] DMAR:[fault reason 02] Present bit in context entry is clear
[  611.858351] dmar: DRHD: handling fault status reg 302
[  611.858362] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff4000
[  611.858362] DMAR:[fault reason 02] Present bit in context entry is clear
[  611.860819] IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
[  611.860983] dmar: DRHD: handling fault status reg 402
[  611.860995] dmar: INTR-REMAP: Request device [[86:00.3] fault index a4
[  611.860995] INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear

This patch tested in huawei RH5885 4P server.

Following is DMAR talbe and lspci info.

My DMAR Table info:
--------------------------------------------------------------
/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20081031
 *
 * Disassembly of DMAR.dat, Wed Oct 23 09:46:44 2013
 *
 * ACPI Data Table [DMAR]
 *
 * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
 */

[000h 000  4]                    Signature : "DMAR"    /* DMA Remapping table */
[004h 004  4]                 Table Length : 00000198
[008h 008  1]                     Revision : 01
[009h 009  1]                     Checksum : 47
[00Ah 010  6]                       Oem ID : "A M I "
[010h 016  8]                 Oem Table ID : "OEMDMAR "
[018h 024  4]                 Oem Revision : 00000001
[01Ch 028  4]              Asl Compiler ID : "INTL"
[020h 032  4]        Asl Compiler Revision : 00000001

[024h 036  1]           Host Address Width : 2B
[025h 037  1]                        Flags : 01

[030h 048  2]                Subtable Type : 0000 <Hardware Unit Definition>
[032h 050  2]                       Length : 0068
[034h 052  1]                        Flags : 00
[035h 053  1]                     Reserved : 00
[036h 054  2]           PCI Segment Number : 0000
[038h 056  8]        Register Base Address : 00000000FD800000

[040h 064  1]      Device Scope Entry Type : 03
[041h 065  1]                 Entry Length : 08
[042h 066  2]                     Reserved : 0000
[044h 068  1]               Enumeration ID : 03
[045h 069  1]               PCI Bus Number : 80
[046h 070  2]                     PCI Path : [13, 00]

[048h 072  1]      Device Scope Entry Type : 01
[049h 073  1]                 Entry Length : 08
[04Ah 074  2]                     Reserved : 0000
[04Ch 076  1]               Enumeration ID : 00
[04Dh 077  1]               PCI Bus Number : 80
[04Eh 078  2]                     PCI Path : [14, 00]

[050h 080  1]      Device Scope Entry Type : 01
[051h 081  1]                 Entry Length : 08
[052h 082  2]                     Reserved : 0000
[054h 084  1]               Enumeration ID : 00
[055h 085  1]               PCI Bus Number : 80
[056h 086  2]                     PCI Path : [14, 01]

[058h 088  1]      Device Scope Entry Type : 01
[059h 089  1]                 Entry Length : 08
[05Ah 090  2]                     Reserved : 0000
[05Ch 092  1]               Enumeration ID : 00
[05Dh 093  1]               PCI Bus Number : 80
[05Eh 094  2]                     PCI Path : [14, 02]

[060h 096  1]      Device Scope Entry Type : 01
[061h 097  1]                 Entry Length : 08
[062h 098  2]                     Reserved : 0000
[064h 100  1]               Enumeration ID : 00
[065h 101  1]               PCI Bus Number : 80
[066h 102  2]                     PCI Path : [14, 03]

[068h 104  1]      Device Scope Entry Type : 02
[069h 105  1]                 Entry Length : 08
[06Ah 106  2]                     Reserved : 0000
[06Ch 108  1]               Enumeration ID : 00
[06Dh 109  1]               PCI Bus Number : 80
[06Eh 110  2]                     PCI Path : [00, 00]

[070h 112  1]      Device Scope Entry Type : 02
[071h 113  1]                 Entry Length : 08
[072h 114  2]                     Reserved : 0000
[074h 116  1]               Enumeration ID : 00
[075h 117  1]               PCI Bus Number : 80
[076h 118  2]                     PCI Path : [01, 00]

[078h 120  1]      Device Scope Entry Type : 02
[079h 121  1]                 Entry Length : 08
[07Ah 122  2]                     Reserved : 0000
[07Ch 124  1]               Enumeration ID : 00
[07Dh 125  1]               PCI Bus Number : 80
[07Eh 126  2]                     PCI Path : [03, 00]

[080h 128  1]      Device Scope Entry Type : 02
[081h 129  1]                 Entry Length : 08
[082h 130  2]                     Reserved : 0000
[084h 132  1]               Enumeration ID : 00
[085h 133  1]               PCI Bus Number : 80
[086h 134  2]                     PCI Path : [05, 00]

[088h 136  1]      Device Scope Entry Type : 02
[089h 137  1]                 Entry Length : 08
[08Ah 138  2]                     Reserved : 0000
[08Ch 140  1]               Enumeration ID : 00
[08Dh 141  1]               PCI Bus Number : 80
[08Eh 142  2]                     PCI Path : [07, 00]

[090h 144  1]      Device Scope Entry Type : 02
[091h 145  1]                 Entry Length : 08
[092h 146  2]                     Reserved : 0000
[094h 148  1]               Enumeration ID : 00
[095h 149  1]               PCI Bus Number : 80
[096h 150  2]                     PCI Path : [09, 00]

[098h 152  2]                Subtable Type : 0000 <Hardware Unit Definition>
[09Ah 154  2]                       Length : 0020
[09Ch 156  1]                        Flags : 01
[09Dh 157  1]                     Reserved : 00
[09Eh 158  2]           PCI Segment Number : 0000
[0A0h 160  8]        Register Base Address : 00000000FD000000

[0A8h 168  1]      Device Scope Entry Type : 03
[0A9h 169  1]                 Entry Length : 08
[0AAh 170  2]                     Reserved : 0000
[0ACh 172  1]               Enumeration ID : 00
[0ADh 173  1]               PCI Bus Number : 00
[0AEh 174  2]                     PCI Path : [1F, 07]

[0B0h 176  1]      Device Scope Entry Type : 03
[0B1h 177  1]                 Entry Length : 08
[0B2h 178  2]                     Reserved : 0000
[0B4h 180  1]               Enumeration ID : 02
[0B5h 181  1]               PCI Bus Number : 00
[0B6h 182  2]                     PCI Path : [13, 00]

[0B8h 184  2]                Subtable Type : 0001 <Reserved Memory Region>
[0BAh 186  2]                       Length : 0058
[0BCh 188  2]                     Reserved : 0000
[0BEh 190  2]           PCI Segment Number : 0000
[0C0h 192  8]                 Base Address : 0000000079B45000
[0C8h 200  8]          End Address (limit) : 0000000079B5AFFF

[0D0h 208  1]      Device Scope Entry Type : 01
[0D1h 209  1]                 Entry Length : 08
[0D2h 210  2]                     Reserved : 0000
[0D4h 212  1]               Enumeration ID : 00
[0D5h 213  1]               PCI Bus Number : 00
[0D6h 214  2]                     PCI Path : [1D, 00]

[0D8h 216  1]      Device Scope Entry Type : 01
[0D9h 217  1]                 Entry Length : 08
[0DAh 218  2]                     Reserved : 0000
[0DCh 220  1]               Enumeration ID : 00
[0DDh 221  1]               PCI Bus Number : 00
[0DEh 222  2]                     PCI Path : [1D, 01]

[0E0h 224  1]      Device Scope Entry Type : 01
[0E1h 225  1]                 Entry Length : 08
[0E2h 226  2]                     Reserved : 0000
[0E4h 228  1]               Enumeration ID : 00
[0E5h 229  1]               PCI Bus Number : 00
[0E6h 230  2]                     PCI Path : [1D, 02]

[0E8h 232  1]      Device Scope Entry Type : 01
[0E9h 233  1]                 Entry Length : 08
[0EAh 234  2]                     Reserved : 0000
[0ECh 236  1]               Enumeration ID : 00
[0EDh 237  1]               PCI Bus Number : 00
[0EEh 238  2]                     PCI Path : [1D, 07]

[0F0h 240  1]      Device Scope Entry Type : 01
[0F1h 241  1]                 Entry Length : 08
[0F2h 242  2]                     Reserved : 0000
[0F4h 244  1]               Enumeration ID : 00
[0F5h 245  1]               PCI Bus Number : 00
[0F6h 246  2]                     PCI Path : [1A, 00]

[0F8h 248  1]      Device Scope Entry Type : 01
[0F9h 249  1]                 Entry Length : 08
[0FAh 250  2]                     Reserved : 0000
[0FCh 252  1]               Enumeration ID : 00
[0FDh 253  1]               PCI Bus Number : 00
[0FEh 254  2]                     PCI Path : [1A, 01]

[100h 256  1]      Device Scope Entry Type : 01
[101h 257  1]                 Entry Length : 08
[102h 258  2]                     Reserved : 0000
[104h 260  1]               Enumeration ID : 00
[105h 261  1]               PCI Bus Number : 00
[106h 262  2]                     PCI Path : [1A, 02]

[108h 264  1]      Device Scope Entry Type : 01
[109h 265  1]                 Entry Length : 08
[10Ah 266  2]                     Reserved : 0000
[10Ch 268  1]               Enumeration ID : 00
[10Dh 269  1]               PCI Bus Number : 00
[10Eh 270  2]                     PCI Path : [1A, 07]

[110h 272  2]                Subtable Type : 0002 <Root Port ATS Capability>
[112h 274  2]                       Length : 0060
[114h 276  1]                        Flags : 00
[115h 277  1]                     Reserved : 00
[116h 278  2]           PCI Segment Number : 0000

[114h 276  1]      Device Scope Entry Type : 00
[115h 277  1]                 Entry Length : 00
[116h 278  2]                     Reserved : 0000
[118h 280  1]               Enumeration ID : 02
[119h 281  1]               PCI Bus Number : 08
Invalid zero length subtable
-------------------------------------------------------------------
...[snip]...
+-[0000:80]-+-00.0-[0000:81]--
 |           +-01.0-[0000:82-83]--
 |           +-03.0-[0000:84-85]--
 |           +-05.0-[0000:86]--+-00.0  Intel Corporation 82580 Gigabit Network Connection
 |           |                 +-00.1  Intel Corporation 82580 Gigabit Network Connection
 |           |                 +-00.2  Intel Corporation 82580 Gigabit Network Connection
 |           |                 \-00.3  Intel Corporation 82580 Gigabit Network Connection
 |           +-07.0-[0000:87-88]--
 |           +-09.0-[0000:89-8a]--
 |           +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
 |           +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
 |           +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
 |           +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
 |           \-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
 \-[0000:00]-+-00.0  Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
             +-01.0-[0000:01-02]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                    \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-03.0-[0000:03-04]--
             +-05.0-[0000:05]----00.0  LSI Logic / Symbios Logic MegaRAID SAS 2208 [Thunderbolt]
             +-07.0-[0000:06-07]--
             +-09.0-[0000:08-09]--
             +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
             +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
             +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
             +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
             +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
             +-15.0  Intel Corporation 5520/5500/X58 Trusted Execution Technology Registers
             +-1a.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
             +-1a.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
             +-1a.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
             +-1a.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
             +-1c.0-[0000:0a]--
             +-1c.4-[0000:0b]----00.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z11/Z11M
             +-1d.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
             +-1d.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
             +-1d.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
             +-1d.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
             +-1e.0-[0000:0c]--
             +-1f.0  Intel Corporation 82801JIB (ICH10) LPC Interface Controller
             +-1f.2  Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller
             \-1f.3  Intel Corporation 82801JI (ICH10 Family) SMBus Controller


Yijing Wang (1):
  IOMMU: Save pci device id instead of pci_dev* pointer for DMAR
    devices

 drivers/iommu/dmar.c        |   93 +++++++++++++-------------
 drivers/iommu/intel-iommu.c |  155 ++++++++++++++++++++++++++++---------------
 include/linux/dmar.h        |   20 ++++--
 3 files changed, 159 insertions(+), 109 deletions(-)


