Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab3BWUEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 15:04:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:36018 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab3BWUEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 15:04:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,723,1355126400"; 
   d="scan'208";a="205628707"
Message-ID: <1361649846.4025.28.camel@ideak-mobl>
Subject: Re: [PATCH v3 2/2] lib/scatterlist: use page iterator in the
 mapping iterator
From: Imre Deak <imre.deak@intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Date: Sat, 23 Feb 2013 22:04:06 +0200
In-Reply-To: <51284595.5040903@wwwdotorg.org>
References: <1360768224-18163-1-git-send-email-imre.deak@intel.com>
	 <1360768224-18163-2-git-send-email-imre.deak@intel.com>
	 <51284595.5040903@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 21:29 -0700, Stephen Warren wrote:
> On 02/13/2013 08:10 AM, Imre Deak wrote:
> > For better code reuse use the newly added page iterator to iterate
> > through the pages. The offset, length within the page is still
> > calculated by the mapping iterator as well as the actual mapping.
> > Idea from Tejun Heo <tj@kernel.org>.
> 
> This patch appears in linux-next since next-20130220. It breaks mounting
> a root filesystem on an SD card on the Raspberry Pi ARM platform, with
> errors such as those shown below.
> 
> next-20130222 with just this patch reverted works fine.

Thanks for tracking this down. I noticed now an obvious mistake I've
made, not limiting the mapping size to page size :/ I didn't hit it
since it only causes a problem when the user of miter modifies
miter->consumed and I think nothing does this on my machine. Since the
sdhci driver on Raspberry Pi does this the following might fix the
problem you saw. Could you give it a try? It applies on top of
v4 of the patch [1]:

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 2645acf..b83c144 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -493,6 +493,8 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 		miter->__offset = pgoffset ? 0 : sg->offset;
 		miter->__remaining = sg->offset + sg->length -
 				(pgoffset << PAGE_SHIFT) - miter->__offset;
+		miter->__remaining = min_t(unsigned long, miter->__remaining,
+					   PAGE_SIZE - miter->__offset);
 	}
 	miter->page = miter->piter.page;
 	miter->consumed = miter->length = miter->__remaining;


--Imre

[1]
http://lists.linaro.org/pipermail/linaro-mm-sig/2013-February/003069.html

