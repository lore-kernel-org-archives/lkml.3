Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaJIVGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:06:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbaJIVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:06:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 140/163] parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds
Date: Thu,  9 Oct 2014 14:02:45 -0700
Message-Id: <1412888588-26755-141-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/parisc/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 7187664..5db8882 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -48,7 +48,12 @@ cflags-y	:= -pipe
 
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

