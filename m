Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab3LXGHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 01:07:10 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57555 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3LXGHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 01:07:07 -0500
X-AuditID: 9c930197-b7c4aae000003d84-a6-52b924884b6f
Date: Tue, 24 Dec 2013 15:07:05 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, khlebnikov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>
Subject: Re: mm: kernel BUG at include/linux/swapops.h:131!
Message-ID: <20131224060705.GA16140@lge.com>
References: <52B1C143.8080301@oracle.com>
 <52B871B2.7040409@oracle.com>
 <20131224025127.GA2835@lge.com>
 <52B8F8F6.1080500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B8F8F6.1080500@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 10:01:10PM -0500, Sasha Levin wrote:
> On 12/23/2013 09:51 PM, Joonsoo Kim wrote:
> >On Mon, Dec 23, 2013 at 12:24:02PM -0500, Sasha Levin wrote:
> >>>Ping?
> >>>
> >>>I've also Cc'ed the "this page shouldn't be locked at all" team.
> >Hello,
> >
> >I can't find the reason of this problem.
> >If it is reproducible, how about bisecting?
> 
> While it reproduces under fuzzing it's pretty hard to bisect it with
> the amount of issues uncovered by trinity recently.
> 
> I can add any debug code to the site of the BUG if that helps.

Good!
It will be helpful to add dump_page() in migration_entry_to_page().

Thanks.

--------8<------
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index c0f7526..f695abc 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -3,6 +3,7 @@
 
 #include <linux/radix-tree.h>
 #include <linux/bug.h>
+#include <linux/mm.h>
 
 /*
  * swapcache pages are stored in the swapper_space radix tree.  We want to
@@ -128,6 +129,8 @@ static inline struct page *migration_entry_to_page(swp_entry_t entry)
         * Any use of migration entries may only occur while the
         * corresponding page is locked
         */
+       if (!PageLocked(p))
+               dump_page(p);
        BUG_ON(!PageLocked(p));
        return p;
 }

