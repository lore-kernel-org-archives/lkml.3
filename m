Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003Ab3DBIKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:10:23 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39825
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760605Ab3DBIKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:10:21 -0400
Message-ID: <1364890206.16858.6.camel@laptop>
Subject: Re: [PATCH 2/5] sched: factor out code to should_we_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Tue, 02 Apr 2013 10:10:06 +0200
In-Reply-To: <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 16:58 +0900, Joonsoo Kim wrote:
> Now checking that this cpu is appropriate to balance is embedded into
> update_sg_lb_stats() and this checking has no direct relationship to
> this
> function.
> 
> There is not enough reason to place this checking at
> update_sg_lb_stats(),
> except saving one iteration for sched_group_cpus.

Its only one iteration if there's only 2 groups, but there can be more
than 2, take any desktop Intel i7, it will have 4-8 cores, each with
HT; thus the CPU domain will have 4-8 groups.

And note that local_group is always the first group of a domain, so
we'd stop the balance at the first group and avoid touching the other
3-7, avoiding touching cachelines on 6-14 cpus.

So this short-cut does make sense.. its not pretty, granted, but
killing it doesn't seem right.

