Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab3D2Ovc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:51:32 -0400
Received: from gecko.sbs.de ([194.138.37.40]:23729 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab3D2Ova convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:51:30 -0400
X-Greylist: delayed 1007 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 10:51:30 EDT
From: "Warlich, Christof" <christof.warlich@siemens.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: X86 fpu registers in a signal handler's ucontext 
Thread-Topic: X86 fpu registers in a signal handler's ucontext 
Thread-Index: Ac5E5q7NA96BXpsWSbCkjGXFgUmlzg==
Date: Mon, 29 Apr 2013 14:34:41 +0000
Message-ID: <6D83E89737156549AEA25EF9ED712C5DDEF7@DEFTHW99EK1MSX.ww902.siemens.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [139.22.70.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want my signal handler to return from a SIGFPE and continue normal
execution right _after_ the instruction that caused the signal.

My first attempt workes quite well: I just modify the EIP register
though the ucontext pointer being passed to the signal handler:

void fpeHandler(int, siginfo_t *info, void *context) {
    // The following function calculates the size of the instruction being pointed to.
    int size = instructionSize((unsigned char *) info->si_addr);
    ((ucontext_t *) context)->uc_mcontext.gregs[REG_EIP] += size;
}

Doing this, my main program continues as expected as long as no other
floating point instructions are involved, but as the exception
condition is still active in the FP status register, any subsequent
and _valid_ floating point calculation cause another exception.

Thus, I tried to clear the exceptions in a similar way:

void fpeHandler(int, siginfo_t *info, void *context) {
    // This function calculates the size of the instruction being poined to.
    int size = instructionSize((unsigned char *) info->si_addr);
    ((ucontext_t *) context)->uc_mcontext.gregs[REG_EIP] += size;
    ((ucontext_t *) context)->uc_mcontext.fpregs->status &= ~FE_ALL_EXCEPT
}

But unfortunately, this doesn't work:

First, this link:
http://valgrind.10908.n7.nabble.com/need-FPU-and-SSE-state-in-sigcontext-ucontext-td19844.html
suggests that unlike the GPRs, the FP registers are _not_ restored after
returnung from the signal handler. 

Second, only FP state seems to be available through ucontext_t, and I would
need to clear exceptions for SSE as well.

Can anyone give me some advice on how to I could proceed?

Thanks a lot,

Chris