Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3EVWU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:20:58 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:17604 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab3EVWU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:20:56 -0400
Message-ID: <1369261253.1682.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,sem: move restart loop to do_smart_update
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com
Date: Wed, 22 May 2013 15:20:53 -0700
In-Reply-To: <20130519183250.2a82d642@annuminas.surriel.com>
References: <51978696.6040705@colorfullife.com>
	 <20130519183250.2a82d642@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-05-19 at 18:32 -0400, Rik van Riel wrote:
> > 
> > One fix would be a loop in do_smart_update():
> > - first check the global queue
> > - then the per-semaphore queues
> > - if one of the per-semaphore queues made progress: check the global 
> > queue again
> > - if the global queue made progress: check the per semaphore queues again
> > ...
> 
> Would that be as simple as making do_smart_update() loop back to
> the top if update_queue on a single semaphore's queue returns
> a non-zero value (something was changed), and there are complex
> operations pending?

I've been looking at the code for a while and this approach seems quite
reasonable. I'd still like Manfred's feedback though. I ran pgbench and
your semop-multi program, nothing suspicious.

> ---8<---
> 
> Subject: ipc,sem: move restart loop to do_smart_update
> 
> A complex operation may be sleeping on a semaphore to become
> a certain value. A sleeping simple operation may turn the
> semaphore into that value.
> 
> Having the restart loop inside update_queue means we may be
> missing the complex operation (which lives on a different
> queue), and result in a semaphore lockup.
> 
> The lockup can be avoided by moving the restart loop into
> do_smart_update, so the list of pending complex operations
> will also be checked if required.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Manfred Spraul <manfred@colorfullife.com>

Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

