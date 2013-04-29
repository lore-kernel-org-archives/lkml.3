Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab3D2S7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:59:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44888 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab3D2S7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:59:11 -0400
Message-ID: <517EC2E9.4030303@zytor.com>
Date: Mon, 29 Apr 2013 11:58:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86, FPU: Do not use static_cpu_has before alternatives
References: <1367244262-29511-1-git-send-email-bp@alien8.de> <1367244262-29511-4-git-send-email-bp@alien8.de> <517E94E6.6040201@zytor.com> <20130429185123.GB7049@pd.tnic>
In-Reply-To: <20130429185123.GB7049@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 11:51 AM, Borislav Petkov wrote:
> On Mon, Apr 29, 2013 at 08:42:30AM -0700, H. Peter Anvin wrote:
>> I *was* considering adding static_cpu_has_safe() at some point which
>> would have a three-state jump, with the default (pre-alternatives)
>> jump pointing to dynamic detection code.
> 
> Actually, if we teach __static_cpu_has to do something like
> ALTERNATIVE_JUMP arch/x86/lib/copy_user_64.S but make the second
> alternative insn alt2 be none, i.e. no replacement, we can have:
> 
> * pre-alternatives: JMP dynamic_detection
> * post-alternatives:
>   - feature present: delete JMP
>   - feature absent: s/dynamic_detection/t_no/, i.e., patch only the label.

That is what I was referring to, yes.

> And even though asm goto supports multiple labels, we need to be able
> to either patch the label only or patch out the whole instruction -
> otherwise we'll be adding additional NOP bytes.

This doesn't seem to matter.

> I wonder if it would make sense to teach the alternatives to skip the
> opcode when patching so that we can say: "we only want to patch the
> label so we're patching in the offset now but leaving the single JMP
> opcode in there."
> 
> But for that we either need flags in struct alt_instr or do something
> ad-hoc apply_alternatives already does for relative jumps (0xe8).
> 
>> This might be useful here, on the other hand, perhaps it is acceptable
>> for use_eager_fpu() to be initially false?
> 
> Hmm, I don't know, FPU code is crazy. OTOH, does CR0.TS even matter on
> non-lazy FPU restore machines?

Yes, CR0.TS should be zero, or we'll get #NM traps when user space tries
to access the FPU.  For lazy restore CR0.TS should be set so we get the
#NM trap and can restore the FPU.

	-hpa



