Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbaLQARu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 19:17:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41383 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbaLQARr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 19:17:47 -0500
Date: Tue, 16 Dec 2014 16:17:11 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Luck, Tony" <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt
 storms.
Message-ID: <20141217001711.GA7152@mail.thefacebook.com>
References: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
 <20141209180835.GF3990@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329640BC@ORSMSX114.amr.corp.intel.com>
 <20141210031102.GB1437888@mail.thefacebook.com>
 <20141210192340.GF17053@pd.tnic>
 <20141211023438.GA3239919@mail.thefacebook.com>
 <20141211144313.GB31140@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20141211144313.GB31140@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_01:2014-12-17,2014-12-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=26.7046773694174
 compositescore=0.928862112264561 urlsuspect_oldscore=0.928862112264561
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928862112264561 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412170000
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12/11 at 15:43 +0100, Borislav Petkov wrote:
> On Wed, Dec 10, 2014 at 06:34:38PM -0800, Calvin Owens wrote:
> > This doens't fix the original issue though: the timer double-add can
> > still happen if the CMCI interrupt that hits the STORM threshold pops
> > off during mce_timer_fn() and calls mce_timer_kick().
> 
> Right, I guess we could do something similar to what you proposed
> already (diff below ontop of my previous diff).

That looks good, thanks :)
 
> > The polling is unnecessary on a CMCI-capable machine except in STORMs,
> > right? Wouldn't it be better to eliminate it in that case?
> 
> Right, the problem with error thresholding is that it only counts errors
> and raises the APIC interrupt when a certain count has been reached.
> But there's no way for the software to look at *each* error and try to
> discover trends and stuff.
> 
> Thus, we've been working on something which looks at each memory error,
> collects them and then decays them over time and acts only for the
> significant ones by poisoning pages:
> 
> https://urldefense.proofpoint.com/v1/url?u=https://lkml.kernel.org/r/1404242623-10094-1-git-send-email-bp%40alien8.de&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=oEb120Cp%2FehdhuY2M7qjelK5yT8IPB5WC2nEG4obDh4%3D%0A&m=Uvvje79YqtSSsaolAYcJ9N3FPGiWTIz7feUxwbhAkNc%3D%0A&s=c88a2b8458e7f07ba887d26414f2ce5b80f9180353d0895a7f4f8b47d19dbec8
> 
> When we have that thing in place we can probably even go a step further
> and simply disable error thresholding because it simply doesn't give us
> what we need.
> 
> Btw, we would very much welcome your thoughs on this collector thing and
> whether it would be usable in large installations. Or if not, what else
> would it need added.

Ooh I like this, I'll add some thoughts over in that thread.

> > That said, I ran mce-test with your patch on top of 3.18, looks good
> > there. But that doesn't simulate CMCI interrupts.
> 
> Thanks, I had a machine here which was the perfect natural error
> injector (has faulty DIMMs). I need to dig it out and play with it again
> :)
> 
> Thanks.
> 
> ---
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index e3f426698164..8cf2f486b81e 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1331,6 +1331,24 @@ int ce_error_seen(void)
>  	return test_and_clear_bit(0, v);
>  }
>  
> +static void __restart_timer(struct timer_list *t, unsigned long interval)
> +{
> +	unsigned long when = jiffies + interval;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +
> +	if (timer_pending(t)) {
> +		if (time_before(when, t->expires))
> +			mod_timer_pinned(t, when);
> +	} else {
> +		t->expires = round_jiffies(when);
> +		add_timer_on(t, smp_processor_id());
> +	}
> +
> +	local_irq_restore(flags);
> +}
> +
>  static void mce_timer_fn(unsigned long data)
>  {
>  	struct timer_list *t = this_cpu_ptr(&mce_timer);
> @@ -1362,8 +1380,7 @@ static void mce_timer_fn(unsigned long data)
>  
>  done:
>  	__this_cpu_write(mce_next_interval, iv);
> -	t->expires = jiffies + iv;
> -	add_timer_on(t, cpu);
> +	__restart_timer(t, iv);
>  }
>  
>  /*
> @@ -1372,16 +1389,10 @@ done:
>  void mce_timer_kick(unsigned long interval)
>  {
>  	struct timer_list *t = this_cpu_ptr(&mce_timer);
> -	unsigned long when = jiffies + interval;
>  	unsigned long iv = __this_cpu_read(mce_next_interval);
>  
> -	if (timer_pending(t)) {
> -		if (time_before(when, t->expires))
> -			mod_timer_pinned(t, when);
> -	} else {
> -		t->expires = round_jiffies(when);
> -		add_timer_on(t, smp_processor_id());
> -	}
> +	__restart_timer(t, interval);
> +
>  	if (interval < iv)
>  		__this_cpu_write(mce_next_interval, interval);
>  }
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
