Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbaBKMOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:14:34 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51958 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaBKMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:14:31 -0500
Date: Tue, 11 Feb 2014 04:14:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@iki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org, mpm@selenic.com
Subject: Re: Memory allocator semantics
Message-ID: <20140211121426.GQ4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140102203320.GA27615@linux.vnet.ibm.com>
 <52F60699.8010204@iki.fi>
 <alpine.DEB.2.10.1402101304110.17517@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402101304110.17517@nuc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021112-0928-0000-0000-0000067CF7AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:07:58PM -0600, Christoph Lameter wrote:
> On Sat, 8 Feb 2014, Pekka Enberg wrote:
> 
> > So to be completely honest, I don't understand what is the race in (A) that
> > concerns the *memory allocator*.  I also don't what the memory allocator can
> > do in (B) and (C) which look like double-free and use-after-free,
> > respectively, to me. :-)
> 
> Well it seems to be some academic mind game to me.
> 
> Does an invocation of the allocator have barrier semantics or not?

In case (A), I don't see why the allocator should have barrier semantics
from kmalloc() to a matching kfree().  I would argue that any needed
barrier semantics must be provided by the caller.

In contrast, from kfree() to a kmalloc() returning some of the kfree()ed
memory, I believe the kfree()/kmalloc() implementation must do any needed
synchronization and ordering.  But that is a different set of examples,
for example, this one:

	CPU 0			CPU 1
	p->a = 42;		q = kmalloc(...); /* returning p */
	kfree(p);		q->a = 5;
				BUG_ON(q->a != 5);

Unlike the situation with (A), (B), and (C), in this case I believe
that it is kfree()'s and kmalloc()'s responsibility to ensure that
the BUG_ON() never triggers.

Make sense?

							Thanx, Paul

