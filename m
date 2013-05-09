Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab3EIXLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:11:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab3EIW0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tim Northover <Tim.Northover@arm.com>
Subject: [ 23/73] arm64: Ignore the write ESR flag on cache maintenance faults
Date: Thu,  9 May 2013 15:25:13 -0700
Message-Id: <20130509222528.840584177@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 0e7f7bcc3fc87489cda5aa6aff8ce40eed912279 upstream.

ESR.WnR bit is always set on data cache maintenance faults even though
the page is not required to have write permission. If a translation
fault (page not yet mapped) happens for read-only user address range,
Linux incorrectly assumes a permission fault. This patch adds the check
of the ESR.CM bit during the page fault handling to ignore the 'write'
flag.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Tim Northover <Tim.Northover@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/fault.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -148,6 +148,7 @@ void do_bad_area(unsigned long addr, uns
 #define VM_FAULT_BADACCESS	0x020000
 
 #define ESR_WRITE		(1 << 6)
+#define ESR_CM			(1 << 8)
 #define ESR_LNX_EXEC		(1 << 24)
 
 /*
@@ -206,7 +207,7 @@ static int __kprobes do_page_fault(unsig
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	int fault, sig, code;
-	int write = esr & ESR_WRITE;
+	bool write = (esr & ESR_WRITE) && !(esr & ESR_CM);
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
 		(write ? FAULT_FLAG_WRITE : 0);
 


