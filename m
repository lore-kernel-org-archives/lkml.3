Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3LRVbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:31:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3LRVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cliff Wickman <cpw@sgi.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.12 068/118] x86/UV: Fix NULL pointer dereference in uv_flush_tlb_others() if the nobau boot option is used
Date: Wed, 18 Dec 2013 13:11:45 -0800
Message-Id: <20131218211221.380254523@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: cpw <cpw@sgi.com>

commit 3eae49ca8954f958b2001ab5643ef302cb7b67c7 upstream.

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
Link: http://lkml.kernel.org/r/E1VnzBi-0005yF-MU@eag09.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/uv/tlb_uv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1070,12 +1070,13 @@ const struct cpumask *uv_flush_tlb_other
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


