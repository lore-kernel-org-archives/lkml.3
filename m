Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3HUC6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:58:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46600 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3HUC6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:58:37 -0400
X-Spam-Score: -101.0
Message-ID: <521424FA.5000203@asianux.com>
Date: Wed, 21 Aug 2013 10:24:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        riel@redhat.com, hughd@google.com, xemul@parallels.com,
        rientjes@google.com, Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] mm/shmem.c: check the return value of mpol_to_str()
References: <5212E8DF.5020209@asianux.com> <20130820053036.GB18673@moon> <52130194.4030903@asianux.com> <20130820064730.GD18673@moon> <52131F48.1030002@asianux.com> <52132011.60501@asianux.com> <52132432.3050308@asianux.com> <20130820082516.GE18673@moon> <52142422.9050209@asianux.com> <52142464.8060903@asianux.com> <521424BE.8020309@asianux.com>
In-Reply-To: <521424BE.8020309@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpol_to_str() may fail, and not fill the buffer (e.g. -EINVAL), so need
check about it, or buffer may not be zero based, and next seq_printf()
will cause issue.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
 mm/shmem.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e59d332..ae5112f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -886,11 +886,14 @@ redirty:
 static int shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
 {
 	char buffer[64];
+	int ret;
 
 	if (!mpol || mpol->mode == MPOL_DEFAULT)
 		return 0;		/* show nothing */
 
-	mpol_to_str(buffer, sizeof(buffer), mpol);
+	ret = mpol_to_str(buffer, sizeof(buffer), mpol);
+	if (ret < 0)
+		return ret;
 
 	seq_printf(seq, ",mpol=%s", buffer);
 	return 0;
-- 
1.7.7.6
