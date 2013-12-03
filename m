Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3LCTxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:53:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab3LCTxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:53:02 -0500
Date: Tue, 3 Dec 2013 20:53:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
	page directly
Message-ID: <20131203195314.GA19083@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz> <CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com> <20131203184909.GA17571@redhat.com> <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, Linus Torvalds wrote:
>
> On Tue, Dec 3, 2013 at 10:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > See the patch below. For review only
>
> Looks completely broken. Where do you guarantee that it's just a single page?

Yes, it is always a single page on all supported architectures.

This is even documented. I believe that "NOTE:" comment above
uprobe_write_opcode() tries to say this but I guess this comment
should be cleanuped.

And note also

	/* uprobe_write_opcode() assumes we don't cross page boundary */
	BUG_ON((uprobe->offset & ~PAGE_MASK) +
			UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);

in prepare_uprobe().

> Yes, on x86, UPROBE_SWBP_INSN_SIZE is a single byte.

And powerpc checks addr & 3 to ensure it doesn't cross the page.

> frankly, on x86, exactly *because* it's a single byte, I don't
> understand why we don't just write the damn thing with a single
> "put_user()", and stop with all the idiotic games.

Well, put_user() obviously can't work, mm != current->mm.
So we need get_user_pages() at least.

> No need to
> invalidate caches, even, because if you overwrite the first byte of an
> instruction, it all "just works".

I can't comment this, I do not know how the hardware actually works.

> Either the instruction decoding gets
> the old one, or it gets the new one.

Funny that.

I have asked why access_process_vm() can't work when I saw the initial
version of uprobes patches. I was told this can't work (even on x86).

And I was told that this idiotic games were suggested by someone
named Linus Torvalds ;)

> And on non-x86, UPROBE_SWBP_INSN_SIZE is not necessarily 1, so it
> could cross a page boundary.

Yes. If we support such an architecture we should obviously update
uprobe_write_opcode() accordingly.

Oleg.

