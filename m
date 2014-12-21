Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaLUMx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 07:53:26 -0500
Received: from audible.transient.net ([24.143.126.66]:46500 "HELO
	audible.transient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753440AbaLUMxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 07:53:24 -0500
Date: Sun, 21 Dec 2014 12:46:40 +0000
From: Jamie Heilman <jamie@audible.transient.net>
To: Tiejun Chen <tiejun.chen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: regression bisected; KVM: entry failed, hardware error 0x80000021
Message-ID: <20141221124640.GA4059@cucamonga.audible.transient.net>
Mail-Followup-To: Tiejun Chen <tiejun.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With v3.19-rc1 when I run qemu-system-x86_64 -machine pc,accel=kvm I
get:

KVM: entry failed, hardware error 0x80000021

If you're running a guest on an Intel machine without unrestricted mode
support, the failure can be most likely due to the guest entering an invalid
state for Intel VT. For example, the guest maybe running in big real mode
which is not supported on less recent Intel processors.

EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000663
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
EIP=0000e05b EFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 0000ffff 00009300
CS =f000 000f0000 0000ffff 00009b00
SS =0000 00000000 0000ffff 00009300
DS =0000 00000000 0000ffff 00009300
FS =0000 00000000 0000ffff 00009300
GS =0000 00000000 0000ffff 00009300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT=     00000000 0000ffff
IDT=     00000000 0000ffff
CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000000
Code=85 00 87 00 89 00 8b 00 00 00 86 00 88 00 8a 00 8c 00 00 90 <2e> 66 83 3e 30 6c 00 0f 85 e7 f2 31 c0 8e d0 66 bc 00 70 00 00 66 ba 31 2e 0f 00 e9 45 f1

This is with QEMU emulator version 2.1.2 (Debian 1:2.1+dfsg-11),
Copyright (c) 2003-2008 Fabrice Bellard

The host system is:

cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
stepping        : 10
microcode       : 0xa0b
...
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm dtherm tpr_shadow vnmi flexpriority

I bisected this back to:

commit 34a1cd60d17f62c1f077c1478a6c2ca8c3d17af4
Author: Tiejun Chen <tiejun.chen@intel.com>
Date:   Tue Oct 28 10:14:48 2014 +0800

    kvm: x86: vmx: move some vmx setting from vmx_init() to hardware_setup()
    
    Instead of vmx_init(), actually it would make reasonable sense to do
    anything specific to vmx hardware setting in vmx_x86_ops->hardware_setup().
    
    Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

reverting this commit appears to fix the issue, in so far that I can
run kvm again without the aforementioned error, but I haven't tested
it thoroughly beyond that.  Let me know if you need more information
or testing.

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
