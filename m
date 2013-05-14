Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3ENRhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:37:43 -0400
Received: from 8bytes.org ([85.214.48.195]:52007 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3ENRhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:37:42 -0400
Date: Tue, 14 May 2013 19:37:39 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130514173739.GH24440@8bytes.org>
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
 <20130512182935.GD24440@8bytes.org>
 <20130512205747.GK3648@linux.vnet.ibm.com>
 <20130512213430.GE24440@8bytes.org>
 <20130513013518.GM3648@linux.vnet.ibm.com>
 <20130513140005.GA9165@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130513140005.GA9165@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 14 19:37:40 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5192766423671048821419
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, May 13, 2013 at 07:00:05AM -0700, Paul E. McKenney wrote:
> rcu: Fix comparison sense in rcu_needs_cpu()
> 
> Commit c0f4dfd4f (rcu: Make RCU_FAST_NO_HZ take advantage of numbered
> callbacks) introduced a bug that can result in excessively long grace
> periods.  This bug reverse the senes of the "if" statement checking
> for lazy callbacks, so that RCU takes a lazy approach when there are
> in fact non-lazy callbacks.  This can result in excessive boot, suspend,
> and resume times.
> 
> This commit therefore fixes the sense of this "if" statement.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Reported-by: Bjørn Mork <bjorn@mork.no>
> Reported-by: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Just tested the patch, it fixes the long boot delay for me. Thanks for
fixing this.

Tested-by: Joerg Roedel <joro@8bytes.org>

> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 641991d..63098a5 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1692,7 +1692,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
>  	rdtp->last_accelerate = jiffies;
>  
>  	/* Request timer delay depending on laziness, and round. */
> -	if (rdtp->all_lazy) {
> +	if (!rdtp->all_lazy) {
>  		*dj = round_up(rcu_idle_gp_delay + jiffies,
>  			       rcu_idle_gp_delay) - jiffies;
>  	} else {
> 

