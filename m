Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3FNPR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:17:29 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:52176 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081Ab3FNPR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:17:26 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <51BB33FE.1020403@yandex-team.ru>
Date: Fri, 14 Jun 2013 19:17:18 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org,
        mgorman@suse.de, rientjes@google.com, glommer@parallels.com,
        hannes@cmpxchg.org, minchan@kernel.org, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: Avoid direct compaction if possible
References: <51BB1802.8050108@yandex-team.ru> <0000013f4319cb46-a5a3de58-1207-4037-ae39-574b58135ea2-000000@email.amazonses.com>
In-Reply-To: <0000013f4319cb46-a5a3de58-1207-4037-ae39-574b58135ea2-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.06.2013 18:32, Christoph Lameter wrote:
> On Fri, 14 Jun 2013, Roman Gushchin wrote:
>
>> Slub tries to allocate contiguous pages even if memory is fragmented and
>> there are no free contiguous pages. In this case it calls direct compaction
>> to allocate contiguous page. Compaction requires the taking of some heavily
>> contended locks (e.g. zone locks). So, running compaction (direct and using
>> kswapd) simultaneously on several processors can cause serious performance
>> issues.
>
> The main thing that this patch does is to add a nocompact flag to the page
> allocator. That needs to be a separate patch. Also fix the description.
> Slub does not invoke compaction. The page allocator initiates compaction
> under certain conditions.

Ok, I'll do.

>
>> It's possible to avoid such problems (or at least to make them less probable)
>> by avoiding direct compaction. If it's not possible to allocate a contiguous
>> page without compaction, slub will fall back to order 0 page(s). In this case
>> kswapd will be woken to perform asynchronous compaction. So, slub can return
>> to default order allocations as soon as memory will be de-fragmented.
>
> Sounds like a good idea. Do you have some numbers to show the effect of
> this patch?

No.
It seems that any numbers here depend on memory fragmentation,
so it's not easy to make a reproducible measurement. If you have
any ideas here, you are welcome.

But there is an actual problem, that this patch solves.
Sometimes I saw the following issue on some machines:
all CPUs are performing compaction, system time is about 80%,
system is completely unreliable. It occurs only on machines
with specific workload (distributed data storage system, so,
intensive disk i/o is performed). A system can fall into
this state fast and unexpectedly or by progressive degradation.

This patch solves this problem.

Thank you for your comments and suggestions!

Regards,
Roman

