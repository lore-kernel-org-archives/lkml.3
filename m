Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3JIXR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:17:59 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52268 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab3JIXR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:17:58 -0400
Message-ID: <1381360675.4971.45.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH v2 tip/core/rcu 07/13] ipv6/ip6_tunnel: Apply
 rcu_access_pointer() to avoid sparse false positive
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Date: Wed, 09 Oct 2013 16:17:55 -0700
In-Reply-To: <20131009225617.GH11709@jtriplet-mobl1>
References: <20131009212920.GA15413@linux.vnet.ibm.com>
	 <1381354186-16285-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1381354186-16285-7-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1381354949.4971.20.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131009215747.GA5790@linux.vnet.ibm.com>
	 <1381356624.4971.26.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131009223652.GC5790@linux.vnet.ibm.com>
	 <1381359077.4971.37.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131009225617.GH11709@jtriplet-mobl1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 15:56 -0700, Josh Triplett wrote:

> I'd be really hesitant to introduce that type of direct assignment to an
> __rcu pointer without wrapping it in some appropriately named macro, or
> at the very least adding a comment.

Well, there is no special magic here, in this specific case :

- deleting an item in an rcu list

Check list_del_rcu(), and you'll notice there is no _barrier_

Adding correct barriers is good, but please do not add them when not
needed.

It makes code hard to understand.


ACCESS(*ptr) = value;

is clear and autodocumented, because it highlights the potential
problem, that is *ptr can be read without any barrier from another cpu.
So we ask the compiler to not write temporary garbage in it.

rcu_assign_pointer(*ptr, rcu_access_pointer(value)) 

is very confusing, because it hides the _real_ problem and add defensive
programming tricks.




