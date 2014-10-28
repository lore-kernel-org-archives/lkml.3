Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaJ1Jtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:49:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58474 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbaJ1Jt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:49:26 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-75-544f66a42b65
Message-id: <544F66A2.1080302@samsung.com>
Date: Tue, 28 Oct 2014 10:49:22 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>, mgorman@suse.de, mina86@mina86.com
Cc: linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        pratikp@codeaurora.org
Subject: Re: Deadlock with CMA and CPU hotplug
References: <5447E210.8020902@codeaurora.org>
In-reply-to: <5447E210.8020902@codeaurora.org>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xq7pL0vxDDPp3c1hs75zBbnF51xw2
	i3tr/rNaTH73jNFiwfEWVovV/04xWhzvPcBk8e2+uQOHx+W+XiaPzSu0PDat6mTz2PRpErvH
	uj+vgEKnqz0+b5ILYI/isklJzcksSy3St0vgyrh1p5WtYBdvxa3d51kaGL9ydjFyckgImEhc
	+NjCBGGLSVy4t56ti5GLQ0hgKaPE/yPXoJxPjBKdNxezglTxCmhJrFz7hR3EZhFQlfi+tp0N
	xGYTMJToetsFZosKxEjc37maDaJeUOLH5HssXYwcHCICPhJH+z1AZjILTGeUWHJhISNIjbCA
	nsSG7glgVwgJ6Er8ev6UHaSeEyje2OYEEmYWMJP48vIwK4QtL7F5zVvmCYwCs5BsmIWkbBaS
	sgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQoL/yw7GxcesDjEKcDAq8fDumOYbIsSa
	WFZcmXuIUYKDWUmENyLGP0SINyWxsiq1KD++qDQntfgQIxMHp1QDY0zJtS8Lfdy8bDf9PtKl
	WexlcXTP08av3NEPahYe+VGy5+3DqL07nsvnTjoyIXDvfwZ2B5fraSeDJpS/Wt182a9AwVQv
	0c5TXvDN7RjFJ6Vf10zfWCK18VTPHm3BtMqKEN96q/OsHyfuzu+/ExVkacvWPvPmpG7DTRHJ
	5y6rfmUpc3l0V3SSjRJLcUaioRZzUXEiAFjUxu1cAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-10-22 18:57, Laura Abbott wrote:
> We've run into a AB/BA deadlock situation involving a driver lock and
> the CPU hotplug lock on a 3.10 based kernel. The situation is this:
>
> CPU 0                CPU 1
> -----                ----
> Start CPU hotplug
> mutex_lock(&cpu_hotplug.lock)
> Run CPU hotplug notifier
>                 data for driver comes in
>                 mutex_lock(&driver_lock)
>                 driver calls dma_alloc_coherent
>                 alloc_contig_range
>                 lru_add_drain_all
>                 get_online_cpus()
>                 mutex_lock(&cpu_hotplug.lock)
>
> Driver hotplug notifier runs
> mutex_lock(&driver_lock)
>
> The driver itself is out of tree right now[1] and we're looking at
> ways to rework the driver. The best option for rework right now
> though might result in some performance penalties. The size that's
> being allocated can't easily be converted to an atomic allocation either
> It seems like this might be a limitation of where CMA/
> dma_alloc_coherent could potentially be used and make drivers
> unnecessarily aware of CPU hotplug locking.
>
> Does this seem like an actual problem that needs to be fixed or
> is trying to use CMA in a CPU hotplug notifier path just asking
> for trouble?

IMHO doing any allocation without GFP_ATOMIC from a notifier is asking
for problems. I always considered notifiers as callbacks that might be 
called
directly from i.e. interrupts. I don't know much about your code, but 
maybe it
would be possible to move the problematic code from a notifier to a separate
worker or thread?

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

