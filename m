Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab3HTJoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:44:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5935 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3HTJoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:44:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,919,1367942400"; 
   d="scan'208";a="8250140"
Message-ID: <52133B51.3020007@cn.fujitsu.com>
Date: Tue, 20 Aug 2013 17:48:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 8/9] rcu: Simplify _rcu_barrier() processing
References: <20130820024148.GA30283@linux.vnet.ibm.com> <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com> <1376966534-30775-8-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1376966534-30775-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 17:41:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 17:42:05,
	Serialize complete at 2013/08/20 17:42:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:42 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit drops an unneeded ACCESS_ONCE() and simplifies an "our work
> is done" check in _rcu_barrier().  This applies feedback from Linus
> (https://lkml.org/lkml/2013/7/26/777) that he gave to similar code
> in an unrelated patch.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  kernel/rcutree.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index c6a064a..612aff1 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2817,9 +2817,20 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	 * transition.  The "if" expression below therefore rounds the old
>  	 * value up to the next even number and adds two before comparing.
>  	 */
> -	snap_done = ACCESS_ONCE(rsp->n_barrier_done);
> +	snap_done = rsp->n_barrier_done;
>  	_rcu_barrier_trace(rsp, "Check", -1, snap_done);
> -	if (ULONG_CMP_GE(snap_done, ((snap + 1) & ~0x1) + 2)) {
> +
> +	/*
> +	 * If the value in snap is odd, we needed to wait for the current
> +	 * rcu_barrier() to complete, then wait for the next one, in other
> +	 * words, we need the value of snap_done to be three larger than
> +	 * the value of snap.  On the other hand, if the value in snap is
> +	 * even, we only had to wait for the next rcu_barrier() to complete,
> +	 * in other words, we need the value of snap_done to be only two
> +	 * greater than the value of snap.  The "(snap + 3) & 0x1" computes

"(snap + 3) & 0x1"
==> "(snap + 3) & ~0x1"

> +	 * this for us (thank you, Linus!).
> +	 */
> +	if (ULONG_CMP_GE(snap_done, (snap + 3) & ~0x1)) {
>  		_rcu_barrier_trace(rsp, "EarlyExit", -1, snap_done);
>  		smp_mb(); /* caller's subsequent code after above check. */
>  		mutex_unlock(&rsp->barrier_mutex);

