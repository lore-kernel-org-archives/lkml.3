Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3FEHsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:48:52 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:37077 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3FEHsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:48:51 -0400
MIME-Version: 1.0
Date: Wed, 5 Jun 2013 00:48:50 -0700
Message-ID: <CANN689EA6U+fVy3M1WFC0O-c_HZDSNGYnwYRf_uvqZLQNx2hYQ@mail.gmail.com>
Subject: trigger_all_cpu_backtrace() is ignored on x86
From: Michel Lespinasse <walken@google.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am having a funny issue with code that tries to use
trigger_all_cpu_backtrace(). I would expect this function to dump
backtraces on architectures that support it, including x86. However as
it turns out, include/linux/nmi.h includes asm/irq.h but not
asm/nmi.h, so it misses the arch/x86/include/asm/nmi.h definition of
arch_trigger_all_cpu_backtrace and falls back to what it'd do for
architectures that don't have this function.

I would suggest the following straightforward fix:

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index db50840e6355..6549df520dd3 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -6,6 +6,7 @@

 #include <linux/sched.h>
 #include <asm/irq.h>
+#include <asm/nmi.h>

 /**
  * touch_nmi_watchdog - restart NMI watchdog timeout.


However, I am slightly confused by the fact that
arch/x86/kernel/apic/hw_nmi.c also encloses the
arch_trigger_all_cpu_backtrace() definition within #ifdef
arch_trigger_all_cpu_backtrace - so I can't tell if the definition
from arch/x86/include/asm/nmi.h is intended to take effect or if there
is some subtle point explaining why things are as they are.

Help anyone ?


Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
