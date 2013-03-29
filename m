Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3C2J6C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 05:58:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57769 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3C2J6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 05:58:00 -0400
Message-ID: <1364551075.5053.82.camel@laptop>
Subject: Re: [PATCH v2 -mm -next] ipc,sem: fix lockdep false positive
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@surriel.com>, Sasha Levin <sasha.levin@oracle.com>,
        torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, lwoodman@redhat.com,
        chegu_vinod@hp.com, Dave Jones <davej@redhat.com>, benisty.e@gmail.com,
        Ingo Molnar <mingo@redhat.com>
Date: Fri, 29 Mar 2013 10:57:55 +0100
In-Reply-To: <CANN689GGwztb=beCNtUU8SJp6sfjn_mNTaHQxezt=ehtxvYBAA@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <5150B1C2.8090607@oracle.com>
	 <20130325163844.042a45ba@annuminas.surriel.com>
	 <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
	 <1364303965.5053.29.camel@laptop>
	 <CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
	 <1364308023.5053.40.camel@laptop> <5151BC78.3030306@surriel.com>
	 <1364373750.5053.54.camel@laptop>
	 <20130328162337.3003ccd4@cuia.bos.redhat.com>
	 <CANN689GGwztb=beCNtUU8SJp6sfjn_mNTaHQxezt=ehtxvYBAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 19:50 -0700, Michel Lespinasse wrote:
> So, there are a few things I don't like about spin_unlock_wait():
> 
> 1- From a lock ordering point of view, it is strictly equivalent to
> taking the lock and then releasing it - and yet, lockdep won't catch
> any deadlocks that involve spin_unlock_wait. (Not your fault here,
> this should be fixed as a separate change in lockdep. I manually
> looked at the lock ordering here and found it safe).

Ooh, I never noticed that, but indeed this shouldn't be hard to cure.

> 2- With the current ticket lock implementation, a stream of lockers
> can starve spin_unlock_wait() forever. Once again, not your fault and
> I suspect this could be fixed - I expect spin_unlock_wait() callers
> actually only want to know that the lock has been passed on, not that
> it actually got to an unlocked state.

I suppose the question is do we want to fix it or have both semantics
and use lock+unlock where appropriate.


