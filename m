Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbaFSUmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:42:12 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:37833 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264AbaFSUmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:42:10 -0400
Date: Thu, 19 Jun 2014 15:42:07 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140617194017.GO4669@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406191540240.4002@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <alpine.DEB.2.11.1406171401350.22064@gentwo.org> <20140617194017.GO4669@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Paul E. McKenney wrote:

> > Similar in swapon(). The percpu allocation is performed before access to
> > the containing structure (via enable_swap_info).
>
> Those are indeed common use cases.  However...
>
> There is code where one CPU writes to another CPU's per-CPU variables.
> One example is RCU callback offloading, where a kernel thread (which
> might be running anywhere) dequeues a given CPU's RCU callbacks and
> processes them.  The act of dequeuing requires write access to that
> CPU's per-CPU rcu_data structure.  And yes, atomic operations and memory
> barriers are of course required to make this work.

In that case special care needs to be taken to get this right. True.

I typically avoid these scenarios by sending an IPI with a pointer to the
data structure. The modification is done by the cpu for which the per cpu
data is local.

Maybe rewrite the code to avoid writing to other processors percpu data
would be the right approach?

