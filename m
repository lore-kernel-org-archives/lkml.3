Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3EULzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 07:55:14 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:53651 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096Ab3EULzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 07:55:12 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <519B6099.1080403@yandex-team.ru>
Date: Tue, 21 May 2013 15:55:05 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        zhmurov@yandex-team.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
References: <519B38EC.90401@yandex-team.ru> <AE90C24D6B3A694183C094C60CF0A2F6026B7241@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7241@saturn3.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.05.2013 14:40, David Laight wrote:
>> Some network functions (udp4_lib_lookup2(), for instance) use the
>> hlist_nulls_for_each_entry_rcu macro in a way that assumes restarting
>> of a loop. In this case, it is strictly necessary to reread the head->first
>> value from the memory before each scan.
>> Without additional hints, gcc caches this value in a register. In this case,
>> if a cached node is moved to another chain during the scan, we can loop
>> forever getting wrong nulls values and restarting the loop uninterruptedly.
>
> Hmmm.... if either inet_ehashfn() or next_pseudo_random32() is
> called gcc must reread it anyway.
> I'm surprised gcc is generating separate code for all the conditional
> loop endings. So why is it caching head->first.
> The 'list empty' might be short-circuited - but that would only
> be relevant after a rescan.
> I suspect something else is going on.

What do you mean?

> I'd also have thought that this code needs to scan the entire
> hash list. If things are moved under its feet this won't happen.
> If it can end up on a different list (because a node got moved)
> it is also possible for a later node to move it back.
> In that case it would end up on the correct list

Things are always moved to the head of the list, so, it's not a problem.

> ...
>> -#define hlist_nulls_first_rcu(head) \
>> -	(*((struct hlist_nulls_node __rcu __force **)&(head)->first))
>> +#define hlist_nulls_first_rcu(head)			\
>> +	(*((struct hlist_nulls_node __rcu __force **)	\
>> +	   &((volatile typeof(*head) *)head)->first))
>
> I'd have thought it would be better to change hlist_nulls_first_rcu().

It's exactly what I suggest. May be I miss something? Please, clarify.

Regards,
Roman
