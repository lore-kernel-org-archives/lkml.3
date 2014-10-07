Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaJGLUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:20:16 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:59741 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaJGLUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:20:13 -0400
Date: Tue, 7 Oct 2014 07:19:00 -0400
From: Rich Felker <dalias@libc.org>
To: Matthew Fortune <Matthew.Fortune@imgtec.com>
Cc: David Daney <david.s.daney@gmail.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141007111859.GI23797@brightrain.aerifal.cx>
References: <20141006213101.GA23797@brightrain.aerifal.cx>
 <54330D79.80102@caviumnetworks.com>
 <20141006215813.GB23797@brightrain.aerifal.cx>
 <543327E7.4020608@amacapital.net>
 <54332A64.5020605@caviumnetworks.com>
 <20141007000514.GD23797@brightrain.aerifal.cx>
 <543334CE.8060305@caviumnetworks.com>
 <20141007004915.GF23797@brightrain.aerifal.cx>
 <54337127.40806@gmail.com>
 <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 09:13:22AM +0000, Matthew Fortune wrote:
> From what I can see the out-of-line execution of delay slot instructions
> will break micromips R3 addiupc, and all MIPS32r6 and MIPS64r6 PC-relative
> instructions (inc load/store) as they will have the wrong base. Is there
> anything in the current set of proposals that can address this (beyond
> adding restrictions to what is ABI allowed in FPU branch delay slots)?

Yes. If a trampoline is being generated to replace the delay slot
instruction, it can just contain more complex code to duplicate what
the PC-relative instruction would have done. Since the ABI already
assumes a stack is available, it can use the stack to backup registers
it needs for scratch space and restore them.

> This is an issue whether the stack is executable or not but does directly
> relate to the topic of FPU emulation.  It sounds like the kernel would not
> be able to emulate a pc-relative load/store even if it was a special case
> as it would not run in the correct MM context? [be gentle, I'm no expert
> in this area].

Really everything should be done in the kernel, and it's not as hard
as people are making it look. The kernel _already_ has to enforce MM
context permissions for every syscall that reads or writes user memory
(e.g. futex with PI mutexes or FUTEX_WAKE_OP, or even simple things
like read/write) so there's no reason it can't do emulated
loads/stores the exact same way.

Rich
