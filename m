Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbaICWOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:14:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933654AbaICWIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 3.14 56/88] xen/events/fifo: ensure all bitops are properly aligned even on x86
Date: Wed,  3 Sep 2014 15:05:30 -0700
Message-Id: <20140903220517.639091815@linuxfoundation.org>
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

From: David Vrabel <david.vrabel@citrix.com>

commit dcecb8fd93a65787130a74e61fdf29932c8d85eb upstream.

When using the FIFO-based ABI on x86_64, if the last port is at the
end of an event array page then sync_test_bit() on this port's event
word will read beyond the end of the page and in certain circumstances
this may fault.

The fault requires the following page in the kernel's direct mapping
to be not present, which would mean:

a) the array page is the last page of RAM; or

b) the following page is ballooned out /and/ it has been used for a
   foreign mapping by a kernel driver (such as netback or blkback)
   /and/ the grant has been unmapped.

Use the infrastructure added for arm64 to ensure that all bitops
operating on event words are unsigned long aligned.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events/events_fifo.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -67,10 +67,9 @@ static event_word_t *event_array[MAX_EVE
 static unsigned event_array_pages __read_mostly;
 
 /*
- * sync_set_bit() and friends must be unsigned long aligned on non-x86
- * platforms.
+ * sync_set_bit() and friends must be unsigned long aligned.
  */
-#if !defined(CONFIG_X86) && BITS_PER_LONG > 32
+#if BITS_PER_LONG > 32
 
 #define BM(w) (unsigned long *)((unsigned long)w & ~0x7UL)
 #define EVTCHN_FIFO_BIT(b, w) \


