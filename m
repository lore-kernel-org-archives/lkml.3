Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3HGHpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:45:20 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:62743 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3HGHpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:45:17 -0400
Message-ID: <20993.64234.352390.254920@ipc1.ka-ro>
Date: Wed, 7 Aug 2013 09:44:42 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.cz>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [BUG linux-next] watchdog: build breakage for non-SMP builds
X-Mailer: VM 8.1.0 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit 0ce6966b "watchdog: update watchdog_tresh properly" breaks
build on non-SMP systems (more specifically: on systems where
CONFIG_USE_GENERIC_SMP_HELPERS is not set):
linux-next/kernel/watchdog.c: In function 'update_timers':
linux-next/kernel/watchdog.c:522:2: error: implicit declaration of function '__smp_call_function_single' [-Werror=implicit-function-declaration]

I guess the offending code should be guarded by an
'#ifdef CONFIG_USE_GENERIC_SMP_HELPERS'
like in kernel/softirq.c:
#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
[...]
static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
{
        if (cpu_online(cpu)) {
                cp->func = remote_softirq_receive;
                cp->info = &softirq;
                cp->flags = 0;

                __smp_call_function_single(cpu, cp, 0);
                return 0;
        }
        return 1;
}
#else /* CONFIG_USE_GENERIC_SMP_HELPERS */
static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
{
        return 1;
}
#endif


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
