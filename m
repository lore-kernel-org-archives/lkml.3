Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3HUCbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:31:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13862 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3HUCbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:31:05 -0400
X-Spam-Score: -101.0
Message-ID: <52142464.8060903@asianux.com>
Date: Wed, 21 Aug 2013 10:22:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        riel@redhat.com, hughd@google.com, xemul@parallels.com,
        rientjes@google.com, Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] fs/proc/task_mmu.c: check the return value of mpol_to_str()
References: <5212E8DF.5020209@asianux.com> <20130820053036.GB18673@moon> <52130194.4030903@asianux.com> <20130820064730.GD18673@moon> <52131F48.1030002@asianux.com> <52132011.60501@asianux.com> <52132432.3050308@asianux.com> <20130820082516.GE18673@moon> <52142422.9050209@asianux.com>
In-Reply-To: <52142422.9050209@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpol_to_str() may fail, and not fill the buffer (e.g. -EINVAL), so need
check about it, or buffer may not be zero based, and next seq_printf()
will cause issue.

The failure return need after mpol_cond_put() to match get_vma_policy().


Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
 fs/proc/task_mmu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 107d026..d87f5da 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1376,8 +1376,10 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	walk.mm = mm;
 
 	pol = get_vma_policy(task, vma, vma->vm_start);
-	mpol_to_str(buffer, sizeof(buffer), pol);
+	n = mpol_to_str(buffer, sizeof(buffer), pol);
 	mpol_cond_put(pol);
+	if (n < 0)
+		return n;
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
-- 
1.7.7.6
