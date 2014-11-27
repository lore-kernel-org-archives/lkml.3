Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaK0I7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:59:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:42373 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbaK0ItE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:04 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 61/91] parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds
Date: Thu, 27 Nov 2014 16:42:44 +0800
Message-Id: <1417077794-9299-61-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit d26a7730b5874a5fa6779c62f4ad7c5065a94723 upstream.

In spite of what the GCC manual says, the -mfast-indirect-calls has
never been supported in the 64-bit parisc compiler. Indirect calls have
always been done using function descriptors irrespective of the
-mfast-indirect-calls option.

Recently, it was noticed that a function descriptor was always requested
when the -mfast-indirect-calls option was specified. This caused
problems when the option was used in  application code and doesn't make
any sense because the whole point of the option is to avoid using a
function descriptor for indirect calls.

Fixing this broke 64-bit kernel builds.

I will fix GCC but for now we need the attached change. This results in
the same kernel code as before.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/parisc/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 19ab7b2..ac93ca2 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -51,7 +51,12 @@ cflags-y	:= -pipe
 
 # These flags should be implied by an hppa-linux configuration, but they
 # are not in gcc 3.2.
-cflags-y	+= -mno-space-regs -mfast-indirect-calls
+cflags-y	+= -mno-space-regs
+
+# -mfast-indirect-calls is only relevant for 32-bit kernels.
+ifndef CONFIG_64BIT
+cflags-y	+= -mfast-indirect-calls
+endif
 
 # Currently we save and restore fpregs on all kernel entry/interruption paths.
 # If that gets optimized, we might need to disable the use of fpregs in the
-- 
1.9.1

