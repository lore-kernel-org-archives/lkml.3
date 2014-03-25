Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaCYPxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 11:53:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:53851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaCYPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 11:53:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xen <xen-devel@lists.xenproject.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] Xen: do hv callback accounting only on x86
Date: Tue, 25 Mar 2014 16:52:25 +0100
Message-ID: <5057041.71iuvlcH4G@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AiCLgSaqK8PQNnzdiwJj5DzTLV4+T0766bScIJw21Cr
 3I2z9HW9IeOwBW82yRWjryBzmL2/PWEHXPcKY8iDUnBnA2GD3u
 l9Eh4Y/uCkbVcexvkfgaqqM/qUOQ04+YRN5p3O4gLXtqLLlUc/
 3kz3rZ1eFIWzSbw2GtwyA7EEecuhxkRl4EW2k7LaXjDR93Qx2Z
 yqbkVCeHLcSAC6snBrVBRQpwamvD5DQfLRN0vFALQYso17j4lN
 BffQvP9zA75nuq9sz3bXEylaylLH1R1FtL5C6ISY1OZvXuOZRH
 He/Ni70I0tdahHhAH14yCcQvA5TTWd4HX8cHl8UXNeIlsMqJux
 arMJIe9p5/9GbqU57bfo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 99c8b79d3c1 "xen: Add proper irq accounting for HYPERCALL vector"
added a call to inc_irq_stat(irq_hv_callback_count) in common Xen code,
however both the inc_irq_stat function and the irq_hv_callback_count
counter are architecture specific.

This makes the code build again on ARM by moving the call into the
existing #ifdef CONFIG_X86. We may want to later do the same implementation
on ARM that x86 has though.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 5dd2ddf..8b91c256 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1235,6 +1235,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 #ifdef CONFIG_X86
        exit_idle();
 #endif
+       inc_irq_stat(irq_hv_callback_count);

        __xen_evtchn_do_upcall();

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index d5a3de8..dfa12a4 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1248,8 +1248,8 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	irq_enter();
 #ifdef CONFIG_X86
 	exit_idle();
-#endif
 	inc_irq_stat(irq_hv_callback_count);
+#endif
 
 	__xen_evtchn_do_upcall();
 

