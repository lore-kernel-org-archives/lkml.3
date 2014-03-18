Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbaCRT2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:28:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856AbaCRT0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/5] x86/boot: undef memcmp before providing a new definition
Date: Tue, 18 Mar 2014 15:26:36 -0400
Message-Id: <1395170800-11059-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1395170800-11059-1-git-send-email-vgoyal@redhat.com>
References: <1395170800-11059-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_X86_32=y, string_32.h gets pulled in compressed/string.c by
"misch.h". string_32.h defines a macro to map memcmp to __builtin_memcmp().
And that macro in turn changes the name of memcmp() defined here and
converts it to __builtin_memcmp().

I thought that's not the intention though. We probably want to provide
our own optimized definition of memcmp(). If yes, then undef the memcmp
before we define a new memcmp.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/boot/compressed/string.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index ffb9c5c..212004e 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,5 +1,7 @@
 #include "misc.h"
 
+/* Avoid intereference from any defines in string_32.h */
+#undef memcmp
 int memcmp(const void *s1, const void *s2, size_t len)
 {
 	u8 diff;
-- 
1.8.5.3

