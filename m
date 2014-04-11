Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbaDKNvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:51:51 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.6]:57095 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755478AbaDKNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:51:47 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-14.tower-28.messagelabs.com!1397224299!28266902!11
X-Originating-IP: [192.61.61.104]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 11 Apr 2014 08:51:29 -0500
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Thread-Topic: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Thread-Index: Ac9VjSP/MBDV1KcZQ1+SeXCHt28gRQ==
Message-ID: <C97001BC43954D438ACB059713BA5CDF92040F0F10@USEA-EXCH7.na.uis.unisys.com>
References: <20140407111725.GC25152@localhost>
 <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com>
 <53444220.50009@intel.com>
 <C97001BC43954D438ACB059713BA5CDF92040F0F06@USEA-EXCH7.na.uis.unisys.com>
 <53458A3A.1050608@intel.com> <20140409230114.GB8370@localhost>
 <5345D360.5000506@linux.intel.com>
 <C97001BC43954D438ACB059713BA5CDF92040F0F0A@USEA-EXCH7.na.uis.unisys.com>
 <53475344.5090009@linux.intel.com>
In-Reply-To: <53475344.5090009@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3BDpvLA003559

On Thu, 2014-04-10 at 19:28 -0700, H. Peter Anvin wrote:
> On 04/10/2014 06:19 AM, Romer, Benjamin M wrote:
> > 
> > I'm confused by the intended behavior of KVM.. Is the intention of the
> > -cpu switch to fully emulate a particular CPU? If that's the case, the
> > Intel documentation says bit 31 should always be 0, so the value
> > returned by the cpuid instruction isn't correct. If the intention is to
> > present a VM with a specific CPU architecture, the CPU ought to behave
> > as described in Intel's virtualization documentation and just vmexit
> > instead of faulting with invalid op, IMHO. 
> > 
> > I've already said the check in the code was insufficient, and I'm trying
> > to fix that part now. :)
> > 
> 
> I'm still confused where KVM comes into the picture.  Are you actually
> using KVM (and thus talking about nested virtualization) or are you
> using Qemu in JIT mode and running another hypervisor underneath?

The test that Fengguang used to find the problem was running the linux
kernel directly using KVM. When the kernel was run with "-cpu Haswell,
+smep,+smap" set, the vmcall failed with invalid op, but when the kernel
is run with "-cpu qemu64", the vmcall causes a vmexit, as it should.

My point is, the vmcall was made because the hypervisor bit was set. If
this bit had been turned off, as it would be on a real processor, the
vmcall wouldn't have happened.

> The hypervisor bit is a complete red herring. If the guest CPU is
> running in VT-x mode, then VMCALL should VMEXIT inside the guest
> (invoking the guest root VT-x), 

The CPU is running in VT-X. That was my point, the kernel is running in
the KVM guest, and KVM is setting the CPU feature bits such that bit 31
is enabled.

I don't think it's a red herring because the kernel uses this bit
elsewhere - it is reported as X86_FEATURE_HYPERVISOR in the CPU
features, and can be checked with the cpu_has_hypervisor macro (which
was not used by the original author of the code in the driver, but
should have been). VMWare and KVM support in the kernel also check for
this bit before checking their hypervisor leaves for an ID. If it's not
properly set it affects more than just the s-Par drivers.

> but the fact still remains that you
> should never, ever, invoke VMCALL unless you know what hypervisor you
> have underneath.

>From the standpoint of the s-Par drivers, yes, I agree (as I already
said). However, VMCALL is not a privileged instruction, so anyone could
use it from user space and go right past the OS straight to the
hypervisor. IMHO, making it *lethal* to the guest is a bad idea, since
any user could hard-stop the guest with a couple of lines of C.

-- Ben
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
