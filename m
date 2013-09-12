Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3ILMZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:25:40 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:41793 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3ILMZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:25:38 -0400
Date: Thu, 12 Sep 2013 14:25:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
Message-ID: <20130912122534.GA18794@gmail.com>
References: <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
 <20130910212509.GA18147@laptop.programming.kicks-ass.net>
 <CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com>
 <20130911131323.GQ31370@twins.programming.kicks-ass.net>
 <CA+55aFyxcHvQUe_h8cyQrNbGJ6-G_NQnK9pVenABLjCF-7WMXg@mail.gmail.com>
 <20130911185944.GA1798@laptop.programming.kicks-ass.net>
 <CA+55aFxDbqeFumkVApf-L2pi+FQn06GQqQf4rWkzOC4LF=fn=A@mail.gmail.com>
 <20130912022040.GT31370@twins.programming.kicks-ass.net>
 <CA+55aFwdS5-U8UtjZ8qsKyn7ap05MPXMFeU-GXgU2PE5KrCrHg@mail.gmail.com>
 <20130912115155.GV31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912115155.GV31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> So the increase is there too, doing a objdump -D on them the first 
> difference is:
> 
> 0000000000000660 <do_page_add_anon_rmap>:
>      660:	55                   	push   %rbp
>      661:	48 89 e5             	mov    %rsp,%rbp
>      664:	48 83 ec 20          	sub    $0x20,%rsp
>      668:	48 89 5d f0          	mov    %rbx,-0x10(%rbp)
>      66c:	4c 89 65 f8          	mov    %r12,-0x8(%rbp)
>      670:	48 89 fb             	mov    %rdi,%rbx
>      673:	f0 ff 47 18          	lock incl 0x18(%rdi)
>      677:	0f 94 c0             	sete   %al
>      67a:	84 c0                	test   %al,%al
>      67c:	75 12                	jne    690 <do_page_add_anon_rmap+0x30>
>      67e:	48 8b 5d f0          	mov    -0x10(%rbp),%rbx
>      682:	4c 8b 65 f8          	mov    -0x8(%rbp),%r12
>      686:	c9                   	leaveq 
> 
> vs.:
> 
> 0000000000000660 <do_page_add_anon_rmap>:
>      660:	55                   	push   %rbp
>      661:	48 89 e5             	mov    %rsp,%rbp
>      664:	48 83 ec 20          	sub    $0x20,%rsp
>      668:	48 89 5d e0          	mov    %rbx,-0x20(%rbp)
>      66c:	4c 89 65 e8          	mov    %r12,-0x18(%rbp)
>      670:	48 89 fb             	mov    %rdi,%rbx
>      673:	4c 89 6d f0          	mov    %r13,-0x10(%rbp)
>      677:	4c 89 75 f8          	mov    %r14,-0x8(%rbp)
>      67b:	f0 ff 47 18          	lock incl 0x18(%rdi)
>      67f:	74 17                	je     698 <do_page_add_anon_rmap+0x38>
>      681:	48 8b 5d e0          	mov    -0x20(%rbp),%rbx
>      685:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
>      689:	4c 8b 6d f0          	mov    -0x10(%rbp),%r13
>      68d:	4c 8b 75 f8          	mov    -0x8(%rbp),%r14
>      691:	c9                   	leaveq 
> 
> For some obscure (to me) reason the new fangled asm goto construct 
> generates a bunch of extra MOVs.

It adds two pairs of MOVs that shows that R13 and R14 got clobbered, but 
the change also got rid of of a SETE and a TEST here:

>      673:	f0 ff 47 18          	lock incl 0x18(%rdi)
>      677:	0f 94 c0             	sete   %al
>      67a:	84 c0                	test   %al,%al
>      67c:	75 12                	jne    690 <do_page_add_anon_rmap+0x30>

so there's a slight increase in size, but the extra instructions look 
rather lightweight and it could all go away if asm goto is improved ...

It would all be very sweet if all those clobbers went away.

Thanks,

	Ingo
