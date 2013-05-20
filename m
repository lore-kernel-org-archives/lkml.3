Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3ETILO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 04:11:14 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14829 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3ETILM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 04:11:12 -0400
X-Spam-Score: -100.8
Message-ID: <5199DA6A.3010902@asianux.com>
Date: Mon, 20 May 2013 16:10:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>, js1304@gmail.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [Suggestion] mm/bootmem.c: need return failure code when BUG()  neither
 CONFIG_BUG nor HAVE_ARCH_BUG is defined.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

If neither CONFIG_BUG nor HAVE_ARCH_BUG is defined, the BUG() will
defined as empty (e.g. randconfig with MMU for arm s5pv210)

As a function, it need return an error code to upper caller, but excuse
me, I can not find the suitable error code for return (it seems only
'return -1' is not suitable).

Please help check, thanks.


356 static int __init mark_bootmem(unsigned long start, unsigned long end,
357                                 int reserve, int flags)
358 {
359         unsigned long pos;
360         bootmem_data_t *bdata;
361 
362         pos = start;
363         list_for_each_entry(bdata, &bdata_list, list) {
364                 int err;
365                 unsigned long max;
366 
367                 if (pos < bdata->node_min_pfn ||
368                     pos >= bdata->node_low_pfn) {
369                         BUG_ON(pos != start);
370                         continue;
371                 }
372 
373                 max = min(bdata->node_low_pfn, end);
374 
375                 err = mark_bootmem_node(bdata, pos, max, reserve, flags);
376                 if (reserve && err) {
377                         mark_bootmem(start, pos, 0, 0);
378                         return err;
379                 }
380 
381                 if (max == end)
382                         return 0;
383                 pos = bdata->node_low_pfn;
384         }
385         BUG();
386 }



Thanks.
-- 
Chen Gang

Asianux Corporation
