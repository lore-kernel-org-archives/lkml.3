Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbaFYKUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:20:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbaFYKUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:20:05 -0400
Date: Wed, 25 Jun 2014 11:19:54 +0100
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, peterz@infradead.com,
        mingo@kernel.org
Subject: Re: [PATCH 7/7] sched,numa: change scan period code to match intent
Message-ID: <20140625101954.GY10819@suse.de>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
 <1403538095-31256-8-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1403538095-31256-8-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 11:41:35AM -0400, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Reading through the scan period code and comment, it appears the
> intent was to slow down NUMA scanning when a majority of accesses
> are on the local node, specifically a local:remote ratio of 3:1.
> 
> However, the code actually tests local / (local + remote), and
> the actual cut-off point was around 30% local accesses, well before
> a task has actually converged on a node.
> 
> Changing the threshold to 7 means scanning slows down when a task
> has around 70% of its accesses local, which appears to match the
> intent of the code more closely.
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Rik van Riel <riel@redhat.com>

The threshold is indeed very low and was selected to favour slowing
down scanning over convergence time. This was with the intent that we
should never perform worse than disabling NUMA balancing -- an aim that
has mixed results with recent Java-based workloads. With slower scanning,
we converge eventually so for long-lived workloads we're ok.  On the other
hand if scan rate is continually high and we're not converging then system
overhead stays consistently high. I considered the slow convergence to be
the lesser of two possible evils.

At the time of writing there were basic workloads that were only seeing about
20-30% locality hence that threshold. Since then, things have changed that
may affect that decision -- pseudo-interleaving was introduced for example.

I've no problem with the patch because it could do with re-evaluation in
the context of the other recent changes so

Acked-by: Mel Gorman <mgorman@suse.de>

Watch for consistently high scanning activity or high system CPU usage and
if either is reported it's worth looking to see if that 70% threshold is
ever been reached.

-- 
Mel Gorman
SUSE Labs
