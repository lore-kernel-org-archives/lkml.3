Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965531Ab3E2KJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:09:38 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:49201 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965230Ab3E2KJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:09:37 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <51A5D3D9.1000106@yandex-team.ru>
Date: Wed, 29 May 2013 14:09:29 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>, paulmck@linux.vnet.ibm.com
CC: Jesper Dangaard Brouer <brouer@redhat.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, zhmurov@yandex-team.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu
 macro
References: <519CB2D8.103@yandex-team.ru>  <1369225837.3301.324.camel@edumazet-glaptop>  <519CC2FB.2010006@yandex-team.ru>  <20130522174532.GC3431@linux.vnet.ibm.com> <519D19DA.50400@yandex-team.ru>  <20130525113715.GA3795@linux.vnet.ibm.com>  <51A39E11.5020405@yandex-team.ru>  <1369699930.3301.494.camel@edumazet-glaptop>  <51A47496.6000100@yandex-team.ru>  <1369787693.3301.586.camel@edumazet-glaptop>  <20130529013111.GS6172@linux.vnet.ibm.com> <1369804097.3301.615.camel@edumazet-glaptop>
In-Reply-To: <1369804097.3301.615.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.05.2013 09:08, Eric Dumazet wrote:
> On Tue, 2013-05-28 at 18:31 -0700, Paul E. McKenney wrote:
>> On Tue, May 28, 2013 at 05:34:53PM -0700, Eric Dumazet wrote:
>>> On Tue, 2013-05-28 at 13:10 +0400, Roman Gushchin wrote:
>>>> On 28.05.2013 04:12, Eric Dumazet wrote:

> About your earlier question, I really don't know why compiler would
> cache a memory read if we explicitly use barrier() to prevent this from
> happening.

I agree.

> BTW Roman patch generates a double load as in :
>
> 2cb1:       49 8b 07                mov    (%r15),%rax
> 2cb4:       49 8b 07                mov    (%r15),%rax
>
>
> ...
> 2ea2:       e8 f9 dc ff ff          callq  ba0 <sock_put>
> 2ea7:       8b 0c 24                mov    (%rsp),%ecx
> 2eaa:       e9 02 fe ff ff          jmpq   2cb1 <udp4_lib_lookup2+0x91>
>
> because of ACCESS_ONCE() used twice, once explicitly in
> hlist_nulls_for_each_entry_rcu(), and once in rcu_dereference_raw()
>
> While barrier();ptr = rcu_dereference(X); does generate a single load.

It's true.

Unfortunately, using barrier() can also prevent gcc from making some
(acceptable) code optimizations, because barrier() has a global effect,
and everything we want to reload is the (head->first) pointer.
So, to be absolutely precise, we have to introduce and use
the ACCESS_FIELD_ONCE() macro.

In any case, it doesn't look like a big problem.
In my mind, the best solution is to use the ACCESS_FIELD_ONCE() macro,
but using barrier() is also an acceptable solution.

Regards,
Roman
