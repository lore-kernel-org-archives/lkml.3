Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3LJJW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:22:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44662 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3LJJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:22:51 -0500
Date: Tue, 10 Dec 2013 01:22:35 -0800
From: tip-bot for cpw <tipbot@zytor.com>
Message-ID: <tip-3eae49ca8954f958b2001ab5643ef302cb7b67c7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org, cpw@sgi.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de
In-Reply-To: <E1VnzBi-0005yF-MU@eag09.americas.sgi.com>
References: <E1VnzBi-0005yF-MU@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/UV:
  Fix NULL pointer dereference in uv_flush_tlb_others() if the 'nobau'
  boot option is used
Git-Commit-ID: 3eae49ca8954f958b2001ab5643ef302cb7b67c7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:22:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3eae49ca8954f958b2001ab5643ef302cb7b67c7
Gitweb:     http://git.kernel.org/tip/3eae49ca8954f958b2001ab5643ef302cb7b67c7
Author:     cpw <cpw@sgi.com>
AuthorDate: Tue, 3 Dec 2013 17:15:30 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 10 Dec 2013 10:06:00 +0100

x86/UV: Fix NULL pointer dereference in uv_flush_tlb_others() if the 'nobau' boot option is used

The SGI UV tlb shootdown code panics the system with a NULL
pointer deference if 'nobau' is specified on the boot
commandline.

uv_flush_tlb_other() gets called for every flush, whether the
BAU is disabled or not.  It should not be keeping the s_enters
statistic while the BAU is disabled.

The panic occurs because during initialization
init_per_cpu_tunables() does not set the bcp->statp pointer if
'nobau' was specified.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: <stable@vger.kernel.org> # 3.12.x
Link: http://lkml.kernel.org/r/E1VnzBi-0005yF-MU@eag09.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/uv/tlb_uv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 0f92173..efe4d72 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1070,12 +1070,13 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 	unsigned long status;
 
 	bcp = &per_cpu(bau_control, cpu);
-	stat = bcp->statp;
-	stat->s_enters++;
 
 	if (bcp->nobau)
 		return cpumask;
 
+	stat = bcp->statp;
+	stat->s_enters++;
+
 	if (bcp->busy) {
 		descriptor_status =
 			read_lmmr(UVH_LB_BAU_SB_ACTIVATION_STATUS_0);
