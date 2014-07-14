Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaGNB3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 21:29:41 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42856 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaGNB3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 21:29:36 -0400
Message-ID: <53C33275.1000900@linux.vnet.ibm.com>
Date: Mon, 14 Jul 2014 09:29:25 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com> <20140623094251.GS19860@laptop.programming.kicks-ass.net> <53A8F1DE.2060908@linux.vnet.ibm.com> <20140701082020.GL6758@twins.programming.kicks-ass.net> <53B273A2.5050500@linux.vnet.ibm.com> <53B41B7E.8020009@redhat.com> <1404359462.5137.72.camel@marge.simpson.net> <53C00CC1.1030401@redhat.com>
In-Reply-To: <53C00CC1.1030401@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071401-5564-0000-0000-00000F09AED3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2014 12:11 AM, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
[snip]
>>
>> That's full wake balance.. if that was cheap,
>> select_idle_sibling() would not exist.
> 
> Full wake balance iterates over all the groups in the system,
> select_idle_sibling only over one LLC domain.

Furthermore, balance will calculate the load and do comparison, which
cost many cycles, while select_idle_sibling() just check idle status.

> 
> If no CPU in the LLC domain is idle, select_idle_sibling will
> iterate over all of them.  

Just the first cpu of groups, for example the cpu0:

sd1:
	tg0			tg1
	cpu0	cpu1		cpu2	cpu3
sd0:
	tg0	tg1
	cpu0	cpu1

The thing we'll check is:

sd1:
	idle_cpu(0)	//busy
	idle_cpu(2)	//busy
sd0:
	idle_cpu(0)	//busy

That's really cheap compared with balance path...

During this iteration, which the
> code already does, it should be possible to identify the least
> loaded of the CPUs and pick that one.

That will make select_idle_sibling() more close to balance path(just the
start domain lower), IMHO this seems like not such a good idea... what
we gain doesn't worth the overhead.

But if we have testing show this modify could benefit most of the
workloads (I don't think so but who knows...), then we'll have the
reason to add some load comparison logical inside that quick path ;-)

Regards,
Michael Wang

> 
> - -- 
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBAgAGBQJTwAzBAAoJEM553pKExN6DlrEH/RKQPdAdMFK/pxZ/2f9TCXFK
> Vq25LWZeJQhNOrH3Q6VzTTfAG06O8+Bjxfb+SR6BOHCtD4kCBqaBdwVVUDXC+MbK
> NdBa3GtCT3ahvguiYLPEHL1vugND2yzHUgnr9EhUgk6zhnLxfvhIIJj7uv+ZRsri
> o8DsLrIG1jqDGVbbu5ssZ37w6cldoFBw0FAHcVAquoM2SP+/MuatW1SCkRP31IVL
> q0dssP1CD0Nkecz+S6WSI59c0Wt0c73oWNg/q41a/kha7RI1J5VF5yNFacq/uL0g
> Xxyb0mOiJarqMtzuq5ItlOiTry+BpqY1jFhN5ZhFjt9mtvpTR1C/tcXpOw77y0Y=
> =BEJk
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

