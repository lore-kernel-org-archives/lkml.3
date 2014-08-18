Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaHRBD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:03:56 -0400
Received: from message.mylangara.bc.ca ([142.35.159.25]:50439 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaHRBDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:03:55 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Message-id: <fadbcf1c3708.53f150fb@langara.bc.ca>
Date: Mon, 18 Aug 2014 01:03:55 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: rt_sigreturn rejects a substitute stack frame as invalid.
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm not totally sure that GLibc's setcontext is safe to use in a
signal handler. So, I decided I was going to play things safe and let
rt_sigreturn switch stacks for me instead. However, rt_sigreturn seems
to reject my substitute stack frame as invalid and I'm not sure why.

Thank you,
Steven Stewart-Gallus

The code:

#include <stdio.h>
#include <signal.h>
#include <ucontext.h>
#include <unistd.h>

static ucontext_t alternate_context;

static char alternate_context_stack[SIGSTKSZ];

static char signal_stack[SIGSTKSZ];


static void alternate_context_func(void)
{
    puts("alternate context!");
}

static void switch_stack(int signo, siginfo_t *infop, void *untyped_ucontextp)
{
    ucontext_t * ucontextp = untyped_ucontextp;

    /* I'm not sure if setcontext is async-signal-safe so set the
     * context using the return from the signal handler.
     */

    *ucontextp = alternate_context;
#ifdef __linux__
    ucontextp->uc_mcontext.fpregs = &ucontextp->__fpregs_mem;
#endif
}

int main(void)
{
    {
        stack_t stack = { 0 };

        stack.ss_sp = signal_stack;
        stack.ss_size = sizeof signal_stack;

        sigaltstack(&stack, NULL);
    }

    getcontext(&alternate_context);
    alternate_context.uc_stack.ss_sp = alternate_context_stack;
    alternate_context.uc_stack.ss_size = sizeof alternate_context_stack;
    makecontext(&alternate_context, (void (*)(void))alternate_context_func, 0U);

    {
        struct sigaction action = { 0 };

        action.sa_sigaction = switch_stack;
        action.sa_flags = SA_SIGINFO;

        sigfillset(&action.sa_mask);

        sigaction(SIGRTMIN, &action, NULL);
    }

    raise(SIGRTMIN);

}

