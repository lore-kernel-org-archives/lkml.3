Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaJLRgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:36:39 -0400
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:17452 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbaJLRgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:36:38 -0400
X-Greylist: delayed 2173 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2014 13:36:38 EDT
Date: Sun, 12 Oct 2014 12:00:03 -0500
From: Jeff Epler <jepler@unpythonic.net>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clean up stack access code in irq_32.c
Message-ID: <20141012170003.GA96036@unpythonic.net>
References: <20141012114353.4aa73c00@as>
 <17ED2609-CA12-4842-8ECE-A1F08693FC01@zytor.com>
 <20141012115332.5ec3db90@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012115332.5ec3db90@as>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like the proposed variant still miscompiles in clang 3.4 and 3.5, the
two versions I had handy to test.

I extracted your code to a simple standalone C translation unit and
inspected various compilers' results via objdump.

// cut here for cso.c
struct thread_info { long l[32]; }; // who knows

#define STACK_WARN (1024)
#define PAGE_SIZE (4096)

#define THREAD_SIZE_ORDER      2
#define THREAD_SIZE            (PAGE_SIZE << THREAD_SIZE_ORDER)
#define THREAD_SIZE_MASK       (THREAD_SIZE - 1)
#define CURRENT_MASK           (~THREAD_SIZE_MASK)

/* how to get the current stack pointer from C */
#define current_stack_pointer ({               \
       register unsigned long sp asm("esp");   \
       sp;                                     \
})

int check_stack_overflow0(void)
{
       long sp;

       __asm__ __volatile__("andl %%esp,%0" :
                            "=r" (sp) : "0" (THREAD_SIZE - 1));

       return sp < (sizeof(struct thread_info) + STACK_WARN);
}

int check_stack_overflow1(void)
{
       return (current_stack_pointer & THREAD_SIZE_MASK)
              < sizeof(struct thread_info) + STACK_WARN;
}
// end cso.c

Typical compiler invocation:
        clang-3.5 -m32 -Os -c cso.c

Both clang-3.4 and clang-3.5 as packaged for debian jessie seem to get
check_stack_overflow1 wrong, yielding a function which always returns true:

    00000000 <check_stack_overflow1>:
       0:   b8 01 00 00 00          mov    $0x1,%eax
       5:   c3                      ret    

Jeff
