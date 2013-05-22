Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3EVIQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:16:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55039
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486Ab3EVIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:16:08 -0400
Date: Wed, 22 May 2013 10:16:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Subject: Re: [PATCH RFC] sched/rt: preserve global runtime/period ratio in
 do_balance_runtime()
Message-ID: <20130522081601.GP26912@twins.programming.kicks-ass.net>
References: <5FBF8E85CA34454794F0F7ECBA79798F37ADA53CA7@HQMAIL04.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FBF8E85CA34454794F0F7ECBA79798F37ADA53CA7@HQMAIL04.nvidia.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 02:30:09PM -0700, Peter Boonstoppel wrote:
> RT throttling aims to prevent starvation of non-SCHED_FIFO threads
> when a rogue RT thread is hogging the CPU. It does so by piggybacking
> on the rt_bandwidth system and allocating at most rt_runtime per
> rt_period to SCHED_FIFO tasks (e.g. 950ms out of every second,
> allowing 'regular' tasks to run for at least 50ms every second).
> 
> However, when multiple cores are available, rt_bandwidth allows cores
> to borrow rt_runtime from one another. This means that a core with a
> rogue RT thread, consuming 100% CPU cycles, can borrow enough runtime
> from other cores to allow the RT thread to run continuously, with no
> runtime for regular tasks on this core.
> 
> Although regular tasks can get scheduled on other available cores
> (which are guaranteed to have some non-RT runtime avaible, since they
> just lent some RT time to us), tasks that are specifically affined to
> a particular core may not be able to make progress (e.g. workqueues,
> timer functions). This can break e.g. watchdog-like functionality that
> is supposed to kill the rogue RT thread.
> 
> This patch changes do_balance_runtime() in such a way that no core can
> aquire (borrow) more runtime than the globally set rt_runtime /
> rt_period ratio. This guarantees there will always be some non-RT
> runtime available on every individual core.
> 
> Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>

I thought we already had a knob for that; RT_RUNTIME_SHARE. And as Mike
said, we might consider flipping the default on that.
