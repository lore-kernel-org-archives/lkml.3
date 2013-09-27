Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3I0QTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:19:16 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52354 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752485Ab3I0QTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:19:12 -0400
Date: Fri, 27 Sep 2013 17:16:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v1 0/7] enable FPSIMD lazy save and restore for
 arm64
Message-ID: <20130927161622.GH26069@arm.com>
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
 <20130927105045.GA11063@MacBook-Pro.local>
 <20130927112332.GD9520@mudshark.cambridge.arm.com>
 <5245A22F.7020305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245A22F.7020305@gmail.com>
Thread-Topic: [RFT PATCH v1 0/7] enable FPSIMD lazy save and restore for
 arm64
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 04:20:15PM +0100, Jiang Liu wrote:
> 	The patchset actually includes three optimizations.
> 
> The first one uses PF_USED_MATH to track whether the thread has
> accessed FPSIMD registers since it has been created. If the thread
> hasn't accessed FPSIMD registers since it's birth, we don't need to
> save and restore FPSIMD context on thread context switching.

But for detecting whether a thread used the FP/SIMD registers, you need
to disable the FP at context switch and trap the initial access. That's
one of the main issues with lazy saving/restoring and sometimes it could
be less efficient.

> The second one uses a percpu variable to track the owner of the
> FPSIMD hardware. When switching a thread, if it's the owner of
> the FPSIMD hardware, we don't need to load FPSIMD registers again.
> This is useful when context switching between user thread and
> kernel(idle) threads.

fpsimd_thread_switch() checks whether it switches to/from kernel thread.
I think we could do a bit better and avoid restoring if returning to the
same user thread but without the need for disabling the FP on thread
switch. I'm happy to take this part if factored out of the lazy patches
(for the rest I'd like to see benchmarks).

> The third one disable access to FPSIMD registers when switching a
> thread. When the thread tries to access FPSIMD registers the first
> time since it has been switched in, an exception is raised and then
> we will load FPSIMD context onto hardware.
> 
> The overhead (penalty) of the first and second optimizations is
> relatively small, so we could always enable them.

How do you detect that a thread used fpsimd?

-- 
Catalin
