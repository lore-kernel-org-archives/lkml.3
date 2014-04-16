Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422658AbaDPPyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:54:11 -0400
Received: from smtp102.biz.mail.gq1.yahoo.com ([98.137.12.177]:26572 "HELO
	smtp102.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161580AbaDPPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:54:08 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 11:54:08 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QICKJWwVM1lVt6jBKoJ0dzZb5mDsKZoclkeAe1i1QBQT3_g
 58mLEAYRZzOiuQVqwy78Yn_DlaYOH5cvL4lKCAGiKW265H0qNPGbQkvL2Ud2
 NKBs8cfwfaKbIx54sqZcmI6yJ1V8_j3_Fu2rxLKGfkxHgws9zhwFv1tTj.NO
 sxzskJEsUQLcYLcGo68vf6gY7Pprhvnw08XaPf0S3EQQwylqBfiL2.E.aXJY
 E8fsLm7E67lpcdyCCzjB4DVhq5cRO56yINxnjoOY539NuHjTyX4FVlVBhN0b
 WUeipDhfNBGS1AsbsXUkmZpiGh.1g30Dp9PTjPG1z38X2VrTVKEwfEQDFlU9
 xaxEmkPRg6wA2saFooZ869o0rYywM5GDR2DB2zfL7xkGIHQf93tc6AUlfqab
 hHtkuxFyc2iCy5lbLW5XPPu.qPeuVVFf1adzVD4QohvUMsKzvEQfRqBEfUKz
 KQHueJzpGlaMtH5_FzzLoopRgXZZ8yIPoezlduz35NH5vfNL3Ca5XOrcXUI8
 X8lnS1IYwrW5VRQlm..M-
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-Rocket-Received: from fdwdc.com (sfking@66.235.32.29 with plain [208.71.40.208])
        by smtp102.biz.mail.gq1.yahoo.com with SMTP; 16 Apr 2014 08:47:28 -0700 PDT
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: v3.15-rc1 slab allocator broken on m68knommu (coldfire)
Date: Wed, 16 Apr 2014 08:47:27 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
        uClinux development list <uclinux-dev@uclinux.org>
References: <201404141745.44279.sfking@fdwdc.com> <20140416001931.GA17350@js1304-P5Q-DELUXE>
In-Reply-To: <20140416001931.GA17350@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201404160847.27300.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2014 5:19:31 pm Joonsoo Kim wrote:
> On Mon, Apr 14, 2014 at 05:45:43PM -0700, Steven King wrote:
> > git bisect suggests it starts somewhere around commit
> > f315e3fa1cf5b3317fc948708645fff889ce1e63 slab: restrict the number of
> > objects in a slab
> >
> > but its kinda hard to tell as there is some compile breakage in there as
> > well.
>
> Hello, Steven.
>
> Hmm... there is the fix on upstream v3.15-rc1 for build breakage.
> See commit 24f870d('slab: fix wrongly used macro').
> If slab allocator broken with this fix, please let me know.
>
> Thanks.


Yes, 24f870d fixes the build breakage but the allocator is still broken (board
doesn't boot).  However, I was able to track down the exact changes that seem
to break things; in 8dcc774 'slab: introduce byte sized index for the freelist of a slab'
there are the changes to get_free_obj and set_free_obj:

-static inline unsigned int get_free_obj(struct page *page, unsigned int idx)
+static inline freelist_idx_t get_free_obj(struct page *page, unsigned char idx)
 {
-	return ((unsigned int *)page->freelist)[idx];
+	return ((freelist_idx_t *)page->freelist)[idx];
 }
 
 static inline void set_free_obj(struct page *page,
-					unsigned int idx, unsigned int val)
+					unsigned char idx, freelist_idx_t val)
 {
-	((unsigned int *)(page->freelist))[idx] = val;
+	((freelist_idx_t *)(page->freelist))[idx] = val;
 }
 
if I change idx back to unsigned int, ie:

diff --git a/mm/slab.c b/mm/slab.c
index 388cb1a..d7f9f44 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2572,13 +2572,13 @@ static void *alloc_slabmgmt(struct kmem_cache *cachep,
        return freelist;
 }

-static inline freelist_idx_t get_free_obj(struct page *page, unsigned char idx)
+static inline freelist_idx_t get_free_obj(struct page *page, unsigned int idx)
 {
        return ((freelist_idx_t *)page->freelist)[idx];
 }

 static inline void set_free_obj(struct page *page,
-                                       unsigned char idx, freelist_idx_t val)
+                                       unsigned int idx, freelist_idx_t val)
 {
        ((freelist_idx_t *)(page->freelist))[idx] = val;
 }


then v3.15-rc1 will boot using the slab allocator.
