Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3DZMbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:31:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33305
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab3DZMbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:31:42 -0400
Date: Fri, 26 Apr 2013 14:30:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net, l.majewski@samsung.com
Subject: Re: [PATCH 03/14] sched: pack small tasks
Message-ID: <20130426123002.GA13464@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
 <1366910611-20048-4-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910611-20048-4-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:23:19PM +0200, Vincent Guittot wrote:
> During the creation of sched_domain, we define a pack buddy CPU for each CPU
> when one is available. We want to pack at all levels where a group of CPUs can
> be power gated independently from others.
> On a system that can't power gate a group of CPUs independently, the flag is
> set at all sched_domain level and the buddy is set to -1. This is the default
> behavior.
> 
> On a dual clusters / dual cores system which can power gate each core and
> cluster independently, the buddy configuration will be :
> 
>       | Cluster 0   | Cluster 1   |
>       | CPU0 | CPU1 | CPU2 | CPU3 |
> -----------------------------------
> buddy | CPU0 | CPU0 | CPU0 | CPU2 |
> 
> If the cores in a cluster can't be power gated independently, the buddy
> configuration becomes:
> 
>       | Cluster 0   | Cluster 1   |
>       | CPU0 | CPU1 | CPU2 | CPU3 |
> -----------------------------------
> buddy | CPU0 | CPU1 | CPU0 | CPU0 |
> 
> Small tasks tend to slip out of the periodic load balance so the best place
> to choose to migrate them is during their wake up. The decision is in O(1) as
> we only check again one buddy CPU


So I really don't get the point of this buddy stuff, even for light load non
performance impact stuff you want to do.

The moment you judge cpu0 busy you'll bail, even though its perfectly doable
(and desirable afaict) to continue stacking light tasks on cpu1 instead of
waking up cpu2/3.

So what's wrong with keeping a single light-wake target cpu selection and
updating it appropriately?

Also where/how does the nohz balance cpu criteria not match the light-wake
target criteria?
