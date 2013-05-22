Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3EVMam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:30:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62227 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab3EVMal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:30:41 -0400
Message-ID: <1369225837.3301.324.camel@edumazet-glaptop>
Subject: Re: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu
 macro
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: paulmck@linux.vnet.ibm.com, Dipankar Sarma <dipankar@in.ibm.com>,
        zhmurov@yandex-team.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Date: Wed, 22 May 2013 05:30:37 -0700
In-Reply-To: <519CB2D8.103@yandex-team.ru>
References: <519B38EC.90401@yandex-team.ru>
	  <20130521120906.GD3578@linux.vnet.ibm.com>
	  <1369143885.3301.221.camel@edumazet-glaptop>
	  <519B8908.9080007@yandex-team.ru>
	  <1369150693.3301.233.camel@edumazet-glaptop>
	  <519BB90B.6080706@yandex-team.ru>
	  <1369188080.3301.268.camel@edumazet-glaptop>
	 <1369201765.3301.299.camel@edumazet-glaptop> <519CB2D8.103@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 15:58 +0400, Roman Gushchin wrote:

> +/*
> + * Same as ACCESS_ONCE(), but used for accessing field of a structure.
> + * The main goal is preventing compiler to store &ptr->field in a register.

But &ptr->field is a constant during the whole duration of
udp4_lib_lookup2() and could be in a register, in my case field is at
offset 0, and ptr is a parameter (so could be in a 'register')

The bug you found is that compiler caches the indirection  (ptr->field)
into a register, not that compiler stores &ptr->field into a register.

> + */
> +#define ACCESS_FIELD_ONCE(PTR, FIELD) (((volatile typeof(*PTR) *)PTR)->FIELD)
> +

Here we force the compiler to consider ptr as volatile, but semantically
it is not required in rcu_dereference(ptr->field)  

We want field to be reloaded, not ptr.

So yes, the patch appears to fix the bug, but it sounds not logical to
me.



