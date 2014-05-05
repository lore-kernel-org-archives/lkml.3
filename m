Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbaEEL3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:29:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbaEEL3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:29:18 -0400
Message-ID: <536775ED.3070502@redhat.com>
Date: Mon, 05 May 2014 07:28:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>, umgwanakikbuti@gmail.com,
        Peter Zijlstra <peterz@infradead.org>
CC: Preeti Murthy <preeti.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, george.mccollister@gmail.com,
        ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
References: <20140502004237.79dd3de6@annuminas.surriel.com> <1399011219.5233.55.camel@marge.simpson.net>	<53633B81.1080403@redhat.com> <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com> <53663565.9080306@redhat.com> <5367188C.1060702@linux.vnet.ibm.com>
In-Reply-To: <5367188C.1060702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 12:50 AM, Preeti U Murthy wrote:

> Yeah now I see it. But I still feel wake_affine() and
> select_idle_sibling() are not at fault primarily because when they were
> introduced, I don't think it was foreseen that the cpu topology would
> grow to the extent it is now.

It's not about "fault", it is about the fact that on current
large NUMA systems they are broken, and could stand some
improvement :)

> select_idle_sibling() for instance scans the cpus within the purview of
> the last level cache of a cpu and this was a small set. Hence there was
> no overhead. Now with many cpus sharing the L3 cache, we see an
> overhead. wake_affine() probably did not expect the NUMA nodes to come
> under its governance as well and hence it sees no harm in waking up
> tasks close to the waker because it still believes that it will be
> within a node.

If two tasks truly are related to each other, I think we
will want to have the wake_affine logic pull them towards
each other, all the way across a giant NUMA system if
needs be.

The problem is that the current wake_affine logic starts
in the ON position, and only switches off in a few very
specific scenarios.

I suspect we would be better off with the reverse, starting
with wake_affine in the off position, and switching it on
when we detect it makes sense to do so.

-- 
All rights reversed
