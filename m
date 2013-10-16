Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3JPPu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:50:57 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:63206 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab3JPPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <525ECEA102000078000FB906@nat28.tlf.novell.com>
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
	<CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
	<525ECEA102000078000FB906@nat28.tlf.novell.com>
Date: Wed, 16 Oct 2013 08:50:54 -0700
X-Google-Sender-Auth: XauQIRppTFh0L8rmWjoql18G9cc
Message-ID: <CA+55aFybvU39HVUF4sON=Euieqy+Kqsby-DUU=8Gnpggm2fzjw@mail.gmail.com>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data selectors
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 8:36 AM, Jan Beulich <JBeulich@suse.com> wrote:
>
> In that case we use a 32-bit operand size [F]XRSTOR, and hence
> the upper halves get treated as selectors, and the offsets get
> zero-extended from the low halves, i.e. we preserve even more
> state for such a 64-bit environment now too (albeit I doubt any
> 64-bit code actually cares)

No, it does *not* preserve "more state".

It preserves *less* state, because the upper 32 bits of rip are now
corrupted. Any 64-bit application that actually looks at the FP
rip/rdp fields now get the WRONG VALUES.

The "upper bits zero" mode may be used just for JIT'ed code, for
example. It doesn't mean that you'd never have full 64-bit addresses,
so writing to the top half of the register *corrupts* that
information, because the top half bits are still relevant in general,
even if perhaps _one_ particular floating point exception happened
with the bits clear.

Now anybody looking at the FP state on the stack gets the wrong results.

More bits set is *not* "more state", when those bits are wrong.

              Linus
