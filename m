Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab3KUBwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:52:55 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42188 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3KUBwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:52:53 -0500
MIME-Version: 1.0
Date: Wed, 20 Nov 2013 17:52:52 -0800
Message-ID: <CAHNPk65U3gaNGs74VGpiOJCaR_n0mdj53LLe=M-6cVnoKRHK5w@mail.gmail.com>
Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
From: Luis Lozano <llozano@chromium.org>
To: linux-kernel@vger.kernel.org,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>,
        Han Shen <shenhan@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been monitoring this thread and trying to understand how could
this happen.

I noticed that the definition for ARM of current_thread_info looks like this:

/*
 * how to get the thread information struct from C
 */
static inline struct thread_info *current_thread_info(void) __attribute_const__;

static inline struct thread_info *current_thread_info(void)
{
register unsigned long sp asm ("sp");
return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
}

Notice this has the __attribute_const__ marking which corresponds to
the __const__ gcc attribute described in:

http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html

This attribute marking seems wrong to me. This function depends on
global state (depends on SP).
This seems to go against the definition of what a "const" function is
(according to GCC)
I noticed this attribute marking is not set for the x86 definition.

Could this be confusing the compiler and causing the problem?
Can you try this?

It would be nice if you could point to the exact location in the code
where one could see the reordering happening. I tried to reproduce
with a small test case and I couldn't. Do you have a small test case?

Luis
