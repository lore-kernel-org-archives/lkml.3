Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbaGYPN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:13:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbaGYPN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:13:58 -0400
Message-ID: <53D2740D.9040609@redhat.com>
Date: Fri, 25 Jul 2014 11:13:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a busier
 sd
References: <20140722144559.382c5243@annuminas.surriel.com> <CAKfTPtDdAzZcMA5bJvhyrdH9J1F69jMy5q3w5xc4t+PSKPQ0eA@mail.gmail.com> <53D26383.60707@redhat.com> <CAKfTPtCjw9LTh_LYT=rRs=Q1gS2mVcz9Ef6E7KHLqFhdm8Y8pA@mail.gmail.com>
In-Reply-To: <CAKfTPtCjw9LTh_LYT=rRs=Q1gS2mVcz9Ef6E7KHLqFhdm8Y8pA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/25/2014 11:02 AM, Vincent Guittot wrote:
> On 25 July 2014 16:02, Rik van Riel <riel@redhat.com> wrote: On
> 07/23/2014 03:41 AM, Vincent Guittot wrote:
> 
>>>> Regarding your issue with "perf bench numa mem" that is not
>>>> spread on all nodes, SD_PREFER_SIBLING flag (of DIE level)
>>>> should do the job by reducing the capacity of  "not local
>>>> DIE" group at NUMA level to 1 task during the load balance
>>>> computation. So you should have 1 task per sched_group at
>>>> NUMA level.
>> 
>> Looking at the code some more, it is clear why this does not 
>> happen. If sd->flags & SD_NUMA, then SD_PREFER_SIBLING will never
>> be set.
> 
> I don't have a lot of experience on NUMA system and how their 
> sched_domain topology is described but IIUC, you don't have other 
> sched_domain level than NUMA ones ? otherwise the flag should be 
> present in one of the non NUMA level (SMT, MC or DIE)

The system I am testing on has 3 or 4 sched_domain levels,
one for each HT sibling(?), one for each core, one for
each node/socket, and one parent domain for the whole system.

SD_PREFER_SIBLING should be set at the HT sibling level
and at the core level.

However, it is not set at the levels above that.

That means the SD_PREFER_SIBLING flag does its thing within
each CPU core and between cores on a socket, but not between
NUMA nodes...

>> On a related note, that part of the load balancing code probably 
>> needs to be rewritten to deal with unequal
>> group_capacity_factors anyway.

> AFAICT, sgs->avg_load is weighted by the capacity in
> update_sg_lb_stats

Indeed, I dug into that code after sending the email, and found
that piece of the code just before I read Peter's email pointing
it out to me.

> I'm working on a patchset that get ride of capacity_factor (as 
> mentioned by Peter) and directly uses capacity instead. I should
> send the v4 next week.

I am looking forward to anything that will make this code easier
to follow :)

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT0nQMAAoJEM553pKExN6DeFAIAK7KHHRl+lfWIxiZGRyarYHL
SHJydCA4a9Lkd2D60dULGWY/8ylB8+IMfwv69/jXHZzbxlg7Nu1+da7ZUF3Lx35k
AYxpOhC94eTJvp9KQX2W0nGiDZ0Di7YnWAWdoLsd1kZZDZjd82gtLVh63ossWZlF
hn+YH6E4n0iAe6CZ2PO4QMz7dDYVGzUnKuuQVZKl3DBJWSe6ZvcBhDS4xDT+uUe1
IheA5aQcY8XmAkcXbLs736iBiOCKH6Jts6trJUPaVxw3jkD8lI/CMuMss2dk7RPH
xl3Y8CKridywdtvGN6WrOwzUxVBxaEN1da/VuN7nF4OnoipYApSWwKTBe9wd7rQ=
=AsCN
-----END PGP SIGNATURE-----
