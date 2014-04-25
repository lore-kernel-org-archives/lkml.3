Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaDYJSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:18:55 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:32961 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaDYJMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:12:21 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 04/11] KVM: s390: Use intercept_insn decoder in trace event
Date: Fri, 25 Apr 2014 11:12:26 +0200
Message-Id: <1398417153-57347-5-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042509-4966-0000-0000-0000092E7C9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

The current trace definition doesn't work very well with the perf tool.
Perf shows a "insn_to_mnemonic not found" message. Let's handle the
decoding completely in a parseable format.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/trace.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/trace.h b/arch/s390/kvm/trace.h
index 00f57a5..579b42a 100644
--- a/arch/s390/kvm/trace.h
+++ b/arch/s390/kvm/trace.h
@@ -154,7 +154,6 @@ TRACE_EVENT(kvm_s390_intercept_instruction,
 	    TP_STRUCT__entry(
 		    VCPU_FIELD_COMMON
 		    __field(__u64, instruction)
-		    __field(char, insn[8])
 		    ),
 
 	    TP_fast_assign(
@@ -165,10 +164,8 @@ TRACE_EVENT(kvm_s390_intercept_instruction,
 
 	    VCPU_TP_PRINTK("intercepted instruction %016llx (%s)",
 			   __entry->instruction,
-			   insn_to_mnemonic((unsigned char *)
-					    &__entry->instruction,
-					 __entry->insn, sizeof(__entry->insn)) ?
-			   "unknown" : __entry->insn)
+			   __print_symbolic(icpt_insn_decoder(__entry->instruction),
+					    icpt_insn_codes))
 	);
 
 /*
-- 
1.8.4.2

