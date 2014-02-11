Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaBKNUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:20:04 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35306 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaBKNUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:20:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140211121426.GQ4250@linux.vnet.ibm.com>
References: <20140102203320.GA27615@linux.vnet.ibm.com>
	<52F60699.8010204@iki.fi>
	<alpine.DEB.2.10.1402101304110.17517@nuc>
	<20140211121426.GQ4250@linux.vnet.ibm.com>
Date: Tue, 11 Feb 2014 15:20:01 +0200
X-Google-Sender-Auth: cDBYYvMInj7uKHFLtJI6vrjdwEE
Message-ID: <CAOJsxLET90NRnEKeFjWKWTgZm+otSSwfCkhFga2hGjhV12nz9Q@mail.gmail.com>
Subject: Re: Memory allocator semantics
From: Pekka Enberg <penberg@kernel.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 2:14 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> In contrast, from kfree() to a kmalloc() returning some of the kfree()ed
> memory, I believe the kfree()/kmalloc() implementation must do any needed
> synchronization and ordering.  But that is a different set of examples,
> for example, this one:
>
>         CPU 0                   CPU 1
>         p->a = 42;              q = kmalloc(...); /* returning p */
>         kfree(p);               q->a = 5;
>                                 BUG_ON(q->a != 5);
>
> Unlike the situation with (A), (B), and (C), in this case I believe
> that it is kfree()'s and kmalloc()'s responsibility to ensure that
> the BUG_ON() never triggers.
>
> Make sense?

I'm not sure...

It's the caller's responsibility not to touch "p" after it's handed over to
kfree() - otherwise that's a "use-after-free" error.  If there's some reordering
going on here, I'm tempted to blame the caller for lack of locking.

                           Pekka
