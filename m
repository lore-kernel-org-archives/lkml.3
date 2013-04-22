Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3DVXEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:04:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3DVXEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:04:10 -0400
Date: Mon, 22 Apr 2013 16:04:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/audit_tree.c: tree will memory leak when failure
 occurs for audit_trim_trees()
Message-Id: <20130422160409.471f6208099a972d26c29fb9@linux-foundation.org>
In-Reply-To: <517110BA.5070806@asianux.com>
References: <517110BA.5070806@asianux.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Apr 2013 17:39:06 +0800 Chen Gang <gang.chen@asianux.com> wrote:

> 
> in audit_trim_trees(), has called get_tree() before failure occurs,
> so need also call put_tree after go to skip_it:
> 
> ...
>
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -617,10 +617,10 @@ void audit_trim_trees(void)
>  		}
>  		spin_unlock(&hash_lock);
>  		trim_marked(tree);
> -		put_tree(tree);
>  		drop_collected_mounts(root_mnt);
>  skip_it:
>  		mutex_lock(&audit_filter_mutex);
> +		put_tree(tree);
>  	}
>  	list_del(&cursor);
>  	mutex_unlock(&audit_filter_mutex);

That looks right to me.

I think we can micro-optimise the code by performing the put_tree()
before taking the mutex, to slightly reduce mutex hold times?

--- a/kernel/audit_tree.c~kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix
+++ a/kernel/audit_tree.c
@@ -619,8 +619,8 @@ void audit_trim_trees(void)
 		trim_marked(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
-		mutex_lock(&audit_filter_mutex);
 		put_tree(tree);
+		mutex_lock(&audit_filter_mutex);
 	}
 	list_del(&cursor);
 	mutex_unlock(&audit_filter_mutex);
_


