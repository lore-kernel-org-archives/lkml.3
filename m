Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3FGNFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab3FGNFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:05:38 -0400
Message-ID: <51B1DA96.1080303@redhat.com>
Date: Fri, 07 Jun 2013 15:05:26 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Scaling problem with a lot of AF_PACKET sockets on different
 interfaces
References: <51B1CA50.30702@telenet.dn.ua> <1370608871.5854.64.camel@marge.simpson.net>
In-Reply-To: <1370608871.5854.64.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 02:41 PM, Mike Galbraith wrote:
> (CC's net-fu dojo)
>
> On Fri, 2013-06-07 at 14:56 +0300, Vitaly V. Bursov wrote:
>> Hello,
>>
>> I have a Linux router with a lot of interfaces (hundreds or
>> thousands of VLANs) and an application that creates AF_PACKET
>> socket per interface and bind()s sockets to interfaces.
>>
>> Each socket has attached BPF filter too.
>>
>> The problem is observed on linux-3.8.13, but as far I can see
>> from the source the latest version has alike behavior.
>>
>> I noticed that box has strange performance problems with
>> most of the CPU time spent in __netif_receive_skb:
>>    86.15%  [k] __netif_receive_skb
>>     1.41%  [k] _raw_spin_lock
>>     1.09%  [k] fib_table_lookup
>>     0.99%  [k] local_bh_enable_ip
>>
>> and this the assembly with the "hot spot":
>>          │       shr    $0x8,%r15w
>>          │       and    $0xf,%r15d
>>     0.00 │       shl    $0x4,%r15
>>          │       add    $0xffffffff8165ec80,%r15
>>          │       mov    (%r15),%rax
>>     0.09 │       mov    %rax,0x28(%rsp)
>>          │       mov    0x28(%rsp),%rbp
>>     0.01 │       sub    $0x28,%rbp
>>          │       jmp    5c7
>>     1.72 │5b0:   mov    0x28(%rbp),%rax
>>     0.05 │       mov    0x18(%rsp),%rbx
>>     0.00 │       mov    %rax,0x28(%rsp)
>>     0.03 │       mov    0x28(%rsp),%rbp
>>     5.67 │       sub    $0x28,%rbp
>>     1.71 │5c7:   lea    0x28(%rbp),%rax
>>     1.73 │       cmp    %r15,%rax
>>          │       je     640
>>     1.74 │       cmp    %r14w,0x0(%rbp)
>>          │       jne    5b0
>>    81.36 │       mov    0x8(%rbp),%rax
>>     2.74 │       cmp    %rax,%r8
>>          │       je     5eb
>>     1.37 │       cmp    0x20(%rbx),%rax
>>          │       je     5eb
>>     1.39 │       cmp    %r13,%rax
>>          │       jne    5b0
>>     0.04 │5eb:   test   %r12,%r12
>>     0.04 │       je     6f4
>>          │       mov    0xc0(%rbx),%eax
>>          │       mov    0xc8(%rbx),%rdx
>>          │       testb  $0x8,0x1(%rdx,%rax,1)
>>          │       jne    6d5
>>
>> This corresponds to:
>>
>> net/core/dev.c:
>>           type = skb->protocol;
>>           list_for_each_entry_rcu(ptype,
>>                           &ptype_base[ntohs(type) & PTYPE_HASH_MASK], list) {
>>                   if (ptype->type == type &&
>>                       (ptype->dev == null_or_dev || ptype->dev == skb->dev ||
>>                        ptype->dev == orig_dev)) {
>>                           if (pt_prev)
>>                                   ret = deliver_skb(skb, pt_prev, orig_dev);
>>                           pt_prev = ptype;
>>                   }
>>           }
>>
>> Which works perfectly OK until there are a lot of AF_PACKET sockets, since
>> the socket adds a protocol to ptype list:
>>
>> # cat /proc/net/ptype
>> Type Device      Function
>> 0800 eth2.1989 packet_rcv+0x0/0x400
>> 0800 eth2.1987 packet_rcv+0x0/0x400
>> 0800 eth2.1986 packet_rcv+0x0/0x400
>> 0800 eth2.1990 packet_rcv+0x0/0x400
>> 0800 eth2.1995 packet_rcv+0x0/0x400
>> 0800 eth2.1997 packet_rcv+0x0/0x400
>> .......
>> 0800 eth2.1004 packet_rcv+0x0/0x400
>> 0800          ip_rcv+0x0/0x310
>> 0011          llc_rcv+0x0/0x3a0
>> 0004          llc_rcv+0x0/0x3a0
>> 0806          arp_rcv+0x0/0x150
>>
>> And this obviously results in a huge performance penalty.
>>
>> ptype_all, by the looks, should be the same.
>>
>> Probably one way to fix this it to perform interface name matching in
>> af_packet handler, but there could be other cases, other protocols.
>>
>> Ideas are welcome :)

Probably, that depends on _your scenario_ and/or BPF filter, but would it be
an alternative if you have only a few packet sockets (maybe one pinned to each
cpu) and cluster/load-balance them together via packet fanout? (Where you
bind the socket to ifindex 0, so that you get traffic from all devs...) That
would at least avoid that "hot spot", and you could post-process the interface
via sockaddr_ll. But I'd agree that this will not solve the actual problem you've
observed. ;-)
