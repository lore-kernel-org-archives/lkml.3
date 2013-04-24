Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab3DXXYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:24:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37433 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758635Ab3DXXYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:24:19 -0400
X-Sasl-enc: IfGzQKZFRDMzSEybw0Aw2JtSjWJxVQm80bJGPhQL9kBw 1366845858
Date: Wed, 24 Apr 2013 16:24:17 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
Message-ID: <20130424232417.GB9073@kroah.com>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 04:04:53PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The perf LBR code has special code to filter specific
> instructions in software.
> 
> The LBR logs any instruction address, even if IP just faulted.
> This means user space can control any address by just branching
> to a bad address.
> 
> On a modern Intel system the only software filtering needed
> is to include SYSCALL/RETs in PERF_SAMPLE_BRANCH_ANY_CALL/RETURN.
> The hardware call filter only handles short calls, but syscall
> is a far call. So it enables far call logging too, but removes
> any other far calls (like interrupts) by looking at the instruction.
> On older systems some additional software filtering is done too,
> to work a problem that CALLs can be only logged together with
> indirect jumps.
> 
> It currently assumes that any address that looks like a kernel
> address can be safely referenced.
> 
> But that is dangerous if can be controlled by the user:
> - It can be used to crash the kernel
> - It allows to probe any physical address for a small set of values
> (valid call op codes) which is an information leak.
> - It may point to a side effect on read MMIO region
> 
> So we cannot reference kernel addresses safely.
> 
> Possible options:
> 
> I) Disable FAR calls for ANY_CALL/RETURNS.
> This just means syscalls are not logged
> as calls. This also lowers the overhead of call logging.
> This changes semantics slightly.
> This is reasonable on Sandy Bridge and later, but would
> cause additional problems on Nehalem and Westmere with
> their additional filters.
> 
> II) Simple disable any filtering for kernel space.
> This means interrupts in kernel space are reported as calls
> and on Nehalem/Westmere some indirect jumps are reported
> as calls too
> 
> III) Enumerate all the kernel entry points and check.
> Any bad call must have a kernel entry point as to.
> This seemed to fragile to maintain.
> 
> IV) Enumerate all kernel code and check for these ranges.
> Quite complicated, especially with the new kernel code JITs.
> Would also allow to probe for kernel code (defeating randomized kernel)
> 
> This patch implements II: Simply disable software filtering for
> any kernel address, which seemed the best.
> (I) would be also an option and was earlier implemented in
> https://patchwork.kernel.org/patch/2468351/
> (however this patch still leaves Nehalem/Westmere/Atom open to the problem)
> (III) and (IV) appear too complicated and risky.
> 
> Should be applied to applicable stable branches too. The problem
> goes back a long time.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   18 +++++++++++++++---
>  1 files changed, 15 insertions(+), 3 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
