Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbbAUQz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:55:57 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37326 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbbAUQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:36 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b6-54bfd8bc8a56
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/A...)
Subject: [PATCH v9 15/17] kernel: add support for .init_array.* constructors
Date: Wed, 21 Jan 2015 19:51:43 +0300
Message-id: <1421859105-25253-16-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xq7p7buwPMWh9KWax7dcjNovfe2ey
	WsxZv4bN4si17+wWfycdY7e4/u0No8Wnlw8YLZ4/fMhuMeFhG7vFyu5mNovtz94yWazsfMBq
	0bHrK4vF5V1z2CzurfnParH4yG1mi3fPJjNb/NjwmNVByOP3r0mMHvN3fmT02DnrLrvHgk2l
	Hov3vGTy2LSqk81j06dJ7B5db68weZyY8ZvF48mV6UweH5/eYvHo27KK0ePzJrkA3igum5TU
	nMyy1CJ9uwSujI1d7SwFa7gqtreeY2lgPMLRxcjJISFgIvF4dQ8ThC0mceHeerYuRi4OIYGl
	jBJXH76CcvqYJC6+WsYGUsUmoCfxb9Z2MFtEQEFic+8zVpAiZoE2Vokrr26ygySEBXwk2tpW
	s4LYLAKqErv2bWEBsXkF3CWebbvCBrFOTmLjnRVgNZxA8ZnnJzJBbGtilPh8ZDvbBEbeBYwM
	qxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFC4uLrDsalx6wOMQpwMCrx8Er47A8RYk0sK67M
	PcQowcGsJMI7/zpQiDclsbIqtSg/vqg0J7X4ECMTB6dUA+MNUT4PPoX17fGr/h/wWs7GMa/e
	cZcck8XReRv3ff2xN+/nlL7Kt63T69WmXmmwDmlaEqiYUvQp5ubNGZuD1u30utVz4YOSbtab
	+YtOTWjtz5Ion5SlGjplua/eh32/U4WNZ2ypn3W8M+bz1NNrYo803StV5FMuT5vHdOZZDuPM
	pDCF+70NDJeVWIozEg21mIuKEwHjLCB1aQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KASan uses constructors for initializing redzones for global
variables. Actually KASan doesn't need priorities for constructors,
so they were removed from GCC 5.0, but GCC 4.9.2 still generates
constructors with priorities.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 scripts/module-common.lds         | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bee5d68..ac78910 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -478,6 +478,7 @@
 #define KERNEL_CTORS()	. = ALIGN(8);			   \
 			VMLINUX_SYMBOL(__ctors_start) = .; \
 			*(.ctors)			   \
+			*(SORT(.init_array.*))		   \
 			*(.init_array)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
diff --git a/scripts/module-common.lds b/scripts/module-common.lds
index 0865b3e..01c5849 100644
--- a/scripts/module-common.lds
+++ b/scripts/module-common.lds
@@ -16,4 +16,7 @@ SECTIONS {
 	__kcrctab_unused	: { *(SORT(___kcrctab_unused+*)) }
 	__kcrctab_unused_gpl	: { *(SORT(___kcrctab_unused_gpl+*)) }
 	__kcrctab_gpl_future	: { *(SORT(___kcrctab_gpl_future+*)) }
+
+	. = ALIGN(8);
+	.init_array		: { *(SORT(.init_array.*)) *(.init_array) }
 }
-- 
2.2.1

