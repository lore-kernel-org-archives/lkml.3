Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3C0SZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:25:40 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:34772 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3C0SZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:25:38 -0400
MIME-Version: 1.0
Date: Wed, 27 Mar 2013 14:25:36 -0400
X-Google-Sender-Auth: MdGVr8ncEQj5b0l_HRwbWdh1IDk
Message-ID: <CAKb7UviwOk9asT=WxYgDUzfm3J+tGXobroUycpoTvzOX5kkofQ@mail.gmail.com>
Subject: system death under oom - 3.7.9
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: linux-kernel@vger.kernel.org
Cc: nouveau@lists.freedesktop.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My system died last night apparently due to OOM conditions. Note that
I don't have any swap set up, but my understanding is that this is not
required. The full log is at: http://pastebin.com/YCYUXWvV. It was in
my messages, so I guess the system took a bit to die completely.

nouveau is somewhat implicated, as it is the first thing that hits an
allocation failure in nouveau_vm_create, and has a subsequent warn in
nouveau_mm_fini, but then there's a GPF in
__alloc_skb/__kmalloc_track_caller (and I'm using SLUB). Here is a
partial disassembly for __kmalloc_track_caller:

   0xffffffff811325b1 <+138>:   e8 a0 60 56 00  callq
0xffffffff81698656 <__slab_alloc.constprop.68>
   0xffffffff811325b6 <+143>:   49 89 c4        mov    %rax,%r12
   0xffffffff811325b9 <+146>:   eb 27   jmp    0xffffffff811325e2
<__kmalloc_track_caller+187>
   0xffffffff811325bb <+148>:   49 63 45 20     movslq 0x20(%r13),%rax
   0xffffffff811325bf <+152>:   48 8d 4a 01     lea    0x1(%rdx),%rcx
   0xffffffff811325c3 <+156>:   49 8b 7d 00     mov    0x0(%r13),%rdi
   0xffffffff811325c7 <+160>:   49 8b 1c 04     mov    (%r12,%rax,1),%rbx
   0xffffffff811325cb <+164>:   4c 89 e0        mov    %r12,%rax
   0xffffffff811325ce <+167>:   48 8d 37        lea    (%rdi),%rsi
   0xffffffff811325d1 <+170>:   e8 3a 38 1b 00  callq
0xffffffff812e5e10 <this_cpu_cmpxchg16b_emu>

The GPF happens at +160, which is in the argument setup for the
cmpxchg in slab_alloc_node. I think it's the call to
get_freepointer(). There was a similar bug report a while back,
https://lkml.org/lkml/2011/5/23/199, and the recommendation was to run
with slub debugging. Is that still the case, or is there a simpler
explanation? I can't reproduce this at will, not sure how many times
this has happened but definitely not many.

  -ilia
