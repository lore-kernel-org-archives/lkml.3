Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaJVQ54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:57:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52392 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaJVQ5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:57:55 -0400
Message-ID: <5447E210.8020902@codeaurora.org>
Date: Wed, 22 Oct 2014 09:57:52 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: mgorman@suse.de, m.szyprowski@samsung.com, mina86@mina86.com
CC: linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        pratikp@codeaurora.org
Subject: Deadlock with CMA and CPU hotplug
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've run into a AB/BA deadlock situation involving a driver lock and
the CPU hotplug lock on a 3.10 based kernel. The situation is this:

CPU 0				CPU 1
-----				----
Start CPU hotplug
mutex_lock(&cpu_hotplug.lock)
Run CPU hotplug notifier
				data for driver comes in
				mutex_lock(&driver_lock)
				driver calls dma_alloc_coherent
				alloc_contig_range
				lru_add_drain_all
				get_online_cpus()
				mutex_lock(&cpu_hotplug.lock)

Driver hotplug notifier runs
mutex_lock(&driver_lock)

The driver itself is out of tree right now[1] and we're looking at
ways to rework the driver. The best option for rework right now
though might result in some performance penalties. The size that's
being allocated can't easily be converted to an atomic allocation either
It seems like this might be a limitation of where CMA/
dma_alloc_coherent could potentially be used and make drivers
unnecessarily aware of CPU hotplug locking.

Does this seem like an actual problem that needs to be fixed or
is trying to use CMA in a CPU hotplug notifier path just asking
for trouble?

Thanks,
Laura

[1] For reference, the driver is a version of
https://lkml.org/lkml/2014/10/7/495 although that particular
posted version allocates memory at probe instead of runtime
and probably doesn't have the deadlock.

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
