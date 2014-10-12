Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaJLRkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:40:20 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36321 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaJLRkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:40:17 -0400
Date: Sun, 12 Oct 2014 12:40:13 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Jeff Epler <jepler@unpythonic.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clean up stack access code in irq_32.c
Message-ID: <20141012124013.41ea7473@as>
In-Reply-To: <20141012170003.GA96036@unpythonic.net>
References: <20141012114353.4aa73c00@as>
	<17ED2609-CA12-4842-8ECE-A1F08693FC01@zytor.com>
	<20141012115332.5ec3db90@as>
	<20141012170003.GA96036@unpythonic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2014 12:00:03 -0500
Jeff Epler <jepler@unpythonic.net> wrote:

> It looks like the proposed variant still miscompiles in clang 3.4 and 3.5, the
> two versions I had handy to test.
> 
> I extracted your code to a simple standalone C translation unit and
> inspected various compilers' results via objdump.
> 

Wow, my little test program below worked with clang by accident. I was
building it with both printf() calls enabled and it printed out the
same results on both output lines. But commenting out the first line
reveals that it simply leaves whatever junk is on the stack there
for the first arg when it calls printf().

#define _GNU_SOURCE

#include <string.h>
#include <stdio.h>
#include <unistd.h>

#define current_stack_pointer ({		\
	unsigned long sp;			\
	asm("mov %%esp,%0" : "=g" (sp));	\
	sp;					\
})

#define current_stack_pointer2 ({		\
	register unsigned long sp asm("esp");	\
	sp;					\
})

int main(int argc, char **argv)
{
//	printf("%X %X\n", current_stack_pointer , __builtin_frame_address(0));
	printf("%X %X\n", current_stack_pointer2, __builtin_frame_address(0));

	return 0;
}
