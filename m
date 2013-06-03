Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3FCVeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:34:15 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:55177 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab3FCVeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:34:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130603183018.GJ15576@cmpxchg.org>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz> <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz> <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz> <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
 <20130601061151.GC15576@cmpxchg.org> <20130603153432.GC18588@dhcp22.suse.cz>
 <20130603164839.GG15576@cmpxchg.org> <20130603183018.GJ15576@cmpxchg.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 3 Jun 2013 17:33:40 -0400
Message-ID: <CAHGf_=rFhhRM3CqmSJEFrYMFafUzOU7WHvwQrguXOFwbKbbDLQ@mail.gmail.com>
Subject: Re: [patch] mm, memcg: add oom killer delay
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [PATCH] memcg: do not sleep on OOM waitqueue with full charge context
>
> The memcg OOM handling is incredibly fragile because once a memcg goes
> OOM, one task (kernel or userspace) is responsible for resolving the
> situation.  Every other task that gets caught trying to charge memory
> gets stuck in a waitqueue while potentially holding various filesystem
> and mm locks on which the OOM handling task may now deadlock.
>
> Do two things:
>
> 1. When OOMing in a system call (buffered IO and friends), invoke the
>    OOM killer but do not trap other tasks and just return -ENOMEM for
>    everyone.  Userspace should be able to handle this... right?
>
> 2. When OOMing in a page fault, invoke the OOM killer but do not trap
>    other chargers directly in the charging code.  Instead, remember
>    the OOMing memcg in the task struct and then fully unwind the page
>    fault stack first.  Then synchronize the memcg OOM from
>    pagefault_out_of_memory().
>
> While reworking the OOM routine, also remove a needless OOM waitqueue
> wakeup when invoking the killer.  Only uncharges and limit increases,
> things that actually change the memory situation, should do wakeups.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

>From point of the memcg oom notification view, it is NOT supported on the case
that an oom handler process is subjected its own memcg limit. All
memcg developers
clearly agreed it since it began. Even though, anyway, people have a
right to shoot their own foot. :)
However, this patch fixes more than that. OK, I prefer it. Good fix!

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
