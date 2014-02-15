Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaBOJ66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 04:58:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33305 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaBOJ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 04:58:56 -0500
Date: Sat, 15 Feb 2014 10:58:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, eranian@google.com, linux-kernel@vger.kernel.org,
        Markus Metzger <markus.t.metzger@intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, nmi: fix unknown NMI warning
Message-ID: <20140215095843.GJ14089@laptop.programming.kicks-ass.net>
References: <1392425048-5309-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392425048-5309-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 04:44:08PM -0800, Andi Kleen wrote:
> 
> Make intel_pmu_handle_irq() take the full exit path when returning early.

This reminds me of the late-ack stuff;

The way I understand interrupts to work is that when you raise the
interrupt it gets latched, when you ACK you drop the latch. Then when it
gets re-raised while its still in progress, it gets latched again and
the irq-enable at the end of the running handler will get it to trigger
again.

So by late-ACK-ing the PMI we can miss PMIs that happen between enabling
the PMU and ACKing the PMI.

We should either re-check the overflow mask after the ACK or do the ACK
while the PMU is disabled.
