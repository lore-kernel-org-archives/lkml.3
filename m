Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3EJOdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:33:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57198 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755495Ab3EJOVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:32 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Michael Neuling" <michael.neuling@au1.ibm.com>,
        "Michael Neuling" <mikey@neuling.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.523881156@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [060/118] powerpc: Add isync to copy_and_flush
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/head_64.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -502,6 +502,7 @@ _GLOBAL(copy_and_flush)
 	sync
 	addi	r5,r5,8
 	addi	r6,r6,8
+	isync
 	blr
 
 .align 8

