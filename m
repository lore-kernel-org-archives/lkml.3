Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaJNL7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:59:06 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32804 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbaJNL7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:59:04 -0400
Date: Tue, 14 Oct 2014 12:58:55 +0100
From: Steve Capper <steve.capper@linaro.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: Introduce a general RCU get_user_pages_fast.
Message-ID: <20141014115854.GA32351@linaro.org>
References: <1413284274-13521-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413284274-13521-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:27:53PM +0530, Aneesh Kumar K.V wrote:
> get_user_pages_fast attempts to pin user pages by walking the page
> tables directly and avoids taking locks. Thus the walker needs to be
> protected from page table pages being freed from under it, and needs
> to block any THP splits.
> 
> One way to achieve this is to have the walker disable interrupts, and
> rely on IPIs from the TLB flushing code blocking before the page table
> pages are freed.
> 
> On some platforms we have hardware broadcast of TLB invalidations, thus
> the TLB flushing code doesn't necessarily need to broadcast IPIs; and
> spuriously broadcasting IPIs can hurt system performance if done too
> often.
> 
> This problem has been solved on PowerPC and Sparc by batching up page
> table pages belonging to more than one mm_user, then scheduling an
> rcu_sched callback to free the pages. This RCU page table free logic
> has been promoted to core code and is activated when one enables
> HAVE_RCU_TABLE_FREE. Unfortunately, these architectures implement
> their own get_user_pages_fast routines.
> 
> The RCU page table free logic coupled with a an IPI broadcast on THP
> split (which is a rare event), allows one to protect a page table
> walker by merely disabling the interrupts during the walk.
> 
> This patch provides a general RCU implementation of get_user_pages_fast
> that can be used by architectures that perform hardware broadcast of
> TLB invalidations.
> 
> It is based heavily on the PowerPC implementation.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
> 
> NOTE: I kept the description of patch as it is and also retained the documentation.
> I also dropped the tested-by and other SOB, because i was not sure whether they want
> to be blamed for the bugs here. Please feel free to update.

Hi Aneesh,
Thank you for coding this up.

I've compiled and briefly tested this on arm (with and without LPAE),
and arm64. I ran a custom futex on THP tail test, and this passed.
I'll test this a little more aggressively with ltp.

I think Linus has already pulled in the RCU gup I posted, could you
please instead write a patch against?
2667f50 mm: introduce a general RCU get_user_pages_fast()

I had one issue compiling this, pgd_huge was undefined. I think this
is only defined for PowerPC? Could a stub definition of pgd_huge be
added?

Cheers,
-- 
Steve
