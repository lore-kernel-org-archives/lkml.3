Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab3BZRnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:43:11 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:40122 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3BZRnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAKfTPtAq4GWoc8oOaUt17ZePfa4PMq7NvPEZYrqo2cvDpGwsWQ@mail.gmail.com>
References: <1361435356-28466-1-git-send-email-vincent.guittot@linaro.org>
	<20130222123213.GA17948@somewhere.redhat.com>
	<CAKfTPtBgEsEJUD+C55Tad8xi3areARQ4GV8WjTaCjncj8hONEA@mail.gmail.com>
	<CAFTL4hz5OzFGfhsj2bNR+76VrpXCxyDtN6fqC1cYF3zpJpjOTg@mail.gmail.com>
	<CAKfTPtAq4GWoc8oOaUt17ZePfa4PMq7NvPEZYrqo2cvDpGwsWQ@mail.gmail.com>
Date: Tue, 26 Feb 2013 18:43:07 +0100
Message-ID: <CAFTL4hx6BGEotYH4yBH8UYDJYyxLAa56KT0ahAtke97rMKaw=A@mail.gmail.com>
Subject: Re: [PATCH v4] sched: fix init NOHZ_IDLE flag
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org,
        efault@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/26 Vincent Guittot <vincent.guittot@linaro.org>:
> On 26 February 2013 14:16, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> 2013/2/22 Vincent Guittot <vincent.guittot@linaro.org>:
>>> I wanted to avoid having to use the sd pointer for testing NOHZ_IDLE
>>> flag because it occurs each time we go into idle but it seems to be
>>> not easily feasible.
>>> Another solution could be to add a synchronization step between
>>> rcu_assign_pointer(dom 1, NULL) and create new domain to ensure that
>>> all pending access to old sd values, has finished but this will imply
>>> a potential delay in the rebuild  of sched_domain and i'm not sure
>>> that it's acceptable

Ah I see what you meant there. Making a synchronize_rcu() after
setting the dom to NULL, on top of which we could work on preventing
from any concurrent nohz_flag modification. But cpu hotplug seem to
become a bit of a performance sensitive path this day.

Ok I don't like having a per cpu state in struct sched domain but for
now I can't find anything better. So my suggestion is that we do this
and describe well the race, define the issue in the changelog and code
comments and explain how we are solving it. This way at least the
issue is identified and known. Then later, on review or after the
patch is upstream, if somebody with some good taste comes with a
better idea, we consider it.

What do you think?
