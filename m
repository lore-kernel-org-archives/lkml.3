Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaBOOCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 09:02:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbaBOOCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 09:02:47 -0500
Date: Sat, 15 Feb 2014 15:02:23 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Jan Beulich <jbeulich@suse.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Issue a warning if number of present CPUs > maxcpus
 and CONFIG_HOTPLUG=n
Message-ID: <20140215150223.63bb52fb@hananiah.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that the check against i (value passed as maxcpus, but at least 1)
is repeated further down, including the warning, but since possible is
already clamped to max_cpus at that time, it is never printed. In fact,
for the non-hotplug case, the warning about exceeding maxcpus is only
ever printed if "possible_cpus" was also specified on the command line.

I strongly believe that such limitation was unintentional.

I also changed the message slightly -- the kernel parameter name is
maxcpus, not max_cpus.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/kernel/smpboot.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a32da80..376b6c6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1226,9 +1226,6 @@ __init void prefill_possible_map(void)
 #ifdef CONFIG_HOTPLUG_CPU
 		if (setup_max_cpus)
 			possible += disabled_cpus;
-#else
-		if (possible > i)
-			possible = i;
 #endif
 	} else
 		possible = setup_possible_cpus;
@@ -1246,7 +1243,7 @@ __init void prefill_possible_map(void)
 	if (!setup_max_cpus)
 #endif
 	if (possible > i) {
-		pr_warn("%d Processors exceeds max_cpus limit of %u\n",
+		pr_warn("%d Processors exceeds maxcpus limit of %u\n",
 			possible, setup_max_cpus);
 		possible = i;
 	}
-- 
1.8.4.5
