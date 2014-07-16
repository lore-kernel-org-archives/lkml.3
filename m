Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965040AbaGPOkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:40:24 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:46376 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932951AbaGPOkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:40:22 -0400
Date: Wed, 16 Jul 2014 09:40:19 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140715174136.GG8690@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1407160937110.19544@gentwo.org>
References: <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org> <87lhs35p0v.fsf@rustcorp.com.au> <20140714113911.GM16041@linux.vnet.ibm.com> <alpine.DEB.2.11.1407141014390.25436@gentwo.org>
 <20140715101150.GA8690@linux.vnet.ibm.com> <alpine.DEB.2.11.1407150903570.10593@gentwo.org> <20140715143225.GC8690@linux.vnet.ibm.com> <alpine.DEB.2.11.1407150952580.10593@gentwo.org> <20140715174136.GG8690@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Paul E. McKenney wrote:

> Sorry, but whether you see it or not, there is a very real need for at
> least an smp_wmb() from the initializing code and at least an
> smp_read_barrier_depends() from the reading code.

Nope this is the wrong approach. Adding synchronization to basic
primitives that are designed to be as fast as possible is not good. Even
if it does nothing it tends to bloat over time and get the wrong ideas in
peoples heads.

Fixing this is possible by making sure that the remote cachelines are
evicted on alloc_percpu. alloc_percpu should not be allowed to return
until it has made sure that the remote cachelines all have been evicted.
On some weak ordered platforms that may require special instructions or
even an IPI to move the initilization done by alloc_percpu to the remote
cpu.

