Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3CWPxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 11:53:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57141 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab3CWPxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 11:53:02 -0400
Date: Sat, 23 Mar 2013 16:52:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 12/29] x86, tsx: Add a per thread transaction disable
 count
Message-ID: <20130323155256.GB10811@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	x86@kernel.org, Andi Kleen <ak@linux.intel.com>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
 <1364001923-10796-13-git-send-email-andi@firstfloor.org>
 <20130323115115.GA10821@pd.tnic>
 <20130323135156.GJ20853@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130323135156.GJ20853@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 02:51:56PM +0100, Andi Kleen wrote:
> Bit fields are slower and larger in code and unlike the others this is
> on hot paths.

Really? Let's see:

unsigned:
=========

	.file 8 "/w/kernel/linux-2.6/arch/x86/include/asm/thread_info.h"
	.loc 8 211 0
#APP
# 211 "/w/kernel/linux-2.6/arch/x86/include/asm/thread_info.h" 1
	movq %gs:kernel_stack,%rax	#, pfo_ret__
# 0 "" 2
.LVL238:
#NO_APP

...									# AMD F10h			SNB

disable:
	incl    -8056(%rax)     # ti_25->notxn				# INC mem: 4			; 6

test:
        cmpl    $0, -8056(%rax) #, ti_24->notxn				# CMP mem, imm: 4		; 1

reenable:
	decl    -8056(%rax)     # ti_25->notxn				# DEC mem: 4			; 6


bitfield:
=========

	.file 8 "/w/kernel/linux-2.6/arch/x86/include/asm/thread_info.h"
	.loc 8 211 0
#APP
# 211 "/w/kernel/linux-2.6/arch/x86/include/asm/thread_info.h" 1
	movq %gs:kernel_stack,%rax	#, pfo_ret__
# 0 "" 2
.LVL238:
#NO_APP

disable:
	xorb    $4, -8056(%rax) #,					# XOR mem, imm: 1		; 0

test:
        testb   $4, -8056(%rax) #,					# TEST mem, imm: 4		; -

reenable:
        xorb    $4, -8056(%rax) #,					# XOR mem, imm: 1		; 0


So let's explain. The AMD F10h column shows the respective instruction
latencies on AMD F10h. All instructions are DirectPath single.

The SNB column is something similar which I could find for Intel
Sandybridge: http://www.agner.org/optimize/instruction_tables.pdf. I'm
assuming Agner Fog's measurements are more or less accurate.

And wow, the XOR is *actually* faster. That's whopping three cycles on
AMD. Similar observation on SNB.

Now let's look at decoding bandwidth:

unsigned:
=========

disable:
  13:   ff 80 88 e0 ff ff       incl   -0x1f78(%rax)

test:
   9:   83 b8 88 e0 ff ff 00    cmpl   $0x0,-0x1f78(%rax)

reenable:
  13:   ff 88 88 e0 ff ff       decl   -0x1f78(%rax)


bitfield:
=========

disable:
  13:   80 b0 88 e0 ff ff 04    xorb   $0x4,-0x1f78(%rax)

test:
   9:   f6 80 88 e0 ff ff 04    testb  $0x4,-0x1f78(%rax)

reenable:
  13:   80 b0 88 e0 ff ff 04    xorb   $0x4,-0x1f78(%rax)

This particular XOR encoding is 1 byte longer, the rest is on-par.

Oh, and compiler is gcc (Debian 4.7.2-5) 4.7.2.

So you were saying?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
