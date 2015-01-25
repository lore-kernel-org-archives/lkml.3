Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbbAYSj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:39:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbbAYSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Maydell <Peter.Maydell@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.18 117/183] arm64: partially revert "ARM: 8167/1: extend the reserved memory for initrd to be page aligned"
Date: Sun, 25 Jan 2015 10:07:19 -0800
Message-Id: <20150125180815.276456685@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 0145058c3d30b4319d747f64caa16a9cb15f0581 upstream.

This patch partially reverts commit 421520ba98290a73b35b7644e877a48f18e06004
(only the arm64 part). There is no guarantee that the boot-loader places other
images like dtb in a different page than initrd start/end, especially when the
kernel is built with 64KB pages. When this happens, such pages must not be
freed. The free_reserved_area() already takes care of rounding up "start" and
rounding down "end" to avoid freeing partially used pages.

Reported-by: Peter Maydell <Peter.Maydell@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/init.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -333,14 +333,8 @@ static int keep_initrd;
 
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (!keep_initrd) {
-		if (start == initrd_start)
-			start = round_down(start, PAGE_SIZE);
-		if (end == initrd_end)
-			end = round_up(end, PAGE_SIZE);
-
+	if (!keep_initrd)
 		free_reserved_area((void *)start, (void *)end, 0, "initrd");
-	}
 }
 
 static int __init keepinitrd_setup(char *__unused)


