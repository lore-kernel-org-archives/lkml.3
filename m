Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab3EFVMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:12:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55829 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759040Ab3EFVMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:12:48 -0400
Date: Mon, 6 May 2013 22:12:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matt Turner <mattst88@gmail.com>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] alpha: spinlock: don't perform memory access in locked
 critical section
Message-ID: <20130506211238.GA24282@mudshark.cambridge.arm.com>
References: <1367870465-23948-1-git-send-email-will.deacon@arm.com>
 <CAEdQ38HnWbUB=ZNCZeYz8GZH3U4bv_Uag8WL2zT0D=GMcoT+2A@mail.gmail.com>
 <20130506205329.GO25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130506205329.GO25399@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al, Matt,

On Mon, May 06, 2013 at 09:53:30PM +0100, Al Viro wrote:
> On Mon, May 06, 2013 at 01:19:51PM -0700, Matt Turner wrote:
> 
> > I'm not sure of the interpretation that LDA counts as a memory access.
> > 
> > The manual says it's Ra <- Rbv + SEXT(disp).
> > 
> > It's not touching memory that I can see.
> 
> More to the point, the same manual gives explicit list of instructions
> that shouldn't occur between LDx_L and STx_C, and LDA does not belong to any
> of those.  I suspect that Will has misparsed the notations in there - LDx is
> present in the list, but it's _not_ "all instructions with mnemonics starting
> with LD", just the 4 "load integer from memory" ones.  FWIW, instructions
> with that encoding (x01xxx<a:5><b:5><offs:16>) are grouped so:
> 	LDAx - LDA, LDAH; load address
> 	LDx -  LDL, LDQ, LDBU, LDWU; load memory data into integer register
> 	LDQ_U; load unaligned
> 	LDx_L - LDL_L, LDQ_L; load locked
> 	STx_C - STL_C, STQ_C; store conditional
> 	STx - STL, STQ, STB, STW; store
> 	STQ_U; store unaligned

Your suspicions are right! I did assume that LDA fell under the LDx class,
so apologies for the false alarm. I suspect I should try and get out more,
rather than ponder over this reference manual.

The other (hopefully also wrong) worry that I had was when the manual
states that:

`If the virtual and physical addresses for a LDx_L and STx_C sequence are
 not within the same naturally aligned 16-byte sections of virtual and
 physical memory, that sequence may always fail, or may succeed despite
 another processor’s store to the lock range; hence, no useful program
 should do this'

This seems like it might have a curious interaction with CoW paging if
userspace is trying to use these instructions for a lock, since the
physical address for the conditional store might differ from the one which
was passed to the load due to CoW triggered by a different thread. Anyway,
I was still thinking about that one and haven't got as far as TLB
invalidation yet :)

> They all have the same encoding, naturally enough (operation/register/address
> representation), but that's it...  See section 4.2 in reference manual for
> details; relevant note follows discussion of LDx_L and it spells the list
> out.  LDx is present, LDAx isn't (and neither is LDA by itself).

Indeed, and looking at the disassembly, you can see the immediate operand to
LDA encoded into the instruction. I thought that perhaps it might behave
like ldr =<imm> on ARM, which goes and fetches the immediate value from the
literal pool.

Cheers for the explanation,

Will
