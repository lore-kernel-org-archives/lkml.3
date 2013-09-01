Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab3IAMV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 08:21:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41955 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab3IAMVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 08:21:25 -0400
Message-ID: <5223311D.2040608@zytor.com>
Date: Sun, 01 Sep 2013 05:20:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: On the correctness of dbe3ed1c078c193be34326728d494c5c4bc115e2
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A truly ancient commit (v2.6.23), dbe3ed1c078c193be34326728d494c5c4bc115e2:

    x86-64: page faults from user mode are always user faults

    Randy Dunlap noticed an interesting "crashme" behaviour on his dual
    Prescott Xeon setup, where he gets page faults with the error code
    having a zero "user" bit, but the register state points back to user
    mode.

    This may be a CPU microcode buglet triggered by some strange
    instruction pattern that crashme generates, and loading a microcode
    update seems to possibly have fixed it.

    Regardless, we really should trust the register state more than the
    error code, since it's really the register state that determines
    whether we can actually send a signal, or whether we're in kernel
    mode and need to oops/kill the process in the case of a page fault.

... introduced the following code (since slightly modified):

+	/*
+	 * User-mode registers count as a user access even for any
+	 * potential system fault or CPU buglet.
+	 */
+	if (user_mode_vm(regs))
+		error_code |= PF_USER;
+

This has the end result that we treat a user space instruction which
touches a privileged data structure that then page faults (e.g. a
segment load which causes #PF on the GDT) as a user-space fault.

This seems very wrong to me, since such a #PF would indicate a serious
error in the kernel.

If this was a buglet introduced by a specific processor ("Prescott Xeon"
I presume means Nocona) and then even fixed in a patch, I'm concerned
that we are putting the cart before the horse with this change.

I went through the errata sheets for the CPUs of the time, but nothing
jumped out at me as causing this kind of problem, although there is a
mention of a couple of undefined opcodes which ought to #UD being able
to generate a "load to an incorrect address".  Kind of a stretch, though.

	-hpa
