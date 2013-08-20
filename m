Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3HTDwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:52:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:60260 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3HTDwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:52:23 -0400
X-Spam-Score: -101.1
Message-ID: <5212E7BB.4020602@asianux.com>
Date: Tue, 20 Aug 2013 11:51:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: dipankar@in.ibm.com, Paul McKenney <paulmck@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutree.c: deem to be lazy if there are no callbacks.
References: <5212E76A.40903@asianux.com>
In-Reply-To: <5212E76A.40903@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



If 'hc' is false, 'al' will never be false, either (only need check
"irdp->qlen != rdp->qlen_lazy' when 'rdp->nxtlist' existance).

Recommend to improve the related code, like the diff below.

----------------------------------diff begin------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b53a89..421caf0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2719,10 +2719,13 @@ static int rcd'_cpu_has_callbacks(int cpu, bool *all_lazy)
 
 	for_each_rcu_flavor(rsp) {
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (rdp->qlen != rdp->qlen_lazy)
-			al = false;
-		if (rdp->nxtlist)
+		if (rdp->nxtlist) {
 			hc = true;
+			if (rdp->qlen != rdp->qlen_lazy) {
+				al = false;
+				break;
+			}
+		}
 	}
 	if (all_lazy)
 		*all_lazy = al;

----------------------------------diff end--------------------------------------


On 08/20/2013 11:50 AM, Chen Gang wrote:
> According to the comment above rcu_cpu_has_callbacks(): "If there are
> no callbacks, all of them are deemed to be lazy".
> 
> So when both 'hc' and 'al' are false, '*all_lazy' should be true, not
> false.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/rcutree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 5b53a89..9ee9565 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2725,7 +2725,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>  			hc = true;
>  	}
>  	if (all_lazy)
> -		*all_lazy = al;
> +		*all_lazy = !hc ? true : al;
>  	return hc;
>  }
>  
> 


-- 
Chen Gang
