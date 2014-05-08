Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaEHWpC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:45:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbaEHWpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:45:00 -0400
Date: Thu, 8 May 2014 15:44:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minfei Huang <huangminfei@ucloud.cn>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, davem@davemloft.net,
        dborkman@redhat.com, linux-kernel@vger.kernel.org,
        Joern Engel <joern@logfs.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] btree: Fix the bug to release whole btree nodes
Message-Id: <20140508154459.03aec672ad35ef7ab2dc8e0e@linux-foundation.org>
In-Reply-To: <1399522872-7589-1-git-send-email-huangminfei@ucloud.cn>
References: <1399522872-7589-1-git-send-email-huangminfei@ucloud.cn>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 May 2014 12:21:12 +0800 Minfei Huang <huangminfei@ucloud.cn> wrote:

> I use the btree which pickes up the latest version of kernel source
> 3.14-rc2 in my own module. When the btree module is removed, a warning arised:
> 
> kmem_cache_destroy btree_node: Slab cache still has objects
> CPU: 13 PID: 9150 Comm: rmmod Tainted: GF          O 3.14.0-rc2 #1
> Hardware name: Inspur NF5270M3/NF5270M3, BIOS CHEETAH_2.1.3 09/10/2013
> ffff881ff8643b18 ffff881ffdc23ea8 ffffffff815a4ecc 0000000000000000
> ffff881ff8643ac0 ffff881ffdc23ec8 ffffffff811610df 0000000000000880
> ffffffffa057da60 ffff881ffdc23ed8 ffffffffa057d57c ffff881ffdc23f78
> Call Trace:
> [<ffffffff815a4ecc>] dump_stack+0x49/0x5d
> [<ffffffff811610df>] kmem_cache_destroy+0xcf/0xe0
> [<ffffffffa057d57c>] btree_module_exit+0x10/0x12 [btree]
> [<ffffffff810d7948>] SyS_delete_module+0x198/0x1f0
> [<ffffffff815aac89>] ? retint_swapgs+0xe/0x13
> [<ffffffff810a561d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
> [<ffffffff812addde>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [<ffffffff815b3652>] system_call_fastpath+0x16/0x1b
> 
> The cause is that it doesn't release the last btree node,
> when height = 1 and fill = 1.

Thanks.

> --- a/lib/btree.c
> +++ b/lib/btree.c
> @@ -198,6 +198,8 @@ EXPORT_SYMBOL_GPL(btree_init);
>  
>  void btree_destroy(struct btree_head *head)
>  {
> +	if (head->node)
> +		mempool_free(head->node, head->mempool);
>  	mempool_destroy(head->mempool);
>  	head->mempool = NULL;

We don't really need the test - mempool_free(NULL, ...) is an OK thing
to do.  We conventionally will rely upon this for optimisation reasons,
although not having the test can sometimes make the code less clear.

--- a/lib/btree.c~lib-btreec-fix-leak-of-whole-btree-nodes-fix
+++ a/lib/btree.c
@@ -198,8 +198,7 @@ EXPORT_SYMBOL_GPL(btree_init);
 
 void btree_destroy(struct btree_head *head)
 {
-	if (head->node)
-		mempool_free(head->node, head->mempool);
+	mempool_free(head->node, head->mempool);
 	mempool_destroy(head->mempool);
 	head->mempool = NULL;
 }
_

