Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaLDAMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:12:50 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49534 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLDAMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:12:48 -0500
Date: Wed, 3 Dec 2014 16:12:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 8/9] s390/kvm: REPLACE ACCESS_ONCE with READ_ONCE
Message-ID: <20141204001243.GE25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
 <1417645821-54731-9-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417645821-54731-9-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120400-0005-0000-0000-000006D697D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:30:20PM +0100, Christian Borntraeger wrote:
> ACCESS_ONCE does not work reliably on non-scalar types. For
> example gcc 4.6 and 4.7 might remove the volatile tag for such
> accesses during the SRA (scalar replacement of aggregates) step
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
> 
> Change the ipte lock code to replace ACCESS_ONCE with READ_ONCE.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/s390/kvm/gaccess.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 0f961a1..8f195fa 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -229,10 +229,10 @@ static void ipte_lock_simple(struct kvm_vcpu *vcpu)
>  		goto out;
>  	ic = &vcpu->kvm->arch.sca->ipte_control;
>  	do {
> -		old = ACCESS_ONCE(*ic);
> +		old = READ_ONCE(*ic);
>  		while (old.k) {
>  			cond_resched();
> -			old = ACCESS_ONCE(*ic);
> +			old = READ_ONCE(*ic);
>  		}
>  		new = old;
>  		new.k = 1;
> @@ -251,7 +251,8 @@ static void ipte_unlock_simple(struct kvm_vcpu *vcpu)
>  		goto out;
>  	ic = &vcpu->kvm->arch.sca->ipte_control;
>  	do {
> -		new = old = ACCESS_ONCE(*ic);
> +		old = READ_ONCE(*ic);
> +		new = old;
>  		new.k = 0;
>  	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
>  	wake_up(&vcpu->kvm->arch.ipte_wq);
> @@ -265,10 +266,10 @@ static void ipte_lock_siif(struct kvm_vcpu *vcpu)
> 
>  	ic = &vcpu->kvm->arch.sca->ipte_control;
>  	do {
> -		old = ACCESS_ONCE(*ic);
> +		old = READ_ONCE(*ic);
>  		while (old.kg) {
>  			cond_resched();
> -			old = ACCESS_ONCE(*ic);
> +			old = READ_ONCE(*ic);
>  		}
>  		new = old;
>  		new.k = 1;
> @@ -282,7 +283,8 @@ static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
> 
>  	ic = &vcpu->kvm->arch.sca->ipte_control;
>  	do {
> -		new = old = ACCESS_ONCE(*ic);
> +		old = READ_ONCE(*ic);
> +		new = old;
>  		new.kh--;
>  		if (!new.kh)
>  			new.k = 0;
> -- 
> 1.9.3
> 

