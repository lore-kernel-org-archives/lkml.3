Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3HMFsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:48:55 -0400
Received: from ozlabs.org ([203.10.76.45]:49296 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab3HMFsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:48:52 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <penberg@kernel.org>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm tools: powerpc: Implement "system-reboot" RTAS call
Date: Tue, 13 Aug 2013 15:48:47 +1000
Message-Id: <1376372927-3510-1-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some powerpc systems, reboot is implemented by an RTAS call by the
name of "system-reboot". Currently we don't implement it in kvmtool,
which means instead the guest prints an error and spins.

This is particularly annoying because when the guest kernel panics it
will try to reboot, and end up spinning in the guest.

We can't implement reboot properly, ie. causing a reboot, but it's still
preferable to implement it as halt rather than not implementing it at
all.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/spapr_rtas.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/kvm/powerpc/spapr_rtas.c b/tools/kvm/powerpc/spapr_rtas.c
index f3c8fa3..43e5310 100644
--- a/tools/kvm/powerpc/spapr_rtas.c
+++ b/tools/kvm/powerpc/spapr_rtas.c
@@ -121,6 +121,19 @@ static void rtas_power_off(struct kvm_cpu *vcpu,
 	kvm_cpu__reboot(vcpu->kvm);
 }
 
+static void rtas_system_reboot(struct kvm_cpu *vcpu,
+                           uint32_t token, uint32_t nargs, target_ulong args,
+                           uint32_t nret, target_ulong rets)
+{
+	if (nargs != 0 || nret != 1) {
+		rtas_st(vcpu->kvm, rets, 0, -3);
+		return;
+	}
+
+	/* NB this actually halts the VM */
+	kvm_cpu__reboot(vcpu->kvm);
+}
+
 static void rtas_query_cpu_stopped_state(struct kvm_cpu *vcpu,
                                          uint32_t token, uint32_t nargs,
                                          target_ulong args,
@@ -221,6 +234,7 @@ void register_core_rtas(void)
 	spapr_rtas_register("get-time-of-day", rtas_get_time_of_day);
 	spapr_rtas_register("set-time-of-day", rtas_set_time_of_day);
 	spapr_rtas_register("power-off", rtas_power_off);
+	spapr_rtas_register("system-reboot", rtas_system_reboot);
 	spapr_rtas_register("query-cpu-stopped-state",
 			    rtas_query_cpu_stopped_state);
 	spapr_rtas_register("start-cpu", rtas_start_cpu);
-- 
1.8.1.2

