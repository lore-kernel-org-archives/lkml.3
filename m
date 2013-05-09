Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3EIMyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:54:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63142 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3EIMx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:53:58 -0400
X-Spam-Score: -100.8
Message-ID: <518B9C32.7050408@asianux.com>
Date: Thu, 09 May 2013 20:53:06 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kernel: audit_tree: resource management: need put_tree
 and goto Err when failure occures
References: <517110BA.5070806@asianux.com> <20130422160409.471f6208099a972d26c29fb9@linux-foundation.org>
In-Reply-To: <20130422160409.471f6208099a972d26c29fb9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2013年04月20日 15:31, Chen Gang wrote:
> On 2013年04月18日 09:19, Chen Gang F T wrote:
>> > On 2013年04月18日 04:07, Andrew Morton wrote:
>>>> >> > On Wed, 17 Apr 2013 12:04:02 +0800 Chen Gang <gang.chen@asianux.com> wrote:
>>>> >> > 
>>>>>>>> >>>> >> >   since "normally audit_add_tree_rule() will free it on failure",
>>>>>>>> >>>> >> >   need free it completely, when failure occures.
>>>>>>>> >>>> >> > 
>>>>>>>> >>>> >> >     need additional put_tree before return, since get_tree was called.
>>>>>>>> >>>> >> >     always need goto error processing area for list_del_init.
>>>> >> > Isn't that get_tree() in audit_add_tree_rule() simply unneeded?  In
>>>> >> > other words, is this patch correct:
>>>> >> > 
> 

Hell all:

get_tree() in audit_add_tree_rule() is needed (my original conclusion is incorrect).

  the reason is when failed, trim_marked() will call put_tree() to free the tree and the related entry.
    trim_marked() ->
      ...
      tree->goner = 1
      ...
      kill_rules()
      ...
      prune_one() ->
        put_tree()
      ...
  after trim_marked() returns, should not call put_tree() again.
  but after trim_marked() returns, it has to 'goto Err' to call additional put_tree().
  so it has to call additional get_tree() firstly.

And get_tree() need not be in audit_filter_mutex lock protected: it is only for self task to call trim_marked().

All get_tree() and put_tree() in audit_add_tree_rule() are matched with each other.


But we need let 'rule->tree = NULL;' firstly, so can protect rule itself freed in kill_rules().

  the reason is when it is killed, the 'rule' itself may have already released, we should not access it.
  one example: we add a rule to an inode, just at the same time the other task is deleting this inode.

  the work flow for add a rule:

    audit_receive() -> (need audit_cmd_mutex lock)
      audit_receive_skb() ->
        audit_receive_msg() ->
          audit_receive_filter() ->
            audit_add_rule() ->
              audit_add_tree_rule() -> (need audit_filter_mutex lock)
                ...
                unlock audit_filter_mutex
                get_tree()
                ...
                iterate_mounts() -> (iterate all related inodes)
                  tag_mount() ->
                    tag_trunk() ->
                      create_trunk() -> (assume it is 1st rule)
                        fsnotify_add_mark() -> 
                          fsnotify_add_inode_mark() ->  (add mark to inode->i_fsnotify_marks)
                        ...
                        get_tree(); (each inode will get one)
                ...
                lock audit_filter_mutex

  the work flow for delete inode:

    __destroy_inode() ->
     fsnotify_inode_delete() ->
       __fsnotify_inode_delete() ->
        fsnotify_clear_marks_by_inode() ->  (get mark from inode->i_fsnotify_marks)
          fsnotify_destroy_mark() ->
           fsnotify_destroy_mark_locked() ->
             audit_tree_freeing_mark() ->
               evict_chunk() ->
                 ...
                 tree->goner = 1
                 ...
                 kill_rules() ->   (assume current->audit_context == NULL)
                   call_rcu() ->   (rule->tree != NULL)
                     audit_free_rule_rcu() ->
                       audit_free_rule()
                 ...
                 audit_schedule_prune() ->  (assume current->audit_context == NULL)
                   kthread_run() ->    (need audit_cmd_mutex and audit_filter_mutex lock)
                     prune_one() ->    (delete it from prue_list)
                       put_tree(); (match the original get_tree above)


 
-----------------------------diff begin---------------------------------

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 9fd17f0..85eb26c 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -659,6 +659,7 @@ int audit_add_tree_rule(struct audit_krule *rule)
 	struct vfsmount *mnt;
 	int err;
 
+	rule->tree = NULL;
 	list_for_each_entry(tree, &tree_list, list) {
 		if (!strcmp(seed->pathname, tree->pathname)) {
 			put_tree(seed);

-----------------------------diff end-----------------------------------


For me, after 'rule->tree = NULL', all things seems fine !!

Please help check.

Thanks.


> after reading code again, I think:
> 
>   we can remove the pair of get_tree() and put_tree(),
> 
>     a. the author want to pretect tree not to be freed after unlock audit_filter_mutex
>          when tree is really freed by others, we have chance to check tree->goner
> 
>     b. it just like another functions done (audit_tag_tree, audit_trim_trees)
>          for audit_add_tree_rule, also need let get_tree() protected by audit_filter_mutex.
>            (move 'get_tree' before unlock audit_filter_mutex)
> 
>     c. but after read code (at least for audit_add_tree_rule)
>        during unlock audit_filter_mutex in audit_add_tree_rule:
>          I find only one posible related work flow which may happen (maybe it can not happen either).
>            fsnotify_destroy_mark_locked ->
>              audit_tree_freeing_mark ->
>                evict_chunk ->
>                  kill_rules ->
>                    call_rcu -> 
>                      audit_free_rule_rcu ->
>                        audit_free_rule
>          it will free rules and entry, but it does not call put_tree().
> 
>     so I think, at least for audit_add_tree_rule, we can remove the pair of get_tree() and put_tree()
>       (maybe also need give a check for audit_tag_tree and audit_trim_trees, whether can remove 'get_tree' too)
> 
> 
>   and the process is incorrect after lock audit_filter_mutex again (line 701..705)
> 
>     a. if rule->rlist was really empty
>         the 'rule' itself would already be freed.
>         the caller and the caller of caller, need notice this (not double free)
>         instead, we need check tree->gonar (and also need spin_lock protected).
> 
>     b. we do not need set "rule->tree = tree" again.
>          i. if 'rule' is not touched by any other thread
>               it should be rule->tree == tree.
> 
>         ii. else if rule->tree == NULL (freed by other thread)
>               'rule' itself might be freed too, we'd better return by failure.
> 
>        iii. else (!rule->tree && rule->tree != tree) (reused by other thread)
>               firstly, it should not happen.
>               if could happen, 'rule->tree = tree' would cause original rule->tree memory leak.
> 
> 
>   my conclusion is only by reading code (and still I am not quite expert about it, either)
>   so welcome experts (especially maintainers) to providing suggestions or completions.
> 
>   thanks.
> 
> 
>   if no reply within a week (2013-04-28), I should send related patch.
> 
> gchen.
> 
> 653 /* called with audit_filter_mutex */
> 654 int audit_add_tree_rule(struct audit_krule *rule)
> 655 {
> 656         struct audit_tree *seed = rule->tree, *tree;
> 657         struct path path;
> 658         struct vfsmount *mnt;
> 659         int err;
> 660 
> 661         list_for_each_entry(tree, &tree_list, list) {
> 662                 if (!strcmp(seed->pathname, tree->pathname)) {
> 663                         put_tree(seed);
> 664                         rule->tree = tree;
> 665                         list_add(&rule->rlist, &tree->rules);
> 666                         return 0;
> 667                 }
> 668         }
> 669         tree = seed;
> 670         list_add(&tree->list, &tree_list);
> 671         list_add(&rule->rlist, &tree->rules);
> 672         /* do not set rule->tree yet */
> 673         mutex_unlock(&audit_filter_mutex);
> 674 
> 675         err = kern_path(tree->pathname, 0, &path);
> 676         if (err)
> 677                 goto Err;
> 678         mnt = collect_mounts(&path);
> 679         path_put(&path);
> 680         if (IS_ERR(mnt)) {
> 681                 err = PTR_ERR(mnt);
> 682                 goto Err;
> 683         }
> 684 
> 685         get_tree(tree);
> 686         err = iterate_mounts(tag_mount, tree, mnt);
> 687         drop_collected_mounts(mnt);
> 688 
> 689         if (!err) {
> 690                 struct node *node;
> 691                 spin_lock(&hash_lock);
> 692                 list_for_each_entry(node, &tree->chunks, list)
> 693                         node->index &= ~(1U<<31);
> 694                 spin_unlock(&hash_lock);
> 695         } else {
> 696                 trim_marked(tree);
> 697                 goto Err;
> 698         }
> 699 
> 700         mutex_lock(&audit_filter_mutex);
> 701         if (list_empty(&rule->rlist)) {
> 702                 put_tree(tree);
> 703                 return -ENOENT;
> 704         }
> 705         rule->tree = tree;
> 706         put_tree(tree);
> 707 
> 708         return 0;
> 709 Err:
> 710         mutex_lock(&audit_filter_mutex);
> 711         list_del_init(&tree->list);
> 712         list_del_init(&tree->rules);
> 713         put_tree(tree);
> 714         return err;
> 715 }
> 
> 
> 
> 
>> >   excuse me:
>> >     I am not quite familiar with it, and also have to do another things.
>> >     so I have to spend additional time resource to make sure about it.
>> > 
>> >   is it ok ?
>> >     I should make sure about it within this week (2013-04-21)
>> >     I should finish related test (if need), within next week (2013-4-28)
>> > 
>> >   if have additional suggestions or completions, please reply.
>> >     (if no reply, I will follow the time point above)
>> > 
>> >   thanks.
>> > 
>> > gchen.
>> > 
>> > 
> 
> -- Chen Gang Asianux Corporation
> 


-- 
Chen Gang

Asianux Corporation


