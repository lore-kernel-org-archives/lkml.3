Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaHKNqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:46:16 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53596 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753547AbaHKNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:44:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 0/6 v2] irq / PM: Shared IRQs vs IRQF_NO_SUSPEND and suspend-to-idle wakeup interrupts
Date: Mon, 11 Aug 2014 15:56:46 +0200
Message-ID: <26580319.OZP7jvJnA9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I thought I'd just refresh the previous patchset, but in the meantime I found
a way to avoid adding overhead to note_interrupt(), so I decided to change the
approach.

Patch [2/6] fixes the problem with IRQF_NO_SUSPEND and shared interrupts.  The
idea is to use wrapper handlers for all irqactions of the shared IRQs where at
least one of them has IRQF_NO_SUSPEND set.  Since the wrapper handler is now
installed for all irqactions in the given irq_desc, it can track the return
codes from the original handlers and "suspend" the IRQ if the interrupt is going
to be unhandled eventually.  All described in the changelog.  This is independent
of the handling of wakeup interrupts for suspend-to-idle.

Patch [3/6] makes IRQs configured for system wakeup with enable_irq_wake() work
for suspend to idle.  It does that by using a (different) wrapper handler for
all irqactions in the wakeup irq_descs and that wrapper handler takes care of
all the ugly details.  Again, all described in the changelog.

Patches [1/6], [4-5/6] are unmodified and the last one addes documentation.

Please review.

Rafael

