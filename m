Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3KOXTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:19:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:38537 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab3KOXTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:19:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,710,1378882800"; 
   d="scan'208";a="428548559"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <CA+8MBbJR+AbGY41=TMOfJUd2u927ADa8O_-12sFUcNYnN34oMw@mail.gmail.com>
References: <1383833644-27091-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CA+8MBbL-WpcC6_wfZeFW6Buqq0p1PStH5ScF-USHae40H3MXfg@mail.gmail.com>
 <CA+8MBbJR+AbGY41=TMOfJUd2u927ADa8O_-12sFUcNYnN34oMw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Properly separate the bloated ptl from the
 regular case
Content-Transfer-Encoding: 7bit
Message-Id: <20131115231548.60418E0090@blue.fi.intel.com>
Date: Sat, 16 Nov 2013 01:15:48 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> On Fri, Nov 15, 2013 at 2:01 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Help!

Could you try this:

>From 661b6057c435fbae265b394b277a0b16bf02d255 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Sat, 16 Nov 2013 01:09:17 +0200
Subject: [PATCH] kernel/bounds: avoid circular dependencies in generated
 headers

<linux/spinlock.h> has havy dependencies on other header files.
It trigger circular dependencies in generated headers on IA64, at least:

  CC      kernel/bounds.s
In file included from /home/space/kas/git/public/linux/arch/ia64/include/asm/thread_info.h:9:0,
                 from include/linux/thread_info.h:54,
                 from include/asm-generic/preempt.h:4,
                 from arch/ia64/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from kernel/bounds.c:14:
/home/space/kas/git/public/linux/arch/ia64/include/asm/asm-offsets.h:1:35: fatal error: generated/asm-offsets.h: No such file or directory
compilation terminated.

Let's replace <linux/spinlock.h> with <linux/spinlock_types.h>, it's
enough to find out size of spinlock_t.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 kernel/bounds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bounds.c b/kernel/bounds.c
index 578782ef6ae1..5253204afdca 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -11,7 +11,7 @@
 #include <linux/kbuild.h>
 #include <linux/page_cgroup.h>
 #include <linux/log2.h>
-#include <linux/spinlock.h>
+#include <linux/spinlock_types.h>
 
 void foo(void)
 {
-- 
 Kirill A. Shutemov
