Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaJJTNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:13:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbaJJTNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:13:41 -0400
Message-ID: <1412968420.15099.4.camel@redhat.com>
Subject: Re: [PATCH 3/7] audit: eliminate string copy for new tree rules
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Date: Fri, 10 Oct 2014 15:13:40 -0400
In-Reply-To: <b1a402e95af08b5a437b987f41639094a18a64e3.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
	 <b1a402e95af08b5a437b987f41639094a18a64e3.1412285491.git.rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 22:05 -0400, Richard Guy Briggs wrote:
> New tree rules copy the path twice and discard the intermediary copy.
> 
> This saves one pointer at the expense of one path string copy.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit_tree.c  |    9 +++++----
>  kernel/auditfilter.c |    5 +++--
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index bd418c4..ace72ed 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -17,7 +17,7 @@ struct audit_tree {
>  	struct list_head list;
>  	struct list_head same_root;
>  	struct rcu_head head;
> -	char pathname[];
> +	char *pathname;
>  };
>  
>  struct audit_chunk {
> @@ -70,11 +70,11 @@ static LIST_HEAD(prune_list);
>  
>  static struct fsnotify_group *audit_tree_group;
>  
> -static struct audit_tree *alloc_tree(const char *s)
> +static struct audit_tree *alloc_tree(char *s)
>  {
>  	struct audit_tree *tree;
>  
> -	tree = kmalloc(sizeof(struct audit_tree) + strlen(s) + 1, GFP_KERNEL);
> +	tree = kmalloc(sizeof(struct audit_tree), GFP_KERNEL);
>  	if (tree) {
>  		atomic_set(&tree->count, 1);
>  		tree->goner = 0;
> @@ -83,7 +83,7 @@ static struct audit_tree *alloc_tree(const char *s)
>  		INIT_LIST_HEAD(&tree->list);
>  		INIT_LIST_HEAD(&tree->same_root);
>  		tree->root = NULL;
> -		strcpy(tree->pathname, s);
> +		tree->pathname = s;
>  	}
>  	return tree;
>  }
> @@ -96,6 +96,7 @@ static inline void get_tree(struct audit_tree *tree)
>  static inline void put_tree(struct audit_tree *tree)
>  {
>  	if (atomic_dec_and_test(&tree->count))
> +		kfree(tree->pathname);
>  		kfree_rcu(tree, head);
>  }

Why does the tree need to be freed after an RCU grace period but the
pathname can be freed immediately?  What's the locking/access that makes
this safe?

>  
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index e3378a4..facd704 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -534,9 +534,10 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
>  			entry->rule.buflen += f->val;
>  
>  			err = audit_make_tree(&entry->rule, str, f->op);
> -			kfree(str);
> -			if (err)
> +			if (err) {
> +				kfree(str);
>  				goto exit_free;
> +			}
>  			break;
>  		case AUDIT_INODE:
>  			err = audit_to_inode(&entry->rule, f);


