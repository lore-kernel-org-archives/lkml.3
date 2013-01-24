Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030178Ab3AXUJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:09:51 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54079
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898Ab3AXUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Al Cooper <alcooperx@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 35/74] perf tools: Fix GNU make v3.80 compatibility issue
Date: Thu, 24 Jan 2013 17:07:44 -0300
Message-Id: <1359058103-31645-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Cooper <alcooperx@gmail.com>

According to Documentation/Changes, the kernel should be buildable with
GNU make 3.80+. tools/perf/config/utilities.mak contains the "$(or"
construct, which requires make 3.81.  This causes "make" to fail on
systems with GNU make 3.80.

Replace "$(or" with an equivalent "$(if" expression, to restore backward
compatibility. Also fix an issue where _get_attempt was called with only
one argument. This prevented the error message from printing the name of
the variable that can be used to fix the problem.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1357680156-15520-1-git-send-email-alcooperx@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/utilities.mak | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index e541312..8ef3bd3 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -13,7 +13,7 @@ newline := $(newline)
 # what should replace a newline when escaping
 # newlines; the default is a bizarre string.
 #
-nl-escape = $(or $(1),m822df3020w6a44id34bt574ctac44eb9f4n)
+nl-escape = $(if $(1),$(1),m822df3020w6a44id34bt574ctac44eb9f4n)
 
 # escape-nl
 #
@@ -173,9 +173,9 @@ _ge-abspath = $(if $(is-executable),$(1))
 # Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)
 #
 define get-executable-or-default
-$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
+$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
 endef
-_ge_attempt = $(or $(get-executable),$(_gea_warn),$(call _gea_err,$(2)))
+_ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 
-- 
1.8.1.1.361.gec3ae6e

