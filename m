Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbaLBCuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 21:50:14 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:53088 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbaLBCuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 21:50:10 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Luigi Semenzato <semenzato@google.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/6] zsmalloc support compaction
Date: Tue,  2 Dec 2014 11:49:41 +0900
Message-Id: <1417488587-28609-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, there was issue about zsmalloc fragmentation and
I got a report from Juno that new fork failed although there
are plenty of free pages in the system.
His investigation revealed zram is one of the culprit to make
heavy fragmentation so there was no more contiguous 16K page
for pgd to fork in the ARM.

This patchset implement *basic* zsmalloc compaction support
and zram utilizes it so admin can do
	"echo 1 > /sys/block/zram0/compact"

Actually, ideal is that mm migrate code is aware of zram pages and
migrate them out automatically without admin's manual opeartion
when system is out of contiguous page. Howver, we need more thinking
before adding more hooks to migrate.c. Even though we implement it,
we need manual trigger mode, too so I hope we could enhance
zram migration stuff based on this primitive functions in future.

I just tested it on only x86 so need more testing on other arches.
Additionally, I should have a number for zsmalloc regression
caused by indirect layering. Unfortunately, I don't have any
ARM test machine on my desk. I will get it soon and test it.
Anyway, before further work, I'd like to hear opinion.

Pathset is based on v3.18-rc6-mmotm-2014-11-26-15-45.

Thanks.

Minchan Kim (6):
  zsmalloc: expand size class to support sizeof(unsigned long)
  zsmalloc: add indrection layer to decouple handle from object
  zsmalloc: implement reverse mapping
  zsmalloc: encode alloced mark in handle object
  zsmalloc: support compaction
  zram: support compaction

 drivers/block/zram/zram_drv.c |  24 ++
 drivers/block/zram/zram_drv.h |   1 +
 include/linux/zsmalloc.h      |   1 +
 mm/zsmalloc.c                 | 596 +++++++++++++++++++++++++++++++++++++-----
 4 files changed, 552 insertions(+), 70 deletions(-)

-- 
2.0.0

