Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab3AOWck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:32:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:42861 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447Ab3AOWch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 135/221] vfs: add missing virtual cache flush after editing partial pages
Date: Tue, 15 Jan 2013 10:51:02 -0800
Message-Id: <20130115185007.797866124@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6d283dba3721cc43be014b50a1acc2f35860a65a upstream.

Andrew Morton pointed this out a month ago, and then I completely forgot
about it.

If we read a partial last page of a block device, we will zero out the
end of the page, but since that page can then be mapped into user space,
we should also make sure to flush the cache on architectures that have
virtual caches.  We have the flush_dcache_page() function for this, so
use it.

Now, in practice this really never matters, because nobody sane uses
virtual caches to begin with, and they largely exist on old broken RISC
arhitectures.

And even if you did run on one of those obsolete CPU's, the whole "mmap
and access the last partial page of a block device" behavior probably
doesn't actually exist.  The normal IO functions (read/write) will never
see the zeroed-out part of the page that migth not be coherent in the
cache, because they honor the size of the device.

So I'm marking this for stable (3.7 only), but I'm not sure anybody will
ever care.

Pointed-out-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2939,6 +2939,7 @@ static void guard_bh_eod(int rw, struct
 		void *kaddr = kmap_atomic(bh->b_page);
 		memset(kaddr + bh_offset(bh) + bytes, 0, bh->b_size - bytes);
 		kunmap_atomic(kaddr);
+		flush_dcache_page(bh->b_page);
 	}
 }
 


