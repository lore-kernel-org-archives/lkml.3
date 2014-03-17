Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaCQUMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:12:10 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:45792 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaCQUMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:12:08 -0400
Date: Mon, 17 Mar 2014 16:12:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH percpu/for-3.15] percpu: allocation size should be even
Message-ID: <20140317201201.GD17373@mtj.dyndns.org>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
 <20140305034919.GA26528@ZenIV.linux.org.uk>
 <20140306192026.GA14033@htj.dyndns.org>
 <20140306203030.GA18016@ZenIV.linux.org.uk>
 <20140306204726.GE14033@htj.dyndns.org>
 <20140307025206.GB18016@ZenIV.linux.org.uk>
 <20140314184545.GA29750@ZenIV.linux.org.uk>
 <20140314184745.GC6889@mtj.dyndns.org>
 <20140314185320.GO18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314185320.GO18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2f69fa829cb4ca062aaffee9ab9eb44484db75b1 Mon Sep 17 00:00:00 2001
From: Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 17 Mar 2014 16:01:27 -0400

723ad1d90b56 ("percpu: store offsets instead of lengths in ->map[]")
updated percpu area allocator to use the lowest bit, instead of sign,
to signify whether the area is occupied and forced min align to 2;
unfortunately, it forgot to force the allocation size to be even
causing malfunctions for the very rare odd-sized allocations.

Always force the allocations to be even sized.

tj: Wrote patch description.

Original-patch-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to percpu/for-3.15.

Thanks.

 mm/percpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index c7206d0..202e104 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -713,11 +713,14 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 
 	/*
 	 * We want the lowest bit of offset available for in-use/free
-	 * indicator.
+	 * indicator, so force >= 16bit alignment and make size even.
 	 */
 	if (unlikely(align < 2))
 		align = 2;
 
+	if (unlikely(size & 1))
+		size++;
+
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
 		     "percpu allocation\n", size, align);
-- 
1.8.5.3

