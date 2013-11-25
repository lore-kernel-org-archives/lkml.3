Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3KYJcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:32:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34981 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3KYJcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:32:07 -0500
Date: Mon, 25 Nov 2013 10:31:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Message-ID: <20131125093157.GU10022@twins.programming.kicks-ass.net>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131122191429.GA13308@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122191429.GA13308@amt.cnet>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 05:14:29PM -0200, Marcelo Tosatti wrote:
> Also, there is no guarantee of termination (as long as sptes are
> deleted with the correct timing). BTW, can't see any guarantee of
> termination for rculist nulls either (a writer can race with a lockless
> reader indefinately, restarting the lockless walk every time).

What's an rculist null? rculists have regular termination conditions,
they'll reach the end (also head, due to circular etc..) in N steps,
where N is the number of elements.

Of course you can keep adding elements to protract this situation, but
you'll run out of memory eventually -- you also have to make sure to
insert them after the element being read, otherwise the iteration will
simply miss them.

Deleting an element preserves the element itself -- it has to be
RCU-freed to be part of an rculist, and the element also preserves its
fwd link, so any iterator will either not see the element, or if they're
at the element, they'll continue their iteration as normal (rculist
doesn't have backward iterators).

A deleted element may not be re-used before an RCU grace period has
lapsed. Same as for freeing such an element. So if you want to move an
rculist element you need to:

  list_del_rcu()
  synchronize_rcu();
  list_add_rcu();

Or use the list_splice_init_rcu() primitive which also explicitly takes
a @sync argument.


