Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab3CSJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:26:25 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48329 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3CSJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:26:18 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 0/8] staging: zcache: Support zero-filled pages more efficiently
Date: Tue, 19 Mar 2013 17:25:42 +0800
Message-Id: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031909-1618-0000-0000-000003880C5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Since you have already merge 1/8, feel free to merge 2/8~8/8, I have already 
rebased against staging-next.

Changelog:
 v3 -> v4:
  * handle duplication in page_is_zero_filled, spotted by Bob
  * fix zcache writeback in dubugfs 
  * fix pers_pageframes|_max isn't exported in debugfs
  * fix static variable defined in debug.h but used in multiple C files 
  * rebase on Greg's staging-next
 v2 -> v3:
  * increment/decrement zcache_[eph|pers]_zpages for zero-filled pages, spotted by Dan 
  * replace "zero" or "zero page" by "zero_filled_page", spotted by Dan
 v1 -> v2:
  * avoid changing tmem.[ch] entirely, spotted by Dan.
  * don't accumulate [eph|pers]pageframe and [eph|pers]zpages for 
    zero-filled pages, spotted by Dan
  * cleanup TODO list
  * add Dan Acked-by.

Motivation:

- Seth Jennings points out compress zero-filled pages with LZO(a lossless 
  data compression algorithm) will waste memory and result in fragmentation.
  https://lkml.org/lkml/2012/8/14/347
- Dan Magenheimer add "Support zero-filled pages more efficiently" feature 
  in zcache TODO list https://lkml.org/lkml/2013/2/13/503

Design:

- For store page, capture zero-filled pages(evicted clean page cache pages and 
  swap pages), but don't compress them, set pampd which store zpage address to
  0x2(since 0x0 and 0x1 has already been ocuppied) to mark special zero-filled
  case and take advantage of tmem infrastructure to transform handle-tuple(pool
  id, object id, and an index) to a pampd. Twice compress zero-filled pages will
  contribute to one zcache_[eph|pers]_pageframes count accumulated.
- For load page, traverse tmem hierachical to transform handle-tuple to pampd 
  and identify zero-filled case by pampd equal to 0x2 when filesystem reads
  file pages or a page needs to be swapped in, then refill the page to zero
  and return.

Test:

dd if=/dev/zero of=zerofile bs=1MB count=500
vmtouch -t zerofile
vmtouch -e zerofile

formula:
- fragmentation level = (zcache_[eph|pers]_pageframes * PAGE_SIZE - zcache_[eph|pers]_zbytes) 
  * 100 / (zcache_[eph|pers]_pageframes * PAGE_SIZE)
- memory zcache occupy = zcache_[eph|pers]_zbytes 

Result:

without zero-filled awareness:
- fragmentation level: 98%
- memory zcache occupy: 238MB
with zero-filled awareness:
- fragmentation level: 0%
- memory zcache occupy: 0MB

Wanpeng Li (8):
  introduce zero filled pages handler
  zero-filled pages awareness
  handle zcache_[eph|pers]_pages for zero-filled page
  fix pers_pageframes|_max aren't exported in debugfs
  fix zcache writeback in debugfs
  fix static variables are defined in debug.h but use in multiple C files
  introduce zero-filled page stat count
  clean TODO list

 drivers/staging/zcache/TODO          |    3 +-
 drivers/staging/zcache/debug.c       |    5 +-
 drivers/staging/zcache/debug.h       |   77 +++++++++++++---------
 drivers/staging/zcache/zcache-main.c |  147 ++++++++++++++++++++++++++++++----
 4 files changed, 185 insertions(+), 47 deletions(-)

-- 
1.7.7.6

