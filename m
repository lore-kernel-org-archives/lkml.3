Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaKCMvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:51:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaKCMvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:51:46 -0500
Date: Mon, 3 Nov 2014 04:51:33 -0800
From: tip-bot for James Custer <tipbot@zytor.com>
Message-ID: <tip-fa2a79ce6aef5de35a4d50487da35deb6b634944@git.kernel.org>
Cc: hpa@zytor.com, jcuster@sgi.com, tglx@linutronix.de, rja@sgi.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, rja@sgi.com, mingo@kernel.org,
        tglx@linutronix.de, jcuster@sgi.com, hpa@zytor.com
In-Reply-To: <1414952199-185319-2-git-send-email-jcuster@sgi.com>
References: <1414952199-185319-2-git-send-email-jcuster@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86: UV BAU:
  Avoid NULL pointer reference in ptc_seq_show
Git-Commit-ID: fa2a79ce6aef5de35a4d50487da35deb6b634944
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa2a79ce6aef5de35a4d50487da35deb6b634944
Gitweb:     http://git.kernel.org/tip/fa2a79ce6aef5de35a4d50487da35deb6b634944
Author:     James Custer <jcuster@sgi.com>
AuthorDate: Sun, 2 Nov 2014 12:16:39 -0600
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 13:49:24 +0100

x86: UV BAU: Avoid NULL pointer reference in ptc_seq_show

In init_per_cpu(), when get_cpu_topology() fails, init_per_cpu_tunables()
is not called afterwards. This means that bau_control->statp is NULL.
If a user then reads /proc/sgi_uv/ptc_statistics ptc_seq_show() references
a NULL pointer. Therefore, since uv_bau_init calls set_bau_off when
init_per_cpu() fails, we add code that detects when the bau is off in
ptc_seq_show() to avoid referencing a NULL pointer.

Signed-off-by: James Custer <jcuster@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Link: http://lkml.kernel.org/r/1414952199-185319-2-git-send-email-jcuster@sgi.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/platform/uv/tlb_uv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 3968d67..570b1b1 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1384,6 +1384,10 @@ static int ptc_seq_show(struct seq_file *file, void *data)
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
 		bcp = &per_cpu(bau_control, cpu);
+		if (bcp->nobau) {
+			seq_printf(file, "cpu %d bau disabled\n", cpu);
+			return 0;
+		}
 		stat = bcp->statp;
 		/* source side statistics */
 		seq_printf(file,
