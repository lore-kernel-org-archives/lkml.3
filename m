Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3JQQHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:07:32 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:51072 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab3JQQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:07:31 -0400
Date: Thu, 17 Oct 2013 18:07:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mike Galbraith <bitbucket@online.de>, Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd
Message-ID: <20131017160726.GJ28963@localhost.localdomain>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com>
 <20131017135509.GB28963@localhost.localdomain>
 <00000141c704b634-d1e47864-686f-40a9-b42e-cd5416dec367-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141c704b634-d1e47864-686f-40a9-b42e-cd5416dec367-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 03:24:36PM +0000, Christoph Lameter wrote:
> On Thu, 17 Oct 2013, Frederic Weisbecker wrote:
> 
> > > -	/* We can run anywhere, unlike our parent keventd(). */
> > > -	set_cpus_allowed_ptr(current, cpu_all_mask);
> > > +	/* We can run anywhere kthreadd can run */
> > > +	set_kthreadd_affinity();
> >
> > If you really want your isolated CPUs to be undisturbed, you need this affinity to
> > be set before the creation of this usermode helper. Otherwise it's going to run to any random
> > place before you call the above function.
> >
> > Is there now way to control the kworker affinity which create this usermode helpers threads
> > instead?
> 
> The invocation is coming from keventd so the affinity seems to be set to
> a different cpu before we get the thread moved.

Looking at alloc_singlethread_workqueue(), it seems to create a kthread by using
kthread_create(). So I guess the resulting works have the affinity of that kthread.
And thus call_usermodehelper() initially has that affinity, until it spreads it explicitly
to all CPUs.

Couldn't we instead make kthread children (those created with kthread_create()) to inherit
kthread initial affinity? Currently kthread's children have cpu_all_mask. We could change
that behaviour. This way the initial kthread affinity could be inherited all along.

> 
> A tsc loop is running on the processor that gets hit by the usermodehelper spawns.
> 
> We see spawning by the tty notifier (when typing on a vt) as well as by a
> mellanox driver (periodically).> 
