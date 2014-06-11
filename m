Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaFKPSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:18:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbaFKPSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:18:10 -0400
Date: Wed, 11 Jun 2014 17:16:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wait: Introduce per-task wait_queue_t
Message-ID: <20140611151647.GA21158@redhat.com>
References: <CA+55aFyYQES1CbEfYzRkFas_aw=+YNSbDoLRJpjh2sDFxVV3vg@mail.gmail.com> <1402403359-6023-1-git-send-email-linux@rasmusvillemoes.dk> <1402403359-6023-2-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402403359-6023-2-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10, Rasmus Villemoes wrote:
>
> This introduces a single wait_queue_t into the task structure.
> Functions which need to wait, but which do not call other functions
> that might wait while on the wait queue, may use current->__wq

I am not going to argue, but I am not sure that wait_event() (changed
by the next patch) meets this criteria...

wait_event(wq, something_nontrivial_which_uses_wait_event_too()) is
legal currently although perhaps nobody does this.

> +static inline wait_queue_t *current_wq_get(void)
> +{
> +	wait_queue_t *wq = &current->__wq;
> +	BUG_ON(wq->flags != WQ_FLAG_AVAILABLE);
> +	wq->flags = 0;
> +	return wq;
> +}
> +static inline void current_wq_put(wait_queue_t *wq)
> +{
> +	BUG_ON(wq != &current->__wq);
> +	wq->flags = WQ_FLAG_AVAILABLE;
> +}

Or, perhaps, current_wq_get() can simply check list_empty(->task_list)
initialized by copy_process().

This way you do not need current_wq_put(), WQ_FLAG_AVAILABLE, and you
can kill INIT_LIST_HEAD() in ___wait_event().

Honestly, I am not sure about this patch... sizeof(wait_queue_t) is not
that large, and otoh it is not good to have yet another "rarely used"
member in the already huge task_struct. But again, I won't insist.

Oleg.

