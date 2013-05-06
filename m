Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab3EFXos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:44:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab3EFW64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:58:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 01/46] powerpc: Add isync to copy_and_flush
Date: Mon,  6 May 2013 15:58:07 -0700
Message-Id: <20130506225820.794865564@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_64.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -492,6 +492,7 @@ _GLOBAL(copy_and_flush)
 	sync
 	addi	r5,r5,8
 	addi	r6,r6,8
+	isync
 	blr
 
 .align 8


