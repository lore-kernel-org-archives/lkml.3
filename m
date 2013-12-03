Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3LCTWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:22:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46923 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab3LCTWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:22:03 -0500
Message-ID: <529E2F0C.8070405@zytor.com>
Date: Tue, 03 Dec 2013 11:20:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
CC: Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
 page directly
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>	<20131129183558.GA9803@redhat.com>	<20131129195419.GB17656@two.firstfloor.org>	<20131129200532.GA13561@redhat.com>	<alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>	<CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com>	<20131203184909.GA17571@redhat.com> <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com>
In-Reply-To: <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 11:00 AM, Linus Torvalds wrote:
> 
> Yes, on x86, UPROBE_SWBP_INSN_SIZE is a single byte. But quite
> frankly, on x86, exactly *because* it's a single byte, I don't
> understand why we don't just write the damn thing with a single
> "put_user()", and stop with all the idiotic games. No need to
> invalidate caches, even, because if you overwrite the first byte of an
> instruction, it all "just works". Either the instruction decoding gets
> the old one, or it gets the new one. We already rely on that for the
> kernel bp instruction replacement.
> 
> And on non-x86, UPROBE_SWBP_INSN_SIZE is not necessarily 1, so it
> could cross a page boundary. Yes, many architectures will have
> alignment constraints, but I don't see this testing it.
> 
> Whatever. I think that code is bad, and you should feel bad. But hey,
> I think it was pretty bad before too.
> 

I guess it would have to be checked, but I would be *highly* surprised
if UPROBE_SWBP_INSN_SIZE ever[1] could be anything than the fundamental
instruction quantum, which means it should never be able to wrap a page,
but *also* should mean it should be able to just be put_user()'d
followed by whatever synchronization necessary to make it globally visible.

	-hpa

