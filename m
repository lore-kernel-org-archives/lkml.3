Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab3HFVD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:03:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3HFVD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:03:28 -0400
Date: Tue, 6 Aug 2013 14:03:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH] mm/mempolicy: return NULL if node is NUMA_NO_NODE in
 get_task_policy
Message-Id: <20130806140326.1d0d75874e6be221a432c3bc@linux-foundation.org>
In-Reply-To: <52007660.7070907@huawei.com>
References: <52007660.7070907@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Aug 2013 12:06:56 +0800 Jianguo Wu <wujianguo@huawei.com> wrote:

> If node == NUMA_NO_NODE, pol is NULL, we should return NULL instead of
> do "if (!pol->mode)" check.
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> ---
>  mm/mempolicy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4baf12e..e0e3398 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -129,6 +129,8 @@ static struct mempolicy *get_task_policy(struct task_struct *p)
>  		node = numa_node_id();
>  		if (node != NUMA_NO_NODE)
>  			pol = &preferred_node_policy[node];
> +		else
> +			return NULL;
>  
>  		/* preferred_node_policy is not initialised early in boot */
>  		if (!pol->mode)

Well yes, it'll dereference a null pointer

This is neater, I think:

--- a/mm/mempolicy.c~mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy
+++ a/mm/mempolicy.c
@@ -123,16 +123,19 @@ static struct mempolicy preferred_node_p
 static struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
-	int node;
 
 	if (!pol) {
-		node = numa_node_id();
-		if (node != NUMA_NO_NODE)
-			pol = &preferred_node_policy[node];
+		int node = numa_node_id();
 
-		/* preferred_node_policy is not initialised early in boot */
-		if (!pol->mode)
-			pol = NULL;
+		if (node != NUMA_NO_NODE) {
+			pol = &preferred_node_policy[node];
+			/*
+			 * preferred_node_policy is not initialised early in
+			 * boot
+			 */
+			if (!pol->mode)
+				pol = NULL;
+		}
 	}
 
 	return pol;
_

