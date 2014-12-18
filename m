Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaLROlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:41:37 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:37137 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLROlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:41:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412170953280.8347@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141215075933.GD4898@js1304-P5Q-DELUXE>
	<CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com>
	<alpine.DEB.2.11.1412170953280.8347@gentwo.org>
Date: Thu, 18 Dec 2014 23:41:35 +0900
Message-ID: <CAAmzW4PkfyUpUzwq7=hpzU3d_A431oMWi3+u6hrCb_Md3dAScw@mail.gmail.com>
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
From: Joonsoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-18 1:10 GMT+09:00 Christoph Lameter <cl@linux.com>:
> On Wed, 17 Dec 2014, Joonsoo Kim wrote:
>
>> +       do {
>> +               tid = this_cpu_read(s->cpu_slab->tid);
>> +               c = this_cpu_ptr(s->cpu_slab);
>> +       } while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
>
>
> Assembly code produced is a bit weird. I think the compiler undoes what
> you wanted to do:

I checked my compiled code and it seems to be no problem.
gcc (Ubuntu 4.8.2-19ubuntu1) 4.8.2

Thanks.

>  46fb:       49 8b 1e                mov    (%r14),%rbx                         rbx = c =s->cpu_slab?
>     46fe:       65 4c 8b 6b 08          mov    %gs:0x8(%rbx),%r13               r13 = tid
>     4703:       e8 00 00 00 00          callq  4708 <kmem_cache_alloc+0x48>     ??
>     4708:       89 c0                   mov    %eax,%eax                        ??
>     470a:       48 03 1c c5 00 00 00    add    0x0(,%rax,8),%rbx                ??
>     4711:       00
>     4712:       4c 3b 6b 08             cmp    0x8(%rbx),%r13                   tid == c->tid
>     4716:       49 89 d8                mov    %rbx,%r8
>     4719:       75 e0                   jne    46fb <kmem_cache_alloc+0x3b>
>
