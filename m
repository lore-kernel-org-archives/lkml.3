Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3A1U1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:27:49 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40384 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3A1U1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:27:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130128202214.GD26407@google.com>
References: <20130124232024.GA584@google.com>
	<20130125180941.GA16896@redhat.com>
	<20130125191139.GA19247@redhat.com>
	<20130128181528.GA26407@google.com>
	<20130128182737.GC22465@mtj.dyndns.org>
	<20130128184933.GC26407@google.com>
	<20130128185552.GD22465@mtj.dyndns.org>
	<20130128202214.GD26407@google.com>
Date: Mon, 28 Jan 2013 12:27:45 -0800
X-Google-Sender-Auth: VEUkW08kXqSimyMy44N7k9KT9kA
Message-ID: <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
Subject: Re: [PATCH] generic dynamic per cpu refcounting
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Kent.

On Mon, Jan 28, 2013 at 12:22 PM, Kent Overstreet
<koverstreet@google.com> wrote:
> Could do that too, but then teardown gets really messy for the user - we
> need two synchronize_rcu()s:
>
> state := dying
>
> synchronize_rcu()
>
> /* Now nothing's changing the per cpu counters */
>
> Add per cpu counters to atomic counter counter
>
> /* Atomic counter is now consistent */
>
> state := dead
>
> synchronize_rcu()

I don't understand why we need two stages. What prevents the killing
thread from fetching percpu counters after dying passes one
synchronize_sched()?

> /* Now percpu_ref_put will check for ref == 0 */
>
> /* Drop initial ref */
>
> percpu_ref_put()
>
> And note that the first synchronize_rcu() is only needed when we had
> allocated per cpu counters, my current code skips it otherwise.

And regardless, at the interface level, can't it just provide
percpu_ref_put_base_ref(release_fn)?

Thanks.

-- 
tejun
