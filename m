Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3JLRhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:37:37 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:58180 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3JLRhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:37:36 -0400
Date: Sat, 12 Oct 2013 19:37:34 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 tip/core/rcu 07/13] ipv6/ip6_tunnel: Apply rcu_access_pointer() to avoid sparse false positive
Message-ID: <20131012173734.GC20321@order.stressinduktion.org>
Mail-Followup-To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
	mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
	akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
	niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
	rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
	darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
References: <20131009225617.GH11709@jtriplet-mobl1> <1381360675.4971.45.camel@edumazet-glaptop.roam.corp.google.com> <20131009234040.GB14055@jtriplet-mobl1> <1381363960.4971.55.camel@edumazet-glaptop.roam.corp.google.com> <20131010002833.GJ5790@linux.vnet.ibm.com> <20131010020422.GB24368@order.stressinduktion.org> <20131010190532.GQ5790@linux.vnet.ibm.com> <20131012022508.GA20321@order.stressinduktion.org> <20131012075336.GA5790@linux.vnet.ibm.com> <20131012164345.GB20321@order.stressinduktion.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131012164345.GB20321@order.stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 06:43:45PM +0200, Hannes Frederic Sowa wrote:
> Regarding the volatile access, I hope that the C11 memory model
> and enhancements to the compiler will some day provide a better
> way to express the semantics of what is tried to express here
> (__atomic_store_n/__atomic_load_n with the accompanied memory model,
> which could be even weaker to what a volatile access would enfore
> now and could guarantee atomic stores/loads).

I just played around a bit more. Perhaps we could try to warn of silly
usages of ACCESS_ONCE():

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -349,7 +349,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  * use is to mediate communication between process-level code and irq/NMI
  * handlers, all running on the same CPU.
  */
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+#define ACCESS_ONCE(x) (*({						\
+		compiletime_assert(sizeof(typeof(x)) <= sizeof(typeof(&x)), \
+				   "ACCESS_ONCE likely not atomic");	\
+		(volatile typeof(x) *)&(x);				\
+}))
 
 /* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
 #ifdef CONFIG_KPROBES

