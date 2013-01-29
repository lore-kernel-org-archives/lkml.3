Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3A2JIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:08:34 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54233 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3A2JIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:08:20 -0500
Message-ID: <51079178.3070002@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 17:08:08 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012909-5140-0000-0000-000002AFB536
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3 change log:
	Fix small logical issues (Thanks to Mike Galbraith).
	Change the way of handling WAKE.

This patch set is trying to simplify the select_task_rq_fair() with
schedule balance map.

After get rid of the complex code and reorganize the logical, pgbench show
the improvement, more the clients, bigger the improvement.

				Prev:		Post:

	| db_size | clients |	|  tps  |	|  tps  |
        +---------+---------+   +-------+       +-------+
        | 22 MB   |       1 |   | 10788 |       | 10881 |
        | 22 MB   |       2 |   | 21617 |       | 21837 |
        | 22 MB   |       4 |   | 41597 |       | 42645 |
        | 22 MB   |       8 |   | 54622 |       | 57808 |
        | 22 MB   |      12 |   | 50753 |       | 54527 |
        | 22 MB   |      16 |   | 50433 |       | 56368 |	+11.77%
        | 22 MB   |      24 |   | 46725 |       | 54319 |	+16.25%
        | 22 MB   |      32 |   | 43498 |       | 54650 |	+25.64%
        | 7484 MB |       1 |   |  7894 |       |  8301 |
        | 7484 MB |       2 |   | 19477 |       | 19622 |
        | 7484 MB |       4 |   | 36458 |       | 38242 |
        | 7484 MB |       8 |   | 48423 |       | 50796 |
        | 7484 MB |      12 |   | 46042 |       | 49938 |
        | 7484 MB |      16 |   | 46274 |       | 50507 |	+9.15%
        | 7484 MB |      24 |   | 42583 |       | 49175 |	+15.48%
        | 7484 MB |      32 |   | 36413 |       | 49148 |	+34.97%
        | 15 GB   |       1 |   |  7742 |       |  7876 |
        | 15 GB   |       2 |   | 19339 |       | 19531 |
        | 15 GB   |       4 |   | 36072 |       | 37389 |
        | 15 GB   |       8 |   | 48549 |       | 50570 |
        | 15 GB   |      12 |   | 45716 |       | 49542 |
        | 15 GB   |      16 |   | 46127 |       | 49647 |	+7.63%
        | 15 GB   |      24 |   | 42539 |       | 48639 |	+14.34%
        | 15 GB   |      32 |   | 36038 |       | 48560 |	+34.75%

Please check the patch for more details about schedule balance map.

Support the NUMA domain but not well tested.
Support the rebuild of domain but not tested.

Comments are very welcomed.

Behind the v3:
	Some changes has been applied to the way of handling WAKE.

	And that's all around one question, whether we should do load balance
	for WAKE or not?

	In the old world, the only chance to do load balance for WAKE is when
	prev cpu and curr cpu are not cache affine, but that doesn't make sense.

	I suppose the real meaning behind that logical is, do balance only if
	cache benefit nothing after changing cpu.

	However, select_idle_sibling() is not only designed for the purpose to
	take care of cache, it also benefit latency, and cost less than the
	balance path.

	Besides, it's impossible to estimate the benefit of doing load balance
	at that point of time.

	And that's come out the v3, no load balance for WAKE.

Test with:
	12 cpu X86 server and linux-next 3.8.0-rc3.

Michael Wang (3):
	[RFC PATCH v3 1/3] sched: schedule balance map foundation
	[RFC PATCH v3 2/3] sched: build schedule balance map
	[RFC PATCH v3 3/3] sched: simplify select_task_rq_fair() with schedule balance map

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 b/kernel/sched/core.c  |   44 +++++++++++++++
 b/kernel/sched/fair.c  |  135 ++++++++++++++++++++++++++-----------------------
 b/kernel/sched/sched.h |   14 +++++
 kernel/sched/core.c    |   67 ++++++++++++++++++++++++
 4 files changed, 199 insertions(+), 61 deletions(-)

