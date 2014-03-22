Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaCVTD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 15:03:56 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60154 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaCVTDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 15:03:53 -0400
Date: Sat, 22 Mar 2014 14:27:59 +0200
From: Gleb Natapov <gleb@kernel.org>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Venkatesh Srinivas <venkateshs@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Message-ID: <20140322122758.GA4292@minantech.com>
References: <4055058.qLAukpngnj@al>
 <CAHdzE-88ZPTs_QvVLZsHs=O6TNKG61+iLH+ctGKLMdG5h6G0sg@mail.gmail.com>
 <20140322085045.GA5535@minantech.com>
 <1558917.OgpeoK0IhF@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558917.OgpeoK0IhF@al>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 11:05:03AM +0100, Peter Wu wrote:
> On Saturday 22 March 2014 10:50:45 Gleb Natapov wrote:
> > On Fri, Mar 21, 2014 at 12:04:32PM -0700, Venkatesh Srinivas wrote:
> > > On Fri, Mar 21, 2014 at 10:46 AM, Peter Wu <peter@lekensteyn.nl> wrote:
> > [skip]
> > 
> > > When -cpu host is used, qemu/kvm passed the host CPUID F/M/S to the
> > > guest. intel_pmu_cpu_*() -> intel_pmu_lbr_reset() uses rdmsr() /
> > > wrmsr(), rather than the safe variants; if KVM does not support the
> > > particular MSRs in question, you will see a #GP(0) there. See
> > > https://lkml.org/lkml/2014/3/13/453 for a similar bug other PMU code.
> > > 
> > When kernel is compiled with guest support all rdmsr()/wrmsr() become _safe(),
> > so the question for Peter is if his guest kernel has guest support enabled?
> 
> Linux guest support (CONFIG_HYPERVISOR_GUEST) was not enabled, see
> .config in the first mail[1]. Enabling that option does not change the
> situation.
> 
> With CONFIG_PARAVIRT and CONFIG_KVM_GUEST enabled, the PMU GPF is gone,
Yeah, it should be PARAVIRT indeed since rdmsr()/wrmsr() is substituted by _safe()
using paravirt calls.

> but now I have a NULL dereference (in rapl_pmu_init). Previously, when
> `-cpu SandyBridge` was passed to qemu, it would show this:
> 
>     [    0.016995] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
> 
> The same NULL pointer deref would be visible (slightly different
> addresses, but the Code lines are equal). With `-host`, the NULL deref
> with `-cpu host` contains:
> 
>     [    0.016445] Performance Events: 16-deep LBR, IvyBridge events, Intel PMU driver.
> 
> Full dmesg below.
> 
I am confused. Do you see crash now with -cpu SandyBridge and -cpu host, or -cpu host only?

--
			Gleb.
