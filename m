Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaLFJha (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 04:37:30 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:55570 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaLFJh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 04:37:26 -0500
Date: Sat, 6 Dec 2014 04:37:18 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOi?= =?UTF-8?B?bmllbA==?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141206043719.66a1aec6@as>
In-Reply-To: <20141205184808.GA2753@redhat.com>
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<20141205184808.GA2753@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2014 13:48:08 -0500
Dave Jones <davej@redhat.com> wrote:

> [ 1611.749570]  [<ffffffff81007948>] do_nmi+0xb8/0xf0
> [ 1611.750438]  [<ffffffff8179dd2a>] end_repeat_nmi+0x1e/0x2e
> [ 1611.751312]  [<ffffffff810a12c8>] ? preempt_count_add+0x18/0xb0
> [ 1611.752177]  [<ffffffff810a12c8>] ? preempt_count_add+0x18/0xb0
> [ 1611.753025]  [<ffffffff810a12c8>] ? preempt_count_add+0x18/0xb0
> [ 1611.753861]  <<EOE>>  [<ffffffff810fee07>] is_module_text_address+0x17/0x50
> [ 1611.754734]  [<ffffffff81092ab8>] __kernel_text_address+0x58/0x80
> [ 1611.755575]  [<ffffffff81006b5f>] print_context_stack+0x8f/0x100
> [ 1611.756410]  [<ffffffff81005540>] dump_trace+0x140/0x370
> [ 1611.757242]  [<ffffffff811e797f>] ? getname_flags+0x4f/0x1a0
> [ 1611.758072]  [<ffffffff811e797f>] ? getname_flags+0x4f/0x1a0
> [ 1611.758895]  [<ffffffff810137cb>] save_stack_trace+0x2b/0x50
> [ 1611.759720]  [<ffffffff811c29a0>] set_track+0x70/0x140
> [ 1611.760541]  [<ffffffff8178d993>] alloc_debug_processing+0x92/0x118
> [ 1611.761366]  [<ffffffff8178e5d6>] __slab_alloc+0x45f/0x56f
> [ 1611.762195]  [<ffffffff811e797f>] ? getname_flags+0x4f/0x1a0
> [ 1611.763024]  [<ffffffff8178dd57>] ? __slab_free+0x114/0x309
> [ 1611.763853]  [<ffffffff8137187e>] ? debug_check_no_obj_freed+0x17e/0x270
> [ 1611.764712]  [<ffffffff811e797f>] ? getname_flags+0x4f/0x1a0
> [ 1611.765539]  [<ffffffff811c6b26>] kmem_cache_alloc+0x1f6/0x270

So, every time there is a slab allocation the entire stack trace gets
saved as human readable text. And for each line in the trace,
is_module_text_address() can be called, which has huge overhead
walking the entire list of loaded modules. No wonder there are
timeouts...
