Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3EVING (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:13:06 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:37788 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab3EVINC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:13:02 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <519C7E08.3020105@yandex-team.ru>
Date: Wed, 22 May 2013 12:12:56 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 072/102] ipv6: do not clear pinet6 field
References: <20130517213244.277411019@linuxfoundation.org>  <20130517213251.913091371@linuxfoundation.org>  <519B5E29.5010605@yandex-team.ru> <1369172846.3301.258.camel@edumazet-glaptop>
In-Reply-To: <1369172846.3301.258.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2013 01:47, Eric Dumazet wrote:
> On Tue, 2013-05-21 at 15:44 +0400, Roman Gushchin wrote:
>> Hi, all!
>>
>> I think, it's good, but not enough.
>>
>> We still can't rely on the sk->sk_family field by dereferencing the
>> inet_sk(sk)->pinet6 field, because we can set the sk_family field to
>> the PF_INET6 value before setting pinet6 to an appropriate value
>> (assuming it is NULL just because it was not a PF_INET6 socket in a
>> previous life).
>>
>> net/ipv6/af_inet6.c:
>> static int inet6_create(struct net *net, struct socket *sock, int
>> protocol, int kern)
>> {
>> 	<...>
>> 	err = -ENOBUFS;
>> 	sk = sk_alloc(net, PF_INET6, GFP_KERNEL, answer_prot);
>> 	if (sk == NULL)
>> 		goto out;
>> 	<...>
>> 	sk->sk_destruct		= inet_sock_destruct;
>> 	sk->sk_family		= PF_INET6;
>> 	sk->sk_protocol		= protocol;
>>
>> 	sk->sk_backlog_rcv	= answer->prot->backlog_rcv;
>>
>> 	inet_sk(sk)->pinet6 = np = inet6_sk_generic(sk);
>> 	<...>
>> }
>>
>> net/core/sock.c:
>> struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
>> 		      struct proto *prot)
>> {
>> 	struct sock *sk;
>>
>> 	sk = sk_prot_alloc(prot, priority | __GFP_ZERO, family);
>> 	if (sk) {
>> 		sk->sk_family = family;
>> 	<...>
>> }
>>
>>
>> So, we need to care about setting sk_family to PF_INET6 _strictly_ after
>> setting the pinet6 field to a valid value (using rcu_assign_pointer(),
>> for instance).
>
> This can never happen.
>
> A socket cannot be find in a hash chain while pinet6 is not set.
>
> For a given socket pointer sk (say TCP or UDP), pinet6 is a constant and
> cannot change. (This is a property of SLAB_DESTROY_BY_RCU : slab cannot
> be merged, so all objects are of the same type)

I missed that.
>
> So the order of writing sk_family / pinet6 is irrelevant.

Agree.

Thank you for clarification!

Regards,
Roman
