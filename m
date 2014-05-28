Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaE1CpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:45:16 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:12321 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbaE1CpO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:45:14 -0400
X-Greylist: delayed 1223 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2014 22:45:11 EDT
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'cody@linux.vnet.ibm.com'" <cody@linux.vnet.ibm.com>,
        "'linux-arch-owner@vger.kernel.org'" 
	<linux-arch-owner@vger.kernel.org>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'hannes@cmpxchg.org'" <hannes@cmpxchg.org>
Date: Wed, 28 May 2014 10:24:44 +0800
Subject: MIGRATE_RESERVE  pages in show_mem function problems
Thread-Topic: MIGRATE_RESERVE  pages in show_mem function problems
Thread-Index: Ac96G/0ZSTv5fEucSyicb0besNhiaQ==
Message-ID: <35FD53F367049845BC99AC72306C23D1029A27656A08@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  

I find the show_mem function show page MIGRATE types result is not correct for
MIGRATE_RESERVE pages :

Normal: 1582*4kB (UEMC) 1317*8kB (UEMC) 1020*16kB (UEMC) 450*32kB (UEMC) 206*64kB (UEMC) 40*128kB (UM) 10*256kB (UM) 10*512kB (UM) 1*1024kB (M) 0*2048kB 0*4096kB = 74592kB

Some pages should be marked (R)  , while it is changed into MIGRATE_MOVEABLE or UNMOVEABLE in free_area list ,
It's not correct for debug .
I make a patch for this:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5dba293..6ef8ebe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1198,7 +1198,8 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
                        list_add_tail(&page->lru, list);
                if (IS_ENABLED(CONFIG_CMA)) {
                        mt = get_pageblock_migratetype(page);
-                       if (!is_migrate_cma(mt) && !is_migrate_isolate(mt))
+                       if (!is_migrate_cma(mt) && !is_migrate_isolate(mt)
+                               && mt != MIGRATE_RESERVE)
                                mt = migratetype;
                }
                set_freepage_migratetype(page, mt);


seems work ok , I am curious is it a BUG ? or designed like this for some reason ?

Thanks 


<6>[  250.751554] lowmem_reserve[]: 0 0 0
<6>[  250.751606] Normal: 1582*4kB (UEMC) 1317*8kB (UEMC) 1020*16kB (UEMC) 450*32kB (UEMC) 206*64kB (UEMC) 40*128kB (UM) 10*256kB (UM) 10*512kB (UM) 1*1024kB (M) 0*2048kB 0*4096kB = 74592kB
<6>[  250.751848] HighMem: 167*4kB (UC) 3*8kB (U) 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 692kB
<6>[  250.752020] 62596 total pagecache pages
<6>[  250.752046] 0 pages in swap cache
<6>[  250.752074] Swap cache stats: add 0, delete 0, find 0/0




Sony Mobile Communications
Tel: My Number +18610323092
yalin.wang@sonymobile.com  
sonymobile.com



