Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbaICWOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:14:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650AbaICWIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 55/88] hpsa: fix non-x86 builds
Date: Wed,  3 Sep 2014 15:05:29 -0700
Message-Id: <20140903220517.608065055@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 0b9e7b741f2bf8103b15bb14d5b4a6f5ee91c59a upstream.

commit 28e134464734 "[SCSI] hpsa: enable unit attention reporting"
turns on unit attention notifications, but got the change wrong for
all architectures other than x86, which now store an uninitialized
value into the device register.

Gcc helpfully warns about this:

../drivers/scsi/hpsa.c: In function 'hpsa_set_driver_support_bits':
../drivers/scsi/hpsa.c:6373:17: warning: 'driver_support' is used uninitialized in this function [-Wuninitialized]
  driver_support |= ENABLE_UNIT_ATTN;
                 ^

This moves the #ifdef so only the prefetch-enable is conditional
on x86, not also reading the initial register contents.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 28e134464734 "[SCSI] hpsa: enable unit attention reporting"
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4367,9 +4367,9 @@ static inline void hpsa_set_driver_suppo
 {
 	u32 driver_support;
 
-#ifdef CONFIG_X86
-	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
 	driver_support = readl(&(h->cfgtable->driver_support));
+	/* Need to enable prefetch in the SCSI core for 6400 in x86 */
+#ifdef CONFIG_X86
 	driver_support |= ENABLE_SCSI_PREFETCH;
 #endif
 	driver_support |= ENABLE_UNIT_ATTN;


