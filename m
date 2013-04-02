Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab3DBRMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:12:12 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:58395 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab3DBRMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:12:10 -0400
From: Antony Pavlov <antonynpavlov@gmail.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>
Subject: [RFC] kbuild: fix ld-option function
Date: Tue,  2 Apr 2013 21:13:42 +0400
Message-Id: <1364922822-7510-1-git-send-email-antonynpavlov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kbuild's ld-option function is broken because
the command
  $(CC) /dev/null -c -o "$$TMPO"
does not create object file!

I have used a relatively old mips gcc 3.4.6 cross-compiler
and a relatively new gcc 4.7.2 to check this fact
but the results are the same.

EXAMPLE:
  $ rm /tmp/1.o
  $ mips-linux-gcc /dev/null -c -o /tmp/1.o
  mips-linux-gcc: /dev/null: linker input file unused because linking not done
  $ ls -la /tmp/1.o
  ls: cannot access /tmp/1.o: No such file or directory

We can easily fix the problem by adding
the '-x c' compiler option.

EXAMPLE:
  $ rm /tmp/1.o
  $ mips-linux-gcc -x c /dev/null -c -o /tmp/1.o
  $ ls -la /tmp/1.o
  -rw-r--r-- 1 antony antony 778 Apr  2 20:40 /tmp/1.o

Signed-off-by: Antony Pavlov <antonynpavlov@gmail.com>
---
 scripts/Kbuild.include |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 978416d..547e15d 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -148,7 +148,7 @@ cc-ldoption = $(call try-run,\
 # ld-option
 # Usage: LDFLAGS += $(call ld-option, -X)
 ld-option = $(call try-run,\
-	$(CC) /dev/null -c -o "$$TMPO" ; $(LD) $(1) "$$TMPO" -o "$$TMP",$(1),$(2))
+	$(CC) -x c /dev/null -c -o "$$TMPO" ; $(LD) $(1) "$$TMPO" -o "$$TMP",$(1),$(2))
 
 # ar-option
 # Usage: KBUILD_ARFLAGS := $(call ar-option,D)
-- 
1.7.10.4

