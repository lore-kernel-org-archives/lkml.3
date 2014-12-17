Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaLQQKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:10:47 -0500
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:34673 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbaLQQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:10:46 -0500
Date: Wed, 17 Dec 2014 10:10:43 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
In-Reply-To: <CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412170953280.8347@gentwo.org>
References: <20141210163017.092096069@linux.com> <20141215075933.GD4898@js1304-P5Q-DELUXE> <CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Joonsoo Kim wrote:

> +       do {
> +               tid = this_cpu_read(s->cpu_slab->tid);
> +               c = this_cpu_ptr(s->cpu_slab);
> +       } while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));


Assembly code produced is a bit weird. I think the compiler undoes what
you wanted to do:

 46fb:       49 8b 1e                mov    (%r14),%rbx				rbx = c =s->cpu_slab?
    46fe:       65 4c 8b 6b 08          mov    %gs:0x8(%rbx),%r13		r13 = tid
    4703:       e8 00 00 00 00          callq  4708 <kmem_cache_alloc+0x48>	??
    4708:       89 c0                   mov    %eax,%eax			??
    470a:       48 03 1c c5 00 00 00    add    0x0(,%rax,8),%rbx		??
    4711:       00
    4712:       4c 3b 6b 08             cmp    0x8(%rbx),%r13			tid == c->tid
    4716:       49 89 d8                mov    %rbx,%r8
    4719:       75 e0                   jne    46fb <kmem_cache_alloc+0x3b>

