Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaBPTTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:19:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50421 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaBPTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:19:15 -0500
Date: Sun, 16 Feb 2014 20:19:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
Message-ID: <20140216191909.GL14089@laptop.programming.kicks-ass.net>
References: <52FFF7F8.2070801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FFF7F8.2070801@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 06:27:52PM -0500, Sasha Levin wrote:
> Hi folks,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel, I've
> stumbled on the following:
> 
> [  522.645288] BUG: unable to handle kernel NULL pointer dereference at 0000000000000150
> [  522.646271] IP: [<ffffffff81186c6f>] check_preempt_wakeup+0x11f/0x210
> 
> Since it's pretty inlined, the code points to:
> 
> 	check_preempt_wakeup()
> 		find_matching_se()
> 			find_matching_se()
> 				check_preempt_wakeup()
> 
> 
> 	static inline struct cfs_rq *
> 	is_same_group(struct sched_entity *se, struct sched_entity *pse)
> 	{
> 	        if (se->cfs_rq == pse->cfs_rq)	<=== HERE
> 	                return se->cfs_rq;
> 	
> 	        return NULL;
> 	}

Hrm.. that means we got se->depth wrong. I'll have a poke tomorrow.
