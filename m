Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaLLXQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:16:55 -0500
Received: from www.sr71.net ([198.145.64.142]:55194 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaLLXQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:16:54 -0500
Message-ID: <548B7764.2060608@sr71.net>
Date: Fri, 12 Dec 2014 15:16:52 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit
 kernels
References: <20141212191213.579887D2@viggo.jf.intel.com> <548B4E75.5010507@amacapital.net> <548B4FBE.5090101@sr71.net> <CALCETrW4f3EUYGG_zyzb7sZBXaoW3eHMpTn3dd3WpDgJq2HjtA@mail.gmail.com> <548B60F4.6020903@sr71.net> <CALCETrVZcED1x+YV4V+c9nnieaz8DMbO4D455h2QYF__jX-DKg@mail.gmail.com>
In-Reply-To: <CALCETrVZcED1x+YV4V+c9nnieaz8DMbO4D455h2QYF__jX-DKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 03:04 PM, Andy Lutomirski wrote:
> Anyway, do your patches handle the case where a 32-bit app maliciously
> executes a 64-bit mpx insn with a very large address?  I think it's
> okay, but I might have missed something.

You mean in the instruction decoder?  I haven't tried that case
explicitly, but I did do a substantial amount of testing throwing random
instruction streams at the decoder to make sure it never fell over.
(Well, mostly random, I made sure to throw the MPX opcodes in there a
bunch so it would get much deeper in to the decoder).

It's not about the instruction size, it's about the mode the CPU is in.
If a 32-bit app manages to switch over to 64-bit mode and doesn't tell
the kernel (TIF_IA32 remains set), then we'll treat it as a 32-bit
instruction.

The kernel might end up going and looking for the bounds tables in some
funky places if the kernel and the hardware disagree about 32 vs. 64-bit
modes, but it's not going to do any harm since we treat all of the data
we get from MPX (instruction decoding, register contents, bounds table
contents, etc...) as completely untrusted.

It's a nice, paranoid thing to ask and I'm glad you brought it up
because I hadn't thought about it, but I don't think any harm can come
of it.
