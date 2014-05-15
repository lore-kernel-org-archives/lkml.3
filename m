Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaEOQqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaEOQqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:46:18 -0400
Date: Thu, 15 May 2014 12:45:52 -0400
From: Kyle McMartin <kmcmarti@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: don't set READ_IMPLIES_EXEC for EM_AARCH64
Message-ID: <20140515164552.GB15570@redacted.bos.redhat.com>
References: <20140514185720.GI26038@redacted.bos.redhat.com>
 <20140515090535.GB27594@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515090535.GB27594@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:05:35AM +0100, Will Deacon wrote:
> Unfortunately, my understanding is that GCC currently requires this for
> nested functions, so this is an effective ABI breakage. On the plus side,
> the GCC guys are planning to fix that, so we should see PT_GNU_STACK getting
> used more frequently in the future.
> 

nested functions are a GNU extension, and aside from grub, I don't
think anyone really uses them. (At least, I certainly hope not.) Also,
ld.so already has a different idea from the kernel:
master@glibc:.% git grep DEFAULT_STACK_PERMS -- sysdeps/aarch64
(kyle@dreadnought:~/src/glibc)
sysdeps/aarch64/stackinfo.h:#define DEFAULT_STACK_PERMS (PF_R|PF_W)

ppc64 also does similarly, where they use the EXSTACK_DEFAULT in the
compat case, but their 64-bit ABI doesn't.

108 # define elf_read_implies_exec(ex, exec_stk) (is_32bit_task() ? \
109                 (exec_stk == EXSTACK_DEFAULT) : 0)

I've submitted a gcc patch to emit .note.GNU-stack on AArch64 (which I
suspect was just an oversight initially.) Which will mean that anything
that puts code on the stack will be annotated to require executable
stacks.

And, frankly, I think it's kind of strange to have any of the personality
bits set by default.

regards, Kyle
