Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaAUV3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:29:54 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50926 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbaAUV3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:29:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Geoff Levand <geoff@infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 10/73] powerpc: use device_initcall for registering rtc devices
Date: Tue, 21 Jan 2014 16:22:13 -0500
Message-ID: <1390339396-3479-11-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently these two RTC devices are in core platform code
where it is not possible for them to be modular.  It will
never be modular, so using module_init as an alias for
__initcall can be somewhat misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of device_initcall
directly in this change means that the runtime impact is
zero -- they will remain at level 6 in initcall ordering.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/time.c        | 2 +-
 arch/powerpc/platforms/ps3/time.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b3dab20..63b34fc 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -1064,4 +1064,4 @@ static int __init rtc_init(void)
 	return PTR_ERR_OR_ZERO(pdev);
 }
 
-module_init(rtc_init);
+device_initcall(rtc_init);
diff --git a/arch/powerpc/platforms/ps3/time.c b/arch/powerpc/platforms/ps3/time.c
index ce73ce8..791c614 100644
--- a/arch/powerpc/platforms/ps3/time.c
+++ b/arch/powerpc/platforms/ps3/time.c
@@ -92,5 +92,4 @@ static int __init ps3_rtc_init(void)
 
 	return PTR_ERR_OR_ZERO(pdev);
 }
-
-module_init(ps3_rtc_init);
+device_initcall(ps3_rtc_init);
-- 
1.8.4.1

