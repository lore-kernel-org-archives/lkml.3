Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaBDRWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:22:51 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:51983 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBDRWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:22:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
References: <87r47jsb2p.fsf@xmission.com>
	<1391530721.4301.8.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Tue, 04 Feb 2014 09:22:40 -0800
In-Reply-To: <1391530721.4301.8.camel@edumazet-glaptop2.roam.corp.google.com>
	(Eric Dumazet's message of "Tue, 04 Feb 2014 08:18:41 -0800")
Message-ID: <871tzirdwf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18SzS5EC2VDM4BoXKbIlH94ptdFC+3PTTw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3939]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Dumazet <eric.dumazet@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] fdtable: Avoid triggering OOMs from alloc_fdmem
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On Mon, 2014-02-03 at 21:26 -0800, Eric W. Biederman wrote:
>> Recently due to a spike in connections per second memcached on 3
>> separate boxes triggered the OOM killer from accept.  At the time the
>> OOM killer was triggered there was 4GB out of 36GB free in zone 1. The
>> problem was that alloc_fdtable was allocating an order 3 page (32KiB) to
>> hold a bitmap, and there was sufficient fragmentation that the largest
>> page available was 8KiB.
>> 
>> I find the logic that PAGE_ALLOC_COSTLY_ORDER can't fail pretty dubious
>> but I do agree that order 3 allocations are very likely to succeed.
>> 
>> There are always pathologies where order > 0 allocations can fail when
>> there are copious amounts of free memory available.  Using the pigeon
>> hole principle it is easy to show that it requires 1 page more than 50%
>> of the pages being free to guarantee an order 1 (8KiB) allocation will
>> succeed, 1 page more than 75% of the pages being free to guarantee an
>> order 2 (16KiB) allocation will succeed and 1 page more than 87.5% of
>> the pages being free to guarantee an order 3 allocate will succeed.
>> 
>> A server churning memory with a lot of small requests and replies like
>> memcached is a common case that if anything can will skew the odds
>> against large pages being available.
>> 
>> Therefore let's not give external applications a practical way to kill
>> linux server applications, and specify __GFP_NORETRY to the kmalloc in
>> alloc_fdmem.  Unless I am misreading the code and by the time the code
>> reaches should_alloc_retry in __alloc_pages_slowpath (where
>> __GFP_NORETRY becomes signification).  We have already tried everything
>> reasonable to allocate a page and the only thing left to do is wait.  So
>> not waiting and falling back to vmalloc immediately seems like the
>> reasonable thing to do even if there wasn't a chance of triggering the
>> OOM killer.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/file.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/fs/file.c b/fs/file.c
>> index 771578b33fb6..db25c2bdfe46 100644
>> --- a/fs/file.c
>> +++ b/fs/file.c
>> @@ -34,7 +34,7 @@ static void *alloc_fdmem(size_t size)
>>  	 * vmalloc() if the allocation size will be considered "large" by the VM.
>>  	 */
>>  	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
>> -		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
>> +		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY);
>>  		if (data != NULL)
>>  			return data;
>>  	}
>
> Hi Eric
>
> I wrote yesterday a similar patch adding __GFP_NORETRY in following
> paths. I feel that alloc_fdmem() is only a part of the problem ;)

These code paths below were triggering OOMs for you?

I looked and didn't see a path flying through the air.

> What do you think, should we merge our changes or have distinct
> patches ?

I don't know about merging changes but certainly looking at the issue
together sounds good.

My gut feel says if there is a code path that has __GFP_NOWARN and
because of PAGE_ALLOC_COSTLY_ORDER we loop forever then there is
something fishy going on.

I would love to hear some people who are more current on the mm
subsystem than I am chime in.  It might be that the darn fix is going to
be to teach __alloc_pages_slowpath to not loop forever, unless order == 0. 
I expect the worst offenders need to have __GFP_NORETRY added so the
knowledge of what is going on spreads, and so we can avoid the danger of
needing to retune the whole mm subsystem that changing
__alloc_pages_slowpath does.

The two code paths below certainly look good canidates for having
__GFP_NORETRY added to them.  The same issues I ran into with
alloc_fdmem are likely to show up there as well.

Eric



> diff --git a/net/core/sock.c b/net/core/sock.c
> index 0c127dcdf6a8..5b6a9431b017 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1775,7 +1775,9 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
>  			while (order) {
>  				if (npages >= 1 << order) {
>  					page = alloc_pages(sk->sk_allocation |
> -							   __GFP_COMP | __GFP_NOWARN,
> +							   __GFP_COMP |
> +							   __GFP_NOWARN |
> +							   __GFP_NORETRY,
>  							   order);
>  					if (page)
>  						goto fill_page;
> @@ -1845,7 +1847,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio)
>  		gfp_t gfp = prio;
>  
>  		if (order)
> -			gfp |= __GFP_COMP | __GFP_NOWARN;
> +			gfp |= __GFP_COMP | __GFP_NOWARN | __GFP_NORETRY;
>  		pfrag->page = alloc_pages(gfp, order);
>  		if (likely(pfrag->page)) {
>  			pfrag->offset = 0;
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
