Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3E2FIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:08:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3E2FIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:08:19 -0400
Message-ID: <1369804097.3301.615.camel@edumazet-glaptop>
Subject: Re: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu
 macro
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Roman Gushchin <klamm@yandex-team.ru>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, zhmurov@yandex-team.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Date: Tue, 28 May 2013 22:08:17 -0700
In-Reply-To: <20130529013111.GS6172@linux.vnet.ibm.com>
References: <519CB2D8.103@yandex-team.ru>
	 <1369225837.3301.324.camel@edumazet-glaptop>
	 <519CC2FB.2010006@yandex-team.ru>
	 <20130522174532.GC3431@linux.vnet.ibm.com> <519D19DA.50400@yandex-team.ru>
	 <20130525113715.GA3795@linux.vnet.ibm.com>
	 <51A39E11.5020405@yandex-team.ru>
	 <1369699930.3301.494.camel@edumazet-glaptop>
	 <51A47496.6000100@yandex-team.ru>
	 <1369787693.3301.586.camel@edumazet-glaptop>
	 <20130529013111.GS6172@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 18:31 -0700, Paul E. McKenney wrote:
> On Tue, May 28, 2013 at 05:34:53PM -0700, Eric Dumazet wrote:
> > On Tue, 2013-05-28 at 13:10 +0400, Roman Gushchin wrote:
> > > On 28.05.2013 04:12, Eric Dumazet wrote:
> > 
> > > > Adding a barrier() is probably what we want.
> > > 
> > > I agree, inserting barrier() is also a correct and working fix.
> > 
> > Yeah, but I can not find a clean way to put it inside the "for (;;)"
> > 
> > for (barrier();;)  ->
> > 
> > error: expected expression before ‘__asm__’
> > 
> > No user currently does :
> > 
> > if (condition)
> > 	hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)
> > 
> > But who knows...
> 
> I still have my earlier question, but I suggest "({ barrier(); XXX })"
> to put the barrier into the for loop, either in the second or third
> clause, where XXX was the original second or third clause.
> 
> 	

Hmm, it doesn't work, I wanted to replace :

barrier();
for (expr1 ; expr2; expr3) {

by :

for ( some_clever_thing ; expr2; expr3) {

So barrier() should not be in second or third clause : it must be done
once and before "expr1".

Not a big deal anyway, we're not adding new
hlist_nulls_for_each_entry_rcu() users :)


About your earlier question, I really don't know why compiler would
cache a memory read if we explicitly use barrier() to prevent this from
happening.

BTW Roman patch generates a double load as in :

2cb1:       49 8b 07                mov    (%r15),%rax    
2cb4:       49 8b 07                mov    (%r15),%rax        


...
2ea2:       e8 f9 dc ff ff          callq  ba0 <sock_put>
2ea7:       8b 0c 24                mov    (%rsp),%ecx
2eaa:       e9 02 fe ff ff          jmpq   2cb1 <udp4_lib_lookup2+0x91> 

because of ACCESS_ONCE() used twice, once explicitly in
hlist_nulls_for_each_entry_rcu(), and once in rcu_dereference_raw()

While barrier();ptr = rcu_dereference(X); does generate a single load.



