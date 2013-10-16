Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766Ab3JPU21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:28:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36573 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761381Ab3JPU2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:28:25 -0400
Date: Wed, 16 Oct 2013 22:28:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131016202822.GI2675@laptop.programming.kicks-ass.net>
References: <20131012192203.GA21738@redhat.com>
 <20131014102426.GX3081@twins.programming.kicks-ass.net>
 <20131016200924.GA23214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016200924.GA23214@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:09:24PM +0200, Oleg Nesterov wrote:
> OK, so I think this code should die, it only adds the confusion.
> 
> Note also that at least on x86_64 "[vdso]" is not correct (if !vma_mm
> was possible), this adds more confusion.

Right, but x86_64 will return [vsyscall] and we'll never get there.

> > Also, the x86_32 arch_vma_name() didn't deal with the gate_vma (it still
> > doesn't appear to do so) as opposed to x86_64 which does.
> 
> Hmm... I am looking into arch/x86/vdso/vdso32-setup.c, it seems it does.
> But probably I missed something, this doesn't matter.

Right, vdso32-setup.c:arch_vma_name() never checks for vma ==
get_gate_vma(). So it would return NULL for the gate vma, not a proper
name like you argue it should.

> > But the main reason I added it was because task_mmu.c:show_map_vma() did
> > so too; I just wanted to be extra careful.
> 
> Yes, but this code can actually hit gate_vma. (and I'd say that if some
> arch/ has the global gate_vma-like vma's, it should implement arch_vma_name
> correctly, but this is off-topic).

I'd tend to agree with you there, but clearly this isn't/wasn't the case
and the generic code grew a fallback or so.

> ---------------------------------------------------------------------------
> Please look at these 2 simple patches. Initially I was going to send
> the 3rd patch, but I simply can't understand the "align" logic.
> 
> First of all, we surely do not need __GFP_ZERO for kzalloc(PATH_MAX),
> even if we need to nullify the alignment. So I am going to send another
> patch in any case.
> 
> But do we really need to nullify the extra bytes after strlen()? If yes,
> for what? If no, we can simply do s/kzalloc/kmalloc/ and kill that
> memset(tmp, 0, sizeof(tmp)) at the start.
> 
> Otoh. Why do we need the temporary string buffer (char tmp[16]) at all?
> We either use the result from d_path() (which has a room), or we use a
> string literal (may be returned by arch_vma_name), in the latter case
> it is safe to assume we can read the extra 7 bytes from .data?
> 
> IOW. Could you explain why the patch below (on top of 1-2) is wrong?

The perf buffer works in multiples of u64 (8 bytes), your proposed patch
gives a string shorter than size; remember:

	size = ALIGN(strlen(name)+1, sizeof(u64));

And therefore the copy into the buffer will access beyond the end of
string, copying god knows what into userspace.

So yes, we could go make sure all stings are proper multiples of 8 bytes
and pad with '\0' at the end, but the zalloc + strcpy was by far the
easiest way to not get it wrong and leak crap to userspace.
