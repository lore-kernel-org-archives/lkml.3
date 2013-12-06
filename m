Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3LFP2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:28:09 -0500
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:4424
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab3LFP2H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:28:07 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz9371I1102I542I1486Mzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh109h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h1155h)
X-WSS-ID: 0MXE5I0-08-I7K-02
X-M-MSG: 
From: "Naru, Kim" <Kim.Naru@amd.com>
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Thomas Renninger <trenn@suse.de>
Subject: RE: [PATCH 0/4] x86, microcode, AMD: Fix early loading
Thread-Topic: [PATCH 0/4] x86, microcode, AMD: Fix early loading
Thread-Index: AQHO8hOkiKlDlPy2BECGJtHxKE5QvZpHS0Pw
Date: Fri, 6 Dec 2013 15:27:53 +0000
Message-ID: <A38D1505C1E78C469FFA71861BDE11B32177A109@satlexdag05.amd.com>
References: <1386286348-5144-1-git-send-email-bp@alien8.de>
In-Reply-To: <1386286348-5144-1-git-send-email-bp@alien8.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,
I will take a look at it.

--kim

-----Original Message-----
From: Borislav Petkov [mailto:bp@alien8.de] 
Sent: Thursday, December 05, 2013 3:32 PM
To: X86 ML
Cc: LKML; Borislav Petkov; Naru, Kim; Thomas Renninger
Subject: [PATCH 0/4] x86, microcode, AMD: Fix early loading

From: Borislav Petkov <bp@suse.de>

A couple of openSUSE bugzillas made me look at the early ucode loading on AMD.

The problem is, we're doing memory allocation too early with IRQs disabled and we really want to avoid that. Also, 32-bit has other problems like calling rd/wrmsr*/cpuid functions at their virtual addresses while paging is not enabled yet. Bah.

So, fix that by *always* using the initrd image handed in from the bootloader and cache the ucode patches only late, right before the initrd is jettisoned. This avoids the allocation issue completely. While at it, take care of the 32-bit issues too.

Testing on 32-bit and 64-bit passes here.

@Kim: I'd appreciate it if you guys ran those patches too, by creating an early ucode initrd as it is described in Documentation/x86/early-microcode.txt.

Thanks.

Borislav Petkov (4):
  x86, ramdisk: Export relocated ramdisk VA
  x86, microcode: Share native MSR accessing variants
  x86, microcode, AMD: Fix early ucode loading
  x86, microcode: Move to a proper location

 arch/x86/include/asm/microcode.h                   |  15 ++
 arch/x86/include/asm/microcode_amd.h               |   7 +-
 arch/x86/include/asm/setup.h                       |   3 +-
 arch/x86/kernel/Makefile                           |   9 -
 arch/x86/kernel/cpu/Makefile                       |   1 +
 arch/x86/kernel/cpu/microcode/Makefile             |  11 +
 .../{microcode_amd.c => cpu/microcode/amd.c}       |  13 +-
 .../microcode/amd_early.c}                         | 239 ++++++++++++++-------
 .../{microcode_core.c => cpu/microcode/core.c}     |   0
 .../microcode/core_early.c}                        |   0
 .../{microcode_intel.c => cpu/microcode/intel.c}   |   0
 .../microcode/intel_early.c}                       |  10 -
 .../microcode/intel_lib.c}                         |   0
 arch/x86/kernel/setup.c                            |  19 +-
 14 files changed, 209 insertions(+), 118 deletions(-)  create mode 100644 arch/x86/kernel/cpu/microcode/Makefile
 rename arch/x86/kernel/{microcode_amd.c => cpu/microcode/amd.c} (96%)  rename arch/x86/kernel/{microcode_amd_early.c => cpu/microcode/amd_early.c} (55%)  rename arch/x86/kernel/{microcode_core.c => cpu/microcode/core.c} (100%)  rename arch/x86/kernel/{microcode_core_early.c => cpu/microcode/core_early.c} (100%)  rename arch/x86/kernel/{microcode_intel.c => cpu/microcode/intel.c} (100%)  rename arch/x86/kernel/{microcode_intel_early.c => cpu/microcode/intel_early.c} (98%)  rename arch/x86/kernel/{microcode_intel_lib.c => cpu/microcode/intel_lib.c} (100%)

--
1.8.4



