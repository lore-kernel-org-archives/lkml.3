Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3LCTAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:00:36 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:58245 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3LCTAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:00:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131203184909.GA17571@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
	<20131129183558.GA9803@redhat.com>
	<20131129195419.GB17656@two.firstfloor.org>
	<20131129200532.GA13561@redhat.com>
	<alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>
	<CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com>
	<20131203184909.GA17571@redhat.com>
Date: Tue, 3 Dec 2013 11:00:33 -0800
X-Google-Sender-Auth: ZxHsNR_m-9pwGzycAUzoWsi8QAM
Message-ID: <CA+55aFw3N=iNW2Ej6w7oksX5JDVis7QL=9X9D7JB_tKZhrjsLw@mail.gmail.com>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the page directly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 10:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> See the patch below. For review only

Looks completely broken. Where do you guarantee that it's just a single page?

Yes, on x86, UPROBE_SWBP_INSN_SIZE is a single byte. But quite
frankly, on x86, exactly *because* it's a single byte, I don't
understand why we don't just write the damn thing with a single
"put_user()", and stop with all the idiotic games. No need to
invalidate caches, even, because if you overwrite the first byte of an
instruction, it all "just works". Either the instruction decoding gets
the old one, or it gets the new one. We already rely on that for the
kernel bp instruction replacement.

And on non-x86, UPROBE_SWBP_INSN_SIZE is not necessarily 1, so it
could cross a page boundary. Yes, many architectures will have
alignment constraints, but I don't see this testing it.

Whatever. I think that code is bad, and you should feel bad. But hey,
I think it was pretty bad before too.

            Linus
