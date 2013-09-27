Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3I0PUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:20:24 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51614 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3I0PUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:20:22 -0400
Message-ID: <5245A22F.7020305@gmail.com>
Date: Fri, 27 Sep 2013 23:20:15 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v1 0/7] enable FPSIMD lazy save and restore for arm64
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com> <20130927105045.GA11063@MacBook-Pro.local> <20130927112332.GD9520@mudshark.cambridge.arm.com>
In-Reply-To: <20130927112332.GD9520@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 07:23 PM, Will Deacon wrote:
> On Fri, Sep 27, 2013 at 11:50:46AM +0100, Catalin Marinas wrote:
>> On Fri, Sep 27, 2013 at 09:04:40AM +0100, Jiang Liu wrote:
>>> From: Jiang Liu <jiang.liu@huawei.com>
>>>
>>> This patchset enables FPSIMD lazy save and restore for ARM64, you could
>>> apply it against v3.12-rc2.
>>>
>>> We have done basic functional tests on ARM fast model, but still lack
>>> of detail performance benchmark on real hardware platforms. We would
>>> appreciate if you could help to test it on really hardware platforms!
>>
>> That's my issue as well, I would like to see some benchmarks before
>> merging such patches.
> 
> Furthermore, with GCC's register allocator starting to use vector registers to
> optimise *integer* code instead of spilling to the stack, it's going to become
> more and more common to tasks to have live FP state at context switch. Lazy
> switching might simply introduce overhead in the form of additional trapping.
> 
> Will
> 
Hi Will,
	The patchset actually includes three optimizations.

The first one uses PF_USED_MATH to track whether the thread has
accessed FPSIMD registers since it has been created. If the thread
hasn't accessed FPSIMD registers since it's birth, we don't need to
save and restore FPSIMD context on thread context switching.

The second one uses a percpu variable to track the owner of the
FPSIMD hardware. When switching a thread, if it's the owner of
the FPSIMD hardware, we don't need to load FPSIMD registers again.
This is useful when context switching between user thread and
kernel(idle) threads.

The third one disable access to FPSIMD registers when switching a
thread. When the thread tries to access FPSIMD registers the first
time since it has been switched in, an exception is raised and then
we will load FPSIMD context onto hardware.

The overhead (penalty) of the first and second optimizations is
relatively small, so we could always enable them. The overhead
of the third one is relatively high and the optimization effect
depends on many factors, such as workload, glibc etc. So we
provide a kernel boot option "eagerfpu" to enable/disable the
third optimization.

So what's your thought about the first and second optimizations?
Should we always enable them? I do need to do some benchmark for
this, but still lack of hardware.

Thanks!
Gerry
