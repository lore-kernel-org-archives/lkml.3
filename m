Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaDCTLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:11:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:45206 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbaDCTLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:11:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,789,1389772800"; 
   d="scan'208";a="514312306"
Date: Thu, 3 Apr 2014 12:11:03 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, gnomes@lxorguk.ukuu.org.uk,
        hpa@zytor.com
Subject: Re: Soft lockup regression since kernel 3.13
Message-ID: <20140403191103.GA17226@psi-dev26.jf.intel.com>
References: <20140402232948.GA4725@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402232948.GA4725@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 04:29:48PM -0700, David Cohen wrote:
> Hi,
> 
> I've detected a regression from upstream (using an Intel Merrifield
> device) since 3.13 (still exists in 3.14) which I never had much time
> to start to investigate until now. The symptoms are: the device boots
> and works fine for while until it silently hangs.
> 
> I finally bisected v3.12..v3.13 and found exactly which commit created
> the issue:
> 
> commit f27dde8deef33c9e58027df11ceab2198601d6a6
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Wed Aug 14 14:55:31 2013 +0200
> 
>     sched: Add NEED_RESCHED to the preempt_count

FWIW I did further investigation and made the issue to go away with this
hack:

diff --git a/arch/x86/include/asm/preempt.h
b/arch/x86/include/asm/preempt.h
index c8b051933b1b..41744d99c88f 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -95,7 +95,7 @@ static __always_inline bool
__preempt_count_dec_and_test(void)
  */
   static __always_inline bool should_resched(void)
    {
    -       return unlikely(!__this_cpu_read_4(__preempt_count));
    +       return unlikely(tif_need_resched());
     }
      
       #ifdef CONFIG_PREEMPT
--

I extended part of this patch to x86:

commit ba1f14fbe70965ae0fb1655a5275a62723f65b77
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Nov 28 14:26:41 2013 +0100

    sched: Remove PREEMPT_NEED_RESCHED from generic code
--

Br, David Cohen
