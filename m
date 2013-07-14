Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3GNTX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:23:58 -0400
Received: from claw.goop.org ([74.207.240.146]:49552 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab3GNTXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:23:55 -0400
Message-ID: <51E2FACA.3050801@goop.org>
Date: Sun, 14 Jul 2013 12:23:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com> <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
In-Reply-To: <CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resent without HTML)

On 07/14/2013 10:19 AM, Linus Torvalds wrote:
> Now, there are possible cases where you want to make the size explicit
> because you are mixing memory operand sizes and there can be nasty
> performance implications of doing a 32-bit write and then doing a
> 64-bit read of the result. I'm not actually aware of us having ever
> worried/cared about it, but it's a possible source of trouble: mixing
> bitop instructions with non-bitop instructions can have some subtle
> interactions, and you need to be careful, since the size of the
> operand affects both the offset *and* the memory access size.
The SDM entry for BT mentions that the instruction may touch 2 or 4
bytes depending on the operand size, but doesn't specifically mention
that a 64 bit operation size touches 8 bytes - and it doesn't mention
anything at all about operand size and access size in BTR/BTS/BTC
(unless it's implied as part of the discussion about encoding the MSBs
of a constant bit offset in the offset of the addressing mode). Is that
an oversight?

>  The
> access size generally is meaningless from a semantic standpoint
> (little-endian being the only sane model), but the access size *can*
> have performance implications for the write queue forwarding.

It looks like that if the base address isn't aligned then neither is the
generated access, so you could get a protection fault if it overlaps a
page boundary, which is a semantic rather than purely operational
difference.

    J

