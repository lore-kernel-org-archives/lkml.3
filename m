Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaJQViO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 17:38:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaJQViN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 17:38:13 -0400
Date: Fri, 17 Oct 2014 23:34:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix
	use after free
Message-ID: <20141017213440.GA32576@redhat.com>
References: <1413376300.24793.55.camel@tkhai> <20141015150641.GA2755@redhat.com> <20141015194044.GA4557@redhat.com> <543EEB1F.3040900@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543EEB1F.3040900@yandex.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Kirill Tkhai wrote:
>
> Cool! Elegant fix. We set PF_EXITING in exit_signals(), which is earlier
> than release_task() is called.

OK, thanks, I am sending the patch...

> Shouldn't we use smp_rmb/smp_wmb here?

No, we do not. call_rcu(delayed_put_pid) itself implies the barrier on
all CPUs. IOW, by the time RCU actually calls delayed_put_pid() every
CPU must see all memory changes which were done before call_rcu() was
called. And otoh, all rcu-read-lock critical sections which could miss
PF_EXITING should be already finished.

Oleg.

