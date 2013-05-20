Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3ETLUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:20:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56041 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab3ETKwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 027/115] powerpc: Add isync to copy_and_flush
Date: Mon, 20 May 2013 11:50:27 +0100
Message-Id: <1369047116-9378-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <michael.neuling@au1.ibm.com>

commit 29ce3c5073057991217916abc25628e906911757 upstream.

In __after_prom_start we copy the kernel down to zero in two calls to
copy_and_flush.  After the first call (copy from 0 to copy_to_here:)
we jump to the newly copied code soon after.

Unfortunately there's no isync between the copy of this code and the
jump to it.  Hence it's possible that stale instructions could still be
in the icache or pipeline before we branch to it.

We've seen this on real machines and it's results in no console output
after:
  calling quiesce...
  returning from prom_init

The below adds an isync to ensure that the copy and flushing has
completed before any branching to the new instructions occurs.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/head_64.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 9e07bd0..1a3607b 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -489,6 +489,7 @@ _GLOBAL(copy_and_flush)
 	sync
 	addi	r5,r5,8
 	addi	r6,r6,8
+	isync
 	blr
 
 .align 8
-- 
1.8.1.2

