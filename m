Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3CMDIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 23:08:01 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45028 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab3CMDIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 23:08:00 -0400
Message-ID: <513FED85.8030603@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 11:07:49 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362677252.10972.26.camel@laptop> <5139520C.1060109@linux.vnet.ibm.com> <1362998219.14933.9.camel@laptop> <513E9FC6.4060507@linux.vnet.ibm.com> <1363082932.14933.19.camel@laptop>
In-Reply-To: <1363082932.14933.19.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031303-7014-0000-0000-000002B512DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 06:08 PM, Peter Zijlstra wrote:
> Does something simple like a per-task throttle of wake_affine() gain
> similar benefits? Say something like only do wake_affine() once every
> 10 ms or so (counting on the wakee, not waker).
> 
> The rationale being that wake_affine() relies on load-balance
> statistics that aren't updated that much faster, so calling it more
> often than that seems pointless.

That could works, if we do not have any logical to rely on and just want
to limit the rate of pull, this could be a good solution.

However, we already figure out the logical that wakeup related task
could benefit from closely running, this could promise us somewhat
reliable benefit.

It's just like, tell me how many times that two task continuously wakeup
each other means they related, I will try to pull them together since
they have a big chance to benefit from cache.

IMHO, that sounds a little easier for users than to make the decision on
tell me how long to pull tasks together, they may be confused...

In summary, I think we have two point here need to be considered:

1. what about the missed optimize timing, that may benefit
   some workload (although we haven't found such workload yet).

2. how many benefit could wake_affine() stuff bring to us,
   if limit rate benefit us, why don't we remove it?

Point 1 could be solved by disable wakeup buddy with 0 limitation, and
when users complain about their database performance, we just say "Calm
down and take a try on this knob ;-)".

Point 2 is about the wake_affine() stuff itself.

Later we could try to make the stuff better, but I have the feeling that
some key info is not there (may be we need Ingo's work atom idea here,
just wondering...), whatever, I think we still need a knob finally,
since it doesn't sounds like a general optimization which benefit all
the cases.

And I don't agree to remove the stuff since we have many theories that
this could benefit us, but before it really show the benefit in all the
cases, provide a way to keep it quiet sounds necessary...

Regards,
Michael Wang

> 
> Something like that should take a lot less lines to implement.
> 
> Just wondering..
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

