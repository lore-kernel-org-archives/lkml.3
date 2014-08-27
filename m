Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416AbaH0VOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:14:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964951AbaH0VOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:14:44 -0400
Date: Wed, 27 Aug 2014 17:13:17 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org
Subject: HT1000 SATA broken by "x86, irq, ACPI: Use common irqdomain map
 interface to program IOAPIC pins"
Message-ID: <alpine.LRH.2.02.1408271657300.17705@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The patch d7b830013f59cf586c1cec3caa1ce7156da59a13, committed to 3.17-rc1, 
breaks the SATA controller (sata_svw driver) on HT1000 ServerWorks 
chipset. The other drivers work correctly.

With the patch d7b830013f59cf586c1cec3caa1ce7156da59a13, the SATA 
controller times out after every command with lost interrupt.

With the patch 16ee7b3dcc56be14b9a813612cff2cc2339cdced, the SATA driver 
can't be loaded at all, it fails with:
sata_svw 0000:01:0e.0: version 2.3
Failed to set pin attr for GSI11
sata_svw 0000:01:0e.0: PCI INT A: failed to register GSI
sata_svw: probe of 0000:01:0e.0 failed with error -1

/proc/interrupts:
# cat /proc/interrupts
            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       
CPU6       CPU7       CPU8       CPU9       CPU10      CPU11
   0:         26          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-edge      
timer
   1:         12          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-edge      
i8042
   4:         14          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-edge      
serial
   6:          3          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-edge      
floppy
   8:          0          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-edge      
rtc0
   9:          0          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-fasteoi   
acpi
  11:        350          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-fasteoi   
sata_svw
  14:          0          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-edge      
pata_serverworks
  15:          0          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-edge      
pata_serverworks
  16:          0          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-fasteoi   
ohci_hcd:usb2, ohci_hcd:usb3, ohci_hcd:usb4
  17:          0          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-fasteoi   
ehci_hcd:usb1
  20:       2041          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-fasteoi   
eth3
  28:       6375          0          0          0          0          0          
0          0          0          0          0          0   IO-APIC-fasteoi   
ioc0
 NMI:          0          0          0          0          0          0          
0          0          0          0          0          0   Non-maskable 
interrupts
 LOC:       3651       2122       2022       1639       1125       1065        
602       1642       3581       3789        903        792   Local timer 
interrupts
 SPU:          0          0          0          0          0          0          
0          0          0          0          0          0   Spurious 
interrupts
 PMI:          0          0          0          0          0          0          
0          0          0          0          0          0   Performance 
monitoring interrupts
 IWI:        254        197        252         69         41         32         
16        344        324         76         34         19   IRQ work 
interrupts
 RTR:          0          0          0          0          0          0          
0          0          0          0          0          0   APIC ICR read 
retries
 RES:       2609       4492       2614       1944       1328       1048       
2050       3602       2280       1557        973        928   Rescheduling 
interrupts
 CAL:         77        118        113        115        109        113        
368        727        772        706        218        252   Function call 
interrupts
 TLB:         39        682        186         83         66         32         
19       1232        212        112         97         43   TLB shootdowns
 THR:          0          0          0          0          0          0          
0          0          0          0          0          0   Threshold APIC 
interrupts
 MCE:          0          0          0          0          0          0          
0          0          0          0          0          0   Machine check 
exceptions
 MCP:          2          2          2          2          2          2          
2          2          2          2          2          2   Machine check 
polls
 ERR:          0
 MIS:          0

lspci:
01:0e.0 RAID bus controller: Broadcom BCM5785 [HT1000] SATA (Native SATA 
Mode) (prog-if 05)
        Subsystem: Broadcom BCM5785 [HT1000] SATA (Native SATA Mode)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 9c00 [size=8]
        Region 1: I/O ports at 9880 [size=4]
        Region 2: I/O ports at 9800 [size=8]
        Region 3: I/O ports at 9480 [size=4]
        Region 4: I/O ports at 9400 [size=16]
        Region 5: Memory at fa3fe000 (32-bit, non-prefetchable) [size=8K]
        Expansion ROM at fa3c0000 [disabled] [size=128K]
        Capabilities: [60] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=512 OST=8
                Status: Dev=01:0e.0 64bit+ 133MHz+ SCD- USC- DC=simple 
DMMRBC=512 DMOST=8 DMCRS=32 RSCEM- 266MHz- 533MHz-
        Capabilities: [90] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Kernel driver in use: sata_svw

Mikulas
