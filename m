Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3KVD3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:29:36 -0500
Received: from one.firstfloor.org ([193.170.194.197]:35034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3KVD3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:29:35 -0500
Date: Fri, 22 Nov 2013 04:29:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a text_poke syscall
Message-ID: <20131122032934.GK29695@two.firstfloor.org>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
 <20131121182623.GA21535@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121182623.GA21535@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the code review.

> This looks a bit confusing, afaics we can avoid the duplications:
> 
> 	// also handles bp_target_mm == NULL case
> 	if (user_mode_vm(regs) && current->mm != bp_target_mm)
> 		return 0;

I had that originally in my code, but I was worried there
were any threads with mm == NULL and user_mode_vm still true
(maybe some BIOS code or somesuch)

So I ended up with the longer, but safer, variant.


> > +	err = 0;
> > +	mutex_lock(&text_mutex);
> > +	bp_target_mm = current->mm;
> > +	bp_int3_addr = (u8 *)addr + 1;
> > +	__text_poke_bp(pages, 
> > +		       (unsigned long)addr & ~PAGE_MASK,
> > +		       insn, len, handler);
> 
> This doesn't look right if npages == 2 but get_user_pages_fast() returns 1.

True, i'll add an error out.

> 
> __text_poke() checks pages[1] != NULL, but in this case it assumes
> that memcpy(vaddr, opcode, len) should fit into the 1st page.
> 
> 
> Ingo, Andi, I do not think that it is good idea to implement this
> via ptrace. If nothing else, you need to fork the tracer which can
> do PTRACE_POKETEXT.

Yes I agree, ptrace is not the right way to do this.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
