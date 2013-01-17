Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3AQFrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:47:04 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:41160 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3AQFrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:47:01 -0500
Message-ID: <50F79047.1080907@linux.vnet.ibm.com>
Date: Thu, 17 Jan 2013 13:46:47 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH v2 0/3] sched: simplify the select_task_rq_fair()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011705-9264-0000-0000-00000302CBD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 change log:
	Fix code style issues.
	Fix BUG of NULL affine_sd.
	Add the support for NUMA domain.
	Other small fix according to the old logical.
	Provide more test data with finer granularity.

This patch set is trying to simplify the select_task_rq_fair() with
schedule balance map.

After get rid of the complex code and reorganize the logical, pgbench show
the improvement, more the clients, bigger the improvement.

				Prev:		Post:

	| db_size | clients |	| tps  |	|  tps  | 
	+---------+---------+   +------+        +-------+
	| 22 MB   |       1 |   |10794 |        | 10862 |
	| 22 MB   |       2 |   |21567 |        | 21711 |
	| 22 MB   |       4 |   |41621 |        | 42609 |
	| 22 MB   |       8 |   |53883 |        | 58184 |	+7.98%
	| 22 MB   |      12 |   |50818 |        | 53464 |	+5.21%
	| 22 MB   |      16 |   |50463 |        | 55034 |	+9.06%
	| 22 MB   |      24 |   |46698 |        | 53702 |	+15.00%
	| 22 MB   |      32 |   |43404 |        | 54030 |	+24.48%
	| 7484 MB |       1 |   | 7974 |        |  8431 |
	| 7484 MB |       2 |   |19341 |        | 19509 |
	| 7484 MB |       4 |   |36808 |        | 38038 |
	| 7484 MB |       8 |   |47821 |        | 50377 |	+5.34%
	| 7484 MB |      12 |   |45913 |        | 49128 |	+7.00%
	| 7484 MB |      16 |   |46478 |        | 49670 |	+6.87%
	| 7484 MB |      24 |   |42793 |        | 48461 |	+13.25%
	| 7484 MB |      32 |   |36329 |        | 48436 |	+33.33%
	| 15 GB   |       1 |   | 7636 |        |  7852 |
	| 15 GB   |       2 |   |19195 |        | 19369 |
	| 15 GB   |       4 |   |35975 |        | 37323 |
	| 15 GB   |       8 |   |47919 |        | 50246 |	+4.86%
	| 15 GB   |      12 |   |45397 |        | 48608 |	+7.07%
	| 15 GB   |      16 |   |45926 |        | 49192 |	+7.11%
	| 15 GB   |      24 |   |42184 |        | 48007 |	+13.80%
	| 15 GB   |      32 |   |35983 |        | 47955 |	+33.27%

Please check the patch for more details about schedule balance map.

Support the NUMA domain but not tested.
Support the rebuild of domain but not tested.

Comments are very welcomed.

BTW:
	Compared with 3.7.0-rc6, 3.8.0-rc3 show big improvement with few
	clients, but get some damage with many clients, whatever, this patch
	set will help both of them to gain better performance.

Test with:
	12 cpu X86 server and linux-next 3.8.0-rc3.

Michael Wang (3):
	[RFC PATCH v2 1/3] sched: schedule balance map foundation
	[RFC PATCH v2 2/3] sched: build schedule balance map
	[RFC PATCH v2 3/3] sched: simplify select_task_rq_fair() with schedule balance map

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 b/kernel/sched/core.c  |   44 ++++++++++++++++
 b/kernel/sched/fair.c  |  131 +++++++++++++++++++++++++------------------------
 b/kernel/sched/sched.h |   14 +++++
 kernel/sched/core.c    |   70 ++++++++++++++++++++++++++
 4 files changed, 197 insertions(+), 62 deletions(-)

