Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab3HMUPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:15:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab3HMUPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:15:12 -0400
Date: Tue, 13 Aug 2013 13:15:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm: use zone_end_pfn() instead of
 zone_start_pfn+spanned_pages
Message-Id: <20130813131510.59ef74bce81d9352f8590218@linux-foundation.org>
In-Reply-To: <52020EE4.1090606@huawei.com>
References: <52020EE4.1090606@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013 17:09:56 +0800 Xishi Qiu <qiuxishi@huawei.com> wrote:

> Use "zone_end_pfn()" instead of "zone->zone_start_pfn + zone->spanned_pages".
> Simplify the code, no functional change.

This doesn't compile.

mm/memory_hotplug.c: In function 'shrink_zone_span':
mm/memory_hotplug.c:518: error: called object 'zone_end_pfn' is not a function

>  kernel/power/snapshot.c |   12 ++++++------
>  mm/memory_hotplug.c     |    4 ++--

It's only two files - did you test it?

I couldn't see any vaguely acceptable way of renaming the variables to
fix this, so I did a hack which permits us to keep the current naming.
Any better ideas?

--- a/mm/memory_hotplug.c~mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix
+++ a/mm/memory_hotplug.c
@@ -514,8 +514,9 @@ static int find_biggest_section_pfn(int
 static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
-	unsigned long zone_start_pfn =  zone->zone_start_pfn;
-	unsigned long zone_end_pfn = zone_end_pfn(zone);
+	unsigned long zone_start_pfn = zone->zone_start_pfn;
+	unsigned long z = zone_end_pfn(zone); /* zone_end_pfn namespace clash */
+	unsigned long zone_end_pfn = z;
 	unsigned long pfn;
 	struct mem_section *ms;
 	int nid = zone_to_nid(zone);
_

