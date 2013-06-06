Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3FFVgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:36:41 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58346 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FFVgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:36:39 -0400
Date: Thu, 6 Jun 2013 14:36:36 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Imre Deak <imre.deak@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] wait: introduce prepare_to_wait_event()
Message-ID: <20130606213636.GJ5045@htj.dyndns.org>
References: <20130606200257.GA23628@redhat.com>
 <20130606200334.GC23628@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606200334.GC23628@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Thu, Jun 06, 2013 at 10:03:34PM +0200, Oleg Nesterov wrote:
> Add the new helper, prepare_to_wait_event() which should only be used
> by wait_event_common/etc.
> 
> prepare_to_wait_event() returns -ERESTARTSYS if signal_pending_state()
> is true, otherwise it calls prepare_to_wait(). This allows to uninline
> the signal-pending checks in wait_event_*.
> 
> Also, it can initialize wait->private/func. We do not care they were
> already initialized, the values are the same. This also shaves a couple
> of insns from the inlined code.
> 
> Unlike the previous change, this patch "reliably" shrinks the size of
> generated code for every wait_event*() call.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Which tree are the patches based on?  I'm getting conflicts on
linus#master, mmotd and next.

Reviewed-by: Tejun Heo <tj@kernel.org>

But a couple nits.

> +int

I don't think we need to keep the unnecessary line break here.  All
other functions in the file don't do it except for the two
prepare_to_wait functions.  No need to give the weirdos more power. :)

> +prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
> +{
> +	if (signal_pending_state(state, current))
> +		return -ERESTARTSYS;
> +
> +	wait->private = current;
> +	wait->func = autoremove_wake_function;
> +	prepare_to_wait(q, wait, state);

I wonder whether it'd be worthwhile to make prepare_to_wait() inline
so that it can be inlined into the above.  I think gcc is smart enough
to emit inline for in-file stuff and then build a proper function for
external references.  No biggie.  Just wondering.

Thanks.

-- 
tejun
