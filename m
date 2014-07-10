Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaGJC2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 22:28:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:9863 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380AbaGJC2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 22:28:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,635,1400050800"; 
   d="scan'208";a="559707420"
Message-ID: <53BDFA22.2000409@linux.intel.com>
Date: Thu, 10 Jul 2014 10:27:46 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] GPIO button wth wakeup attribute is supposed to wake
 the system up
References: <53A2340D.9030503@linux.intel.com> <18261725.84uqcyZ8CE@vostro.rjw.lan> <20140709005434.GB14935@core.coreip.homeip.net> <4301161.i6ArOLmcsg@vostro.rjw.lan>
In-Reply-To: <4301161.i6ArOLmcsg@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/9 20:45, Rafael J. Wysocki wrote:
> On Tuesday, July 08, 2014 05:54:35 PM Dmitry Torokhov wrote:
>> On Wed, Jul 09, 2014 at 02:59:33AM +0200, Rafael J. Wysocki wrote:
>>> On Tuesday, July 08, 2014 05:15:06 PM Dmitry Torokhov wrote:
>>>> On Wed, Jul 09, 2014 at 01:06:07AM +0200, Rafael J. Wysocki wrote:
> 
> [cut]
> 
>>>>
>>>> When device driver marks IRQ as a wakeup source I believe it is prepared
>>>> to handle it (or it would shut it off explicitly).
>>>
>>> I can agree with that.
>>>
>>> Are you suggesting that __disable_irq() should check irq_data for
>>> IRQD_WAKEUP_STATE and skip the IRQ (in the 'suspend' case) if that is set?
>>
>> Yes, something like that.
> 
> OK

Many thanks to you both for the discussion.
> 
> Aubrey, can you please check if the appended patch helps on the T100?

I verified this patch on T100, it works as expected, freeze can be waken
up by reverting my patch and applying this one.

Is this a final solution?

Thanks,
-Aubrey

> 
> Rafael
> 
> ---
>  kernel/irq/manage.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-pm/kernel/irq/manage.c
> ===================================================================
> --- linux-pm.orig/kernel/irq/manage.c
> +++ linux-pm/kernel/irq/manage.c
> @@ -385,7 +385,8 @@ setup_affinity(unsigned int irq, struct
>  void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
>  {
>  	if (suspend) {
> -		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
> +		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND)
> +		    || irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
>  			return;
>  		desc->istate |= IRQS_SUSPENDED;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

