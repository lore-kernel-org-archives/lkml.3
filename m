Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab3GYDPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:15:36 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:46771 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3GYDPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:15:31 -0400
Message-ID: <51F09841.1060405@linux.vnet.ibm.com>
Date: Thu, 25 Jul 2013 11:15:13 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: update_top_cache_domain only at the times of
 building sched domain.
References: <1374601332.9192.0.camel@localhost.localdomain> <51EF4969.4050807@linux.vnet.ibm.com> <CADZ9YHiJ4MYFkWqikKu0qHOsBYGEPYvC2JL5wE3iCUH6vTMKcA@mail.gmail.com> <51EF919F.2000706@linux.vnet.ibm.com> <CADZ9YHiQO7ynz+4KK73N+wpEvgcQDaHJ9cOn5fHaw0uGnVBtnQ@mail.gmail.com>
In-Reply-To: <CADZ9YHiQO7ynz+4KK73N+wpEvgcQDaHJ9cOn5fHaw0uGnVBtnQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072503-9574-0000-0000-000008DF1F21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 09:57 PM, Rakib Mullick wrote:
> On Wed, Jul 24, 2013 at 2:34 PM, Michael Wang
[snip]
>>
>> I think you missed this in PeterZ's suggestion:
>>
>> -               cpu_attach_domain(NULL, &def_root_domain, i);
>>
>> With this change, it will be safe since you will still get an un-freed
>> sd, although it's an old one.
>>
> I never meant it and clearly I missed it. If you remove
> cpu_attach_domain(), then detach_destroy_domain() becomes meaningless.
> And I don't have any intent to remove cpu_attach_domain from
> detach_destroy_domain() at all.
> 
>> But your patch will run the risk to get a freed sd, since you make
>> 'sd_llc' wrong for a period of time (between destroy and rebuild) IMO.
>>

Ok, allow me try to explain it again, hope this time it could be more
clear...

> Building 'sd_llc' depends on schedule domain. If you don't have sd,
> sd_llc will point to NULL and sd_llc_id is
> the CPU itself. Since, we're  trying to re-construing so for this time
> being it doesn't matter, cause we're building
> it again. 

It does matter, although we build it again, we need to make things sync
at any point of time in SMP world.

Now, please just note what you're saying, on last thread
> you've said -
> 
>        "I don't think we have the promise that before we rebuild the stuff
>         correctly, no one will utilize 'sd_llc'..."
> 
> If that is the case, then we shouldn't worry about it at all. And this
> above comments (from previous thread I've quoted and this thread I'm
> replying) they're just self contradictory.

Let's have some picture like:

	destroy
		cpu_attach_domain(NULL)			//cad_A
			update_top_cache_domain()	//utcd_A

	WINDOW	//begin after last rcu_read_unlock()
		//end after next rcu_read_lock()

	build
		cpu_attach_domain(new_sd)		//cad_B
			update_top_cache_domain()	//utcd_B

Now in old world, what we have is:
1. in 'utcd_A', make 'sd_llc' to be NULL since old_sd was destroyed in
cad_A.
2. thus during WINDOW, both 'rq->sd' and 'sd_llc' is NULL
3. in 'utcd_B', update 'sd_llc' to be the new 'highest cache-share sd'
since new_sd attached in 'cad_B'

Now with your patch applied, what will happen is:
1. 'utcd_A' won't happen now, although the sd 'sd_llc' point to was
destroyed in 'cad_A'
2. thus during WINDOW, 'rq->sd' is NULL while 'sd_llc' is the destroyed
'old highest cache-share sd'
3. in 'utcd_B', update 'sd_llc' to be the new 'highest cache-share sd '
since new_sd attached in 'cad_B'

Seems like both will result the same 'sd_llc', but your patch make
'sd_llc' point to a destroyed sd during the WINDOW.

And I said:

"I don't think we have the promise that before we rebuild the stuff
correctly, no one will utilize 'sd_llc'..."

By which I mean some one will utilize 'sd_llc' during the WINDOW, in old
world, it's safe since will get NULL, with your patch, it's unsafe since
we get a freeing sd.

And that's the risk I concerned, and that's my point.

> 
>> I guess I get you point, you are trying to save one time update since
>> you think this will be done twice, but actually the result of this two
>> time update was different, it's not redo and it's in order to sync
>> 'sd_llc' with 'rq->sd'.
>>
> Yes, you got my point now, but I don't understand your points. Anyway,
> I'm not going to argue with this
> anymore, this stuff isn't much of an issue, but removing this sorts of
> stuff is typical in kernel development.

I'm not argue, actually there is nothing to argue...just try to explain
what is wrong IMO, if I failed to, then I could only blame my poor
writing skill...

Regards,
Michael Wang

> 
> Thanks,
> Rakib.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

