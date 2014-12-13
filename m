Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaLMALr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 19:11:47 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40121 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbaLMALp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 19:11:45 -0500
MIME-Version: 1.0
In-Reply-To: <548B7764.2060608@sr71.net>
References: <20141212191213.579887D2@viggo.jf.intel.com> <548B4E75.5010507@amacapital.net>
 <548B4FBE.5090101@sr71.net> <CALCETrW4f3EUYGG_zyzb7sZBXaoW3eHMpTn3dd3WpDgJq2HjtA@mail.gmail.com>
 <548B60F4.6020903@sr71.net> <CALCETrVZcED1x+YV4V+c9nnieaz8DMbO4D455h2QYF__jX-DKg@mail.gmail.com>
 <548B7764.2060608@sr71.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 12 Dec 2014 16:11:23 -0800
Message-ID: <CALCETrVEDS9Os5P11ub+FxHsDACgDWnkC4N6yqquQSfUv-=3kw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit kernels
To: Dave Hansen <dave@sr71.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 3:16 PM, Dave Hansen <dave@sr71.net> wrote:
> On 12/12/2014 03:04 PM, Andy Lutomirski wrote:
>> Anyway, do your patches handle the case where a 32-bit app maliciously
>> executes a 64-bit mpx insn with a very large address?  I think it's
>> okay, but I might have missed something.
>
> You mean in the instruction decoder?  I haven't tried that case
> explicitly, but I did do a substantial amount of testing throwing random
> instruction streams at the decoder to make sure it never fell over.
> (Well, mostly random, I made sure to throw the MPX opcodes in there a
> bunch so it would get much deeper in to the decoder).
>
> It's not about the instruction size, it's about the mode the CPU is in.
> If a 32-bit app manages to switch over to 64-bit mode and doesn't tell
> the kernel (TIF_IA32 remains set), then we'll treat it as a 32-bit
> instruction.

The insn decoder should probably use user_64bit_mode, not TIF_IA32.
It's actually quite easy to far jump/call/ret or sigreturn to a
different bitness.

>
> The kernel might end up going and looking for the bounds tables in some
> funky places if the kernel and the hardware disagree about 32 vs. 64-bit
> modes, but it's not going to do any harm since we treat all of the data
> we get from MPX (instruction decoding, register contents, bounds table
> contents, etc...) as completely untrusted.
>
> It's a nice, paranoid thing to ask and I'm glad you brought it up
> because I hadn't thought about it, but I don't think any harm can come
> of it.

Paranoia is fun!

The only thing I'd really be worried about is if the code that turns
va into bounds table offset generates some absurdly large offset as a
result and causes a problem.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
