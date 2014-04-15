Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaDOM0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:26:18 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:39777 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaDOM0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:26:16 -0400
Date: Tue, 15 Apr 2014 14:25:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] workqueue: allow changing attributions of ordered
 workqueue
Message-ID: <20140415122554.GA2438@localhost.localdomain>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
 <534D02B0.1000801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D02B0.1000801@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 05:58:08PM +0800, Lai Jiangshan wrote:
> From 534f1df8a5a03427b0fc382150fbd34e05648a28 Mon Sep 17 00:00:00 2001
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Tue, 15 Apr 2014 17:52:19 +0800
> Subject: [PATCH] workqueue: allow changing attributions of ordered workqueue
> 
> Allow changing ordered workqueue's cpumask
> Allow changing ordered workqueue's nice value
> Allow registering ordered workqueue to SYSFS
> 
> Still disallow changing ordered workqueue's max_active which breaks ordered guarantee
> Still disallow changing ordered workqueue's no_numa which breaks ordered guarantee
> 
> Changing attributions will introduce new pwqs in a given workqueue, and
> old implement doesn't have any solution to handle multi-pwqs on ordered workqueues,
> so changing attributions for ordered workqueues is disallowed.
> 
> After I investigated several solutions which try to handle multi-pwqs on ordered workqueues,
> I found the solution which reuse max_active are the simplest.
> In this solution, the new introduced pwq's max_active is kept as *ZERO* until it become
> the oldest pwq. Thus only one (the oldest) pwq is active, and ordered is guarantee.
> 
> This solution forces ordered on higher level while the non-reentrancy is also
> forced. so we don't need to queue any work to its previous pool. And we shouldn't
> do it. we must disallow any work repeatedly requeues itself back-to-back
> which keeps the oldest pwq stay and make newest(if have) pwq starvation(non-active for ever).
> 
> Build test only.
> This patch depends on previous patch:
> workqueue: add __WQ_FREEZING and remove POOL_FREEZING
> 
> Frederic:
> 	You can pick this patch to your updated patchset before
> 	TJ apply it.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

So IUUC this is to allow registering ordered workqueue as WQ_SYSFS? But I think
we are going to follow Tejun's suggestion to have a low level cpumask which defines
the limit for all unbound workqueues. This indeed tremendously simplifies everyting.
I'll post the series soon.

But maybe I'm missing other requirements that are fixed by your patch?

Thanks.
