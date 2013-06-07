Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3FGMlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:41:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65392 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3FGMlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:41:15 -0400
Message-ID: <1370608871.5854.64.camel@marge.simpson.net>
Subject: Re: Scaling problem with a lot of AF_PACKET sockets on different
 interfaces
From: Mike Galbraith <bitbucket@online.de>
To: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Fri, 07 Jun 2013 14:41:11 +0200
In-Reply-To: <51B1CA50.30702@telenet.dn.ua>
References: <51B1CA50.30702@telenet.dn.ua>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:4wo1KiKnzNFzHUoi0y6DqtpTUMA2ohQoas1GwouX1BE
 3oBhpQyCUWcNzMK1FTBekcfIA6Pqa8DJwg7VKpKP7y+sx/kdpi
 xwaxtkWn31PzXhmvWiLroPBRZbaH5iOv+0W3HpjxjgTYUJKBEe
 aQH3D+2d9zDZuIKusSzHbRf9j/Ptnu1UZ+i6g8uhx9xIPCjyLo
 P2p1ItfyO28vuW+thJVs2yxNLxS6RfwiWzNY94GkqAXqMh9dzx
 rhDk2P/2VLGY+Pu5B2Llp03qTkHoczYYc+1K1EMnK/fuW8hw19
 wBl0GkNpsaBzakTj11om9EkpG4F0ndqlXuQhsjlp/b3lceh2sX
 SBfhQtxAjkRgztOL/ITZ38KxqQSLkRitIcMCo2N9agBHDYjcAP
 oW/Ax5mRfrM/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC's net-fu dojo) 

On Fri, 2013-06-07 at 14:56 +0300, Vitaly V. Bursov wrote: 
> Hello,
> 
> I have a Linux router with a lot of interfaces (hundreds or
> thousands of VLANs) and an application that creates AF_PACKET
> socket per interface and bind()s sockets to interfaces.
> 
> Each socket has attached BPF filter too.
> 
> The problem is observed on linux-3.8.13, but as far I can see
> from the source the latest version has alike behavior.
> 
> I noticed that box has strange performance problems with
> most of the CPU time spent in __netif_receive_skb:
>   86.15%  [k] __netif_receive_skb
>    1.41%  [k] _raw_spin_lock
>    1.09%  [k] fib_table_lookup
>    0.99%  [k] local_bh_enable_ip
> 
> and this the assembly with the "hot spot":
>         │       shr    $0x8,%r15w
>         │       and    $0xf,%r15d
>    0.00 │       shl    $0x4,%r15
>         │       add    $0xffffffff8165ec80,%r15
>         │       mov    (%r15),%rax
>    0.09 │       mov    %rax,0x28(%rsp)
>         │       mov    0x28(%rsp),%rbp
>    0.01 │       sub    $0x28,%rbp
>         │       jmp    5c7
>    1.72 │5b0:   mov    0x28(%rbp),%rax
>    0.05 │       mov    0x18(%rsp),%rbx
>    0.00 │       mov    %rax,0x28(%rsp)
>    0.03 │       mov    0x28(%rsp),%rbp
>    5.67 │       sub    $0x28,%rbp
>    1.71 │5c7:   lea    0x28(%rbp),%rax
>    1.73 │       cmp    %r15,%rax
>         │       je     640
>    1.74 │       cmp    %r14w,0x0(%rbp)
>         │       jne    5b0
>   81.36 │       mov    0x8(%rbp),%rax
>    2.74 │       cmp    %rax,%r8
>         │       je     5eb
>    1.37 │       cmp    0x20(%rbx),%rax
>         │       je     5eb
>    1.39 │       cmp    %r13,%rax
>         │       jne    5b0
>    0.04 │5eb:   test   %r12,%r12
>    0.04 │       je     6f4
>         │       mov    0xc0(%rbx),%eax
>         │       mov    0xc8(%rbx),%rdx
>         │       testb  $0x8,0x1(%rdx,%rax,1)
>         │       jne    6d5
> 
> This corresponds to:
> 
> net/core/dev.c:
>          type = skb->protocol;
>          list_for_each_entry_rcu(ptype,
>                          &ptype_base[ntohs(type) & PTYPE_HASH_MASK], list) {
>                  if (ptype->type == type &&
>                      (ptype->dev == null_or_dev || ptype->dev == skb->dev ||
>                       ptype->dev == orig_dev)) {
>                          if (pt_prev)
>                                  ret = deliver_skb(skb, pt_prev, orig_dev);
>                          pt_prev = ptype;
>                  }
>          }
> 
> Which works perfectly OK until there are a lot of AF_PACKET sockets, since
> the socket adds a protocol to ptype list:
> 
> # cat /proc/net/ptype
> Type Device      Function
> 0800 eth2.1989 packet_rcv+0x0/0x400
> 0800 eth2.1987 packet_rcv+0x0/0x400
> 0800 eth2.1986 packet_rcv+0x0/0x400
> 0800 eth2.1990 packet_rcv+0x0/0x400
> 0800 eth2.1995 packet_rcv+0x0/0x400
> 0800 eth2.1997 packet_rcv+0x0/0x400
> .......
> 0800 eth2.1004 packet_rcv+0x0/0x400
> 0800          ip_rcv+0x0/0x310
> 0011          llc_rcv+0x0/0x3a0
> 0004          llc_rcv+0x0/0x3a0
> 0806          arp_rcv+0x0/0x150
> 
> And this obviously results in a huge performance penalty.
> 
> ptype_all, by the looks, should be the same.
> 
> Probably one way to fix this it to perform interface name matching in
> af_packet handler, but there could be other cases, other protocols.
> 
> Ideas are welcome :)
> 


