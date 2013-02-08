Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300Ab3BHUfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:35:00 -0500
Received: from mail.tpi.com ([70.99.223.143]:3200 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab3BHUe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:34:59 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: [PATCH linux-next] xen/multicall: xen_mc_callback(): avoid buffer overflow
Date: Fri,  8 Feb 2013 13:34:37 -0700
Message-Id: <1360355677-52442-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This buffer overflow was introduced with 91e0c5f3dad47838cb2ecc1865ce789a0b7182b1
(2.6.24).

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: stable@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

This patch applies cleanly to 3.1.10 and newer. Requires a backport
for 2.6.24-3.2.y

 arch/x86/xen/multicalls.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index 0d82003..5270407 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -195,9 +195,10 @@ void xen_mc_callback(void (*fn)(void *), void *data)
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	struct callback *cb;
 
-	if (b->cbidx == MC_BATCH) {
+	if (b->cbidx >= MC_BATCH) {
 		trace_xen_mc_flush_reason(XEN_MC_FL_CALLBACK);
 		xen_mc_flush();
+		return;
 	}
 
 	trace_xen_mc_callback(fn, data);
-- 
1.7.9.5

