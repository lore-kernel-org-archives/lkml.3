Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbaFSU22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:28:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:55336 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaFSU21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:28:27 -0400
Date: Thu, 19 Jun 2014 22:28:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@gentwo.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
In-Reply-To: <alpine.DEB.2.11.1406191519090.4002@gentwo.org>
Message-ID: <alpine.DEB.2.10.1406192226470.5170@nanos>
References: <53A2F406.4010109@oracle.com> <alpine.DEB.2.11.1406191001090.2785@gentwo.org> <20140619165247.GA4904@linux.vnet.ibm.com> <alpine.DEB.2.10.1406192127100.5170@nanos> <alpine.DEB.2.11.1406191519090.4002@gentwo.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Christoph Lameter wrote:
> On Thu, 19 Jun 2014, Thomas Gleixner wrote:
> 
> > Well, no. Look at the callchain:
> >
> > __call_rcu
> >     debug_object_activate
> >        rcuhead_fixup_activate
> >           debug_object_init
> >               kmem_cache_alloc
> >
> > So call rcu activates the object, but the object has no reference in
> > the debug objects code so the fixup code is called which inits the
> > object and allocates a reference ....
> 
> So we need to init the object in the page struct before the __call_rcu?
 
Looks like RCU is lazily relying on the state callback to initialize
the objects.

There is an unused debug_init_rcu_head() inline in kernel/rcu/update.c

Paul????


