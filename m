Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423055AbaDKQNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:13:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45104 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161061AbaDKQND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:13:03 -0400
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6F5DFA@AcuExch.aculab.com>
References: <20140410213029.24916.93892.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6F5DFA@AcuExch.aculab.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 11 Apr 2014 10:12:43 -0600
Message-ID: <CAErSpo4KOe5zBYNXDhdEFUMdhCBhs00CCvYHbW3071ZUdN6s6A@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix compiler array bounds warning on selective_acks[]
To: David Laight <David.Laight@aculab.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 2:59 AM, David Laight <David.Laight@aculab.com> wrote:
> Bjorn Helgaas
>> With -Werror=array-bounds, gcc v4.8.x warns that in tcp_sack_remove(), a
>> selective_acks[] "array subscript is above array bounds".
>>
>> I don't understand how gcc figures this out, or why we don't see similar
>> problems many other places, but this is the only fix I can figure out.
> ...
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index 65cf90e063d5..65133b108236 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -4047,7 +4047,8 @@ static void tcp_sack_remove(struct tcp_sock *tp)
>>
>>                       /* Zap this SACK, by moving forward any other SACKS. */
>>                       for (i = this_sack+1; i < num_sacks; i++)
>> -                             tp->selective_acks[i-1] = tp->selective_acks[i];
>> +                             if (i < ARRAY_SIZE(tp->selective_acks))
>> +                                     tp->selective_acks[i-1] = tp->selective_acks[i];
>>                       num_sacks--;
>>                       continue;
>>               }
>
> You really shouldn't add that test every time around the loop.
>
> Try changing the loop so the assignment is:
>    tp->selective_acks[i] = tp->selective_acks[i + 1];
>
> or the loop test to:
>         i <= num_sacks - 1;
>
> Or beat up the gcc developers :-)

You're right, that *is* ugly.  And it seems that gcc-v4.9.x doesn't
complain about this, and that's good enough for my purposes, so I
withdraw this patch.

Thanks and sorry for the noise,
  Bjorn
