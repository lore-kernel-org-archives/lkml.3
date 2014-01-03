Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaACUcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:32:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21978 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaACUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:30:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Mukesh Rathor <mukesh.rathor@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 09/19] xen/pvh: Setup up shared_info.
Date: Fri,  3 Jan 2014 14:38:26 -0500
Message-Id: <1388777916-1328-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

For PVHVM the shared_info structure is provided via the same way
as for normal PV guests (see include/xen/interface/xen.h).

That is during bootup we get 'xen_start_info' via the %esi register
in startup_xen. Then later we extract the 'shared_info' from said
structure (in xen_setup_shared_info) and start using it.

The 'xen_setup_shared_info' is all setup to work with auto-xlat
guests, but there are two functions which it calls that are not:
xen_setup_mfn_list_list and xen_setup_vcpu_info_placement.
This patch modifies the P2M code (xen_setup_mfn_list_list)
while the "Piggyback on PVHVM for event channels" modifies
the xen_setup_vcpu_info_placement.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index fb7ee0a..696c694 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -339,6 +339,9 @@ void __ref xen_build_mfn_list_list(void)
 
 void xen_setup_mfn_list_list(void)
 {
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
 	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
 
 	HYPERVISOR_shared_info->arch.pfn_to_mfn_frame_list_list =
-- 
1.8.3.1

