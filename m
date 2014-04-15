Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855AbaDOICh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:02:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46508 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbaDOICc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:02:32 -0400
Date: Tue, 15 Apr 2014 09:02:17 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Sukie Peng <Sukie.Peng@arm.com>,
        "huxinwei@huawei.com" <huxinwei@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Flush the process's mm context TLB entries when
 switching
Message-ID: <20140415080217.GD17408@arm.com>
References: <534BCE80.3090406@huawei.com>
 <20140414130154.GE3530@arm.com>
 <534C92B8.30408@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534C92B8.30408@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:00:24AM +0100, Ding Tianhong wrote:
> On 2014/4/14 21:01, Will Deacon wrote:
> > Hi Ding,
> > 
> > On Mon, Apr 14, 2014 at 01:03:12PM +0100, Ding Tianhong wrote:
> >> I met a problem when migrating process by following steps:
> >>
> >> 1) The process was already running on core 0.
> >> 2) Set the CPU affinity of the process to 0x02 and move it to core 1,
> >>    it could work well.
> >> 3) Set the CPU affinity of the process to 0x01 and move it to core 0 again,
> >>    the problem occurs and the process was killed.
> > 
> > [...]
> > 
> >> It was a very strange problem that the PC and LR are both 0, and the esr is
> >> 0x83000006, it means that the used for instruction access generated MMU faults
> >> and synchronous external aborts, including synchronous parity errors.
> >>
> >> I try to fix the problem by invalidating the process's TLB entries when switching,
> >> it will make the context stale and pick new one, and then it could work well.
> >>
> >> So I think in some situation that after the process switching, the modification of
> >> the TLB entries in the new core didn't inform all other cores to invalidate the old
> >> TLB entries which was in the inner shareable caches, and then if the process schedule
> >> to another core, the old TLB entries may occur MMU faults.
> > 
> > Yes, it sounds like you don't have your TLBs configured correctly. Can you
> > confirm that your EL3 firmware is configuring TLB broadcasting correctly
> > please?
> > 
> 
> Hi will:
> 
> Do you mean the SCR_EL3.NS?

No, there's usually a CPU-specific register (called something like actlr or
ectlr) which contains bit(s) to enable TLB broadcasting in hardware. Which
CPU are you using?

Will
