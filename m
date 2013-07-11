Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab3GKKvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:51:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab3GKKvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:51:14 -0400
Date: Thu, 11 Jul 2013 12:51:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
In-Reply-To: <51DE8799.9020904@hitachi.com>
Message-ID: <alpine.LNX.2.00.1307111243420.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DE8799.9020904@hitachi.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Masami Hiramatsu wrote:

> > + * text_poke_bp() -- update instructions on live kernel on SMP
> > + * @addr:	address to patch
> > + * @opcode:	opcode of new instruction
> > + * @len:	length to copy
> > + * @handler:	address to jump to when the temporary breakpoint is hit
> > + *
> > +
> > + * Modify multi-byte instruction by using int3 breakpoint on SMP.
> > + * In contrary to text_poke_smp(), we completely avoid stop_machine() here,
> > + * and achieve the synchronization using int3 breakpoint.
> > + *
> > + * The way it is done:
> > + *	- add a int3 trap to the address that will be patched
> > + *	- sync cores
> 
> You don't need this "sync cores". (and your code didn't) :)

Right, my code originally did, but then I found discussion between you and 
hpa from 2009, where this was discussed and adjusted the code accordingly, 
but forgot to update the comment. Will do in v3.

> > + *	- update all but the first byte of the patched range
> > + *	- sync cores
> > + *	- replalace the first byte (int3) by the first byte of
> > + *	  replacing opcode
> > + *	- sync cores
> > + *
> > + * Note: must be called under text_mutex.
> > + */
> > +void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
> > +{
> > +	unsigned char int3 = 0xcc;
> > +
> 
> Here, you have to protect this code from others, since bp_* are
> global.

Caller is responsible for holding the text_mutex, so text_poke_bp() can't 
race with itself. And the proper consistency between text_poke_bp() and 
the notifier is achieved by the memory barriers.

So what exact scenario do you have in mind here, please?

> > +	bp_int3_handler = handler;
> > +	bp_int3_addr = (u8 *)addr + sizeof(int3);
> > +	bp_patching_in_progress = true;
> > +	/*
> > +	 * corresponding read barrier in int3 notifier for
> > +	 * making sure the in_progress flags is correctly ordered wrt.
> > +	 * patching */
> > +	smp_wmb();
> > +
> > +	text_poke(addr, &int3, sizeof(int3));

Thanks for the review,

-- 
Jiri Kosina
SUSE Labs
