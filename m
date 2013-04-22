Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3DVIbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:31:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3DVIbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:31:18 -0400
Date: Mon, 22 Apr 2013 01:29:39 -0700
From: tip-bot for Jacob Shin <tipbot@zytor.com>
Message-ID: <tip-94f4db3590893c600506105b88dab581c7f6f5c8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        bp@alien8.de, jolsa@redhat.com, jacob.shin@amd.com, tglx@linutronix.de,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, bp@alien8.de, jolsa@redhat.com,
        jacob.shin@amd.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <20130421180627.GA21049@jshin-Toonie>
References: <20130421180627.GA21049@jshin-Toonie>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/amd: Fix AMD NB and L2I "uncore" support
Git-Commit-ID: 94f4db3590893c600506105b88dab581c7f6f5c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 22 Apr 2013 01:29:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94f4db3590893c600506105b88dab581c7f6f5c8
Gitweb:     http://git.kernel.org/tip/94f4db3590893c600506105b88dab581c7f6f5c8
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Sun, 21 Apr 2013 13:06:27 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 22 Apr 2013 10:10:55 +0200

perf/x86/amd: Fix AMD NB and L2I "uncore" support

Borislav Petkov reported a lockdep splat warning about kzalloc()
done in an IPI (hardirq) handler.

This is a real bug, do not call kzalloc() in a smp_call_function_single()
handler because it can schedule and crash.

Reported-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Tested-by: Borislav Petkov <bp@suse.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: <eranian@google.com>
Cc: <a.p.zijlstra@chello.nl>
Cc: <acme@ghostprotocols.net>
Cc: <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/20130421180627.GA21049@jshin-Toonie
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_uncore.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index 6dc6227..c0c661a 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -498,7 +498,6 @@ static void __init init_cpu_already_online(void *dummy)
 {
 	unsigned int cpu = smp_processor_id();
 
-	amd_uncore_cpu_up_prepare(cpu);
 	amd_uncore_cpu_starting(cpu);
 	amd_uncore_cpu_online(cpu);
 }
@@ -535,8 +534,10 @@ static int __init amd_uncore_init(void)
 
 	get_online_cpus();
 	/* init cpus already online before registering for hotplug notifier */
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
+		amd_uncore_cpu_up_prepare(cpu);
 		smp_call_function_single(cpu, init_cpu_already_online, NULL, 1);
+	}
 
 	register_cpu_notifier(&amd_uncore_cpu_notifier_block);
 	put_online_cpus();
