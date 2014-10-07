Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaJGLxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:53:18 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:26359 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaJGLxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:53:17 -0400
Message-ID: <5433D429.3020804@imgtec.com>
Date: Tue, 7 Oct 2014 12:53:13 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Daney <david.s.daney@gmail.com>,
        "Kevin D. Kissell" <kevink@paralogos.com>,
        David Daney <ddaney.cavm@gmail.com>, <libc-alpha@sourceware.org>,
        Leonid <Leonid.Yegoshin@imgtec.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <54333B9C.2040302@paralogos.com> <54336CED.3040106@gmail.com>
In-Reply-To: <54336CED.3040106@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/14 05:32, David Daney wrote:
> If the kernel automatically allocated the emulation locations, what
> would happen if there were a signal that interrupted the emulation, and
> the signal handler did a longjump to somewhere else?  How would we clean
> up the now unused emulation memory allocations?

AFAICT, Leonid's implementation also has this problem, and that has a
separate stack of emuframes per thread managed completely by the kernel.

Essentially the kernel doesn't manage the stack, userland does, and
userland can choose to skip over sigframes and emuframes with siglongjmp
without telling the kernel.

Userland can even switch between contexts (which includes stack) with
setcontext (coroutines etc) which breaks the assumption in Leonid's
patches that emuframes will be completed in reverse order to them being
started, again demonstrating that it is essentially userland that
manages the stack.

I think any attempt by the kernel to keep track of user stacks (e.g. by
storing a stack pointer along with the emuframe so that unused emuframes
can be discarded later when stack pointer goes high again) will be
foiled by setcontext.

Hmm, I can't see a way forward that doesn't involve invasive userland
handling & ABI changes other than giving up with non-executable stacks
or limiting permitted instructions in delay slots to those Linux knows
how to emulate directly.

Cheers
James
