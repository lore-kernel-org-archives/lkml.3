Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaKUV5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:57:33 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:33030 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaKUV5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:57:31 -0500
MIME-Version: 1.0
In-Reply-To: <1416586364.8629.104.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1416582363-20661-1-git-send-email-bobby.prani@gmail.com>
 <1416582363-20661-10-git-send-email-bobby.prani@gmail.com> <1416586364.8629.104.camel@edumazet-glaptop2.roam.corp.google.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 21 Nov 2014 16:57:00 -0500
Message-ID: <CAJhHMCCCSU7PbWdgPouefbLJBcoxR8nmsS8dg_=BcuqVJZbDew@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] netfilter: Replace smp_read_barrier_depends() with lockless_dereference()
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "open list:NETWORKING [IPv4/..." <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:12 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2014-11-21 at 10:06 -0500, Pranith Kumar wrote:
>> Recently lockless_dereference() was added which can be used in place of
>> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> ---
>>  net/ipv4/netfilter/arp_tables.c | 3 +--
>>  net/ipv4/netfilter/ip_tables.c  | 3 +--
>>  net/ipv6/netfilter/ip6_tables.c | 3 +--
>>  3 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
>> index f95b6f9..fc7533d 100644
>> --- a/net/ipv4/netfilter/arp_tables.c
>> +++ b/net/ipv4/netfilter/arp_tables.c
>> @@ -270,12 +270,11 @@ unsigned int arpt_do_table(struct sk_buff *skb,
>>
>>       local_bh_disable();
>>       addend = xt_write_recseq_begin();
>> -     private = table->private;
>>       /*
>>        * Ensure we load private-> members after we've fetched the base
>>        * pointer.
>>        */
>> -     smp_read_barrier_depends();
>> +     private = lockless_dereference(table->private);
>>       table_base = private->entries[smp_processor_id()];
>>
>
>
> Please carefully read the code, before and after your change, then
> you'll see this change broke the code.
>
> Problem is that a bug like that can be really hard to diagnose and fix
> later, so really you have to be very careful doing these mechanical
> changes.
>
> IMO, current code+comment is better than with this
> lockless_dereference() which in this particular case obfuscates the
> code. more than anything.
>
> In this case we do have a lock (sort of), so lockless_dereference() is
> quite misleading.
>

Hi Eric,

Thanks for looking at this patch.

I've been scratching my head since morning trying to find out what was
so obviously wrong with this patch. Alas, I don't see what you do.

Could you point it out and show me how incompetent I am, please?

Thanks!
-- 
Pranith
