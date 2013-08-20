Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3HTESj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:18:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38263 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3HTESh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:18:37 -0400
Date: Mon, 19 Aug 2013 21:18:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: dipankar@in.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutree.c: deem to be lazy if there are no
 callbacks.
Message-ID: <20130820041832.GY29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5212E76A.40903@asianux.com>
 <5212E7BB.4020602@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5212E7BB.4020602@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082004-7606-0000-0000-00000E7626F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:51:23AM +0800, Chen Gang wrote:
> 
> 
> If 'hc' is false, 'al' will never be false, either (only need check
> "irdp->qlen != rdp->qlen_lazy' when 'rdp->nxtlist' existance).
> 
> Recommend to improve the related code, like the diff below.

Are you sure that this represents an improvement?  If so, why?

Or to put it another way, I see a patch that increases the size of the
kernel by three lines.  What is the corresponding benefit given common
kernel workloads?

							Thanx, Paul

> ----------------------------------diff begin------------------------------------
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 5b53a89..421caf0 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2719,10 +2719,13 @@ static int rcd'_cpu_has_callbacks(int cpu, bool *all_lazy)
> 
>  	for_each_rcu_flavor(rsp) {
>  		rdp = per_cpu_ptr(rsp->rda, cpu);
> -		if (rdp->qlen != rdp->qlen_lazy)
> -			al = false;
> -		if (rdp->nxtlist)
> +		if (rdp->nxtlist) {
>  			hc = true;
> +			if (rdp->qlen != rdp->qlen_lazy) {
> +				al = false;
> +				break;
> +			}
> +		}
>  	}
>  	if (all_lazy)
>  		*all_lazy = al;
> 
> ----------------------------------diff end--------------------------------------
> 
> 
> On 08/20/2013 11:50 AM, Chen Gang wrote:
> > According to the comment above rcu_cpu_has_callbacks(): "If there are
> > no callbacks, all of them are deemed to be lazy".
> > 
> > So when both 'hc' and 'al' are false, '*all_lazy' should be true, not
> > false.
> > 
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > ---
> >  kernel/rcutree.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 5b53a89..9ee9565 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -2725,7 +2725,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
> >  			hc = true;
> >  	}
> >  	if (all_lazy)
> > -		*all_lazy = al;
> > +		*all_lazy = !hc ? true : al;
> >  	return hc;
> >  }
> >  
> > 
> 
> 
> -- 
> Chen Gang
> 

