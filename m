Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474AbaFJAWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:22:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934447AbaFJAWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3.4 81/88] xen/p2m: An early bootup variant of set_phys_to_machine
Date: Mon,  9 Jun 2014 17:25:31 -0700
Message-Id: <20140610002427.162653560@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 940713bb2ce3033f468a220094a07250a2f69bdd upstream.

During early bootup we can't use alloc_page, so to allocate
leaf pages in the P2M we need to use extend_brk. For that
we are utilizing the early_alloc_p2m and early_alloc_p2m_middle
functions to do the job for us. This function follows the
same logic as set_phys_to_machine.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/xen/page.h |    1 +
 arch/x86/xen/p2m.c              |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -44,6 +44,7 @@ extern unsigned long  machine_to_phys_nr
 
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
+extern bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 					     unsigned long pfn_e);
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -570,6 +570,21 @@ static bool __init early_alloc_p2m(unsig
 	}
 	return true;
 }
+bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
+		if (!early_alloc_p2m(pfn))
+			return false;
+
+		if (!early_alloc_p2m_middle(pfn, false /* boundary crossover OK!*/))
+			return false;
+
+		if (!__set_phys_to_machine(pfn, mfn))
+			return false;
+	}
+
+	return true;
+}
 unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 				      unsigned long pfn_e)
 {


