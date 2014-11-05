Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbaKESDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:03:48 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:53541 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKESDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:03:47 -0500
Date: Wed, 5 Nov 2014 18:03:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linus GIT 3.18.0-rc2+ - BUG: unable to handle kernel paging
 request at ffff88021dc52000 - IP: [<ffffffff810f5514>] scan_block+0x59/0x100
Message-ID: <20141105180322.GO32700@e104818-lin.cambridge.arm.com>
References: <CAHFgRy-336YNdbeQh8vjPrSY7=VLfQ-LZwUjEDD=xy5tv4dEAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHFgRy-336YNdbeQh8vjPrSY7=VLfQ-LZwUjEDD=xy5tv4dEAg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:11:39PM +0000, Miles Lane wrote:
> [   69.271345] BUG: unable to handle kernel paging request at ffff88021dc52000
> [   69.271417] IP: [<ffffffff810f5514>] scan_block+0x59/0x100
[...]
> [   69.273425] Call Trace:
> [   69.273452]  [<ffffffff81507471>] ? _raw_spin_lock_irqsave+0x48/0x52
> [   69.273506]  [<ffffffff810f569d>] ? scan_gray_list+0xe2/0x15f
> [   69.273561]  [<ffffffff810f5672>] scan_gray_list+0xb7/0x15f
> [   69.273615]  [<ffffffff810f59ae>] kmemleak_scan+0x294/0x45e
> [   69.273662]  [<ffffffff810f5ecc>] ? kmemleak_write+0x354/0x354
> [   69.273711]  [<ffffffff810f5f4e>] kmemleak_scan_thread+0x82/0xa4

It looks like kmemleak scans an object which is not mapped.
Unfortunately, it doesn't tell us where the object has been allocated.

As a quick hack, for an architecture that implements kern_addr_valid()
by walking the page tables (I think x86_64 does it), could you try this
patch and see if it reports any more information? Once we know which
object, we can call kmemleak_no_scan() or kmemleak_ignore() on such
object.

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 3cda50c1e394..eab2bf39a3f3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1226,6 +1226,12 @@ static void scan_object(struct kmemleak_object *object)
 	if (!(object->flags & OBJECT_ALLOCATED))
 		/* already freed object */
 		goto out;
+	if (!kern_addr_valid(object->pointer)) {
+		kmemleak_warn("Invalid object address: 0x%08lx\n",
+			      object->pointer);
+		dump_object_info(object);
+		goto out;
+	}
 	if (hlist_empty(&object->area_list)) {
 		void *start = (void *)object->pointer;
 		void *end = (void *)(object->pointer + object->size);

(another solution would be to use get_user in combination with set_fs
during scanning to trap such faulting accesses)

Thanks.

-- 
Catalin
