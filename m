Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab3ICEpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 00:45:55 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:64856 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3ICEpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 00:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689E4aCwMQwceUntqJiN7vj_m4g+3MYpBJb717VXR6mbpSA@mail.gmail.com>
References: <1377269106-26468-1-git-send-email-zwu.kernel@gmail.com>
	<CANN689ET-2q_7WY+4HZjMqQEmLpOQyWOrOzRnP3ADc8TAzoEXw@mail.gmail.com>
	<CAEH94Li5KuN4V7KVAYJ9YY72HWVS2_gf-_L4zscV1K5fMw58XQ@mail.gmail.com>
	<CANN689E4aCwMQwceUntqJiN7vj_m4g+3MYpBJb717VXR6mbpSA@mail.gmail.com>
Date: Tue, 3 Sep 2013 12:45:53 +0800
Message-ID: <CAEH94LgTa6k7eQzPijeKfaxXMo94a-Wtw11Tnbm_ezpgY12O8w@mail.gmail.com>
Subject: Re: [PATCH] rbtree: Add some necessary condition checks
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 4:57 PM, Michel Lespinasse <walken@google.com> wrote:
> On Sun, Sep 1, 2013 at 11:30 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>> In Tue, Aug 27, 2013 at 6:01 AM, Michel Lespinasse <walken@google.com> wrote:
>>> On Fri, Aug 23, 2013 at 7:45 AM,  <zwu.kernel@gmail.com> wrote:
>>>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>>>
>>>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>>> ---
>>>>  include/linux/rbtree_augmented.h | 3 ++-
>>>>  lib/rbtree.c                     | 5 +++--
>>>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>>
>>> So, you are saying that the checks are necessary, but you are not saying why.
>>>
>>> The way I see it, the checks are *not* necessary, because the rbtree
>>> invariants guarantee them to be true. The only way for the checks to
>>> fail would be if people directly manipulate the rbtrees without going
>>> through the proper APIs, and if they do that then I think they're on
>>> their own. So to me, I think it's the same situation as dereferencing
>>> a pointer without checking if it's NULL, because you know it should
>>> never be NULL - which in my eyes is perfectly acceptable.
>> In my patchset, some rbtree APIs to be invoked, and I think that those
>> rbtree APIs are used corrently, Below is the pointer of its code:
>> https://github.com/wuzhy/kernel/compare/torvalds:master...hot_tracking
>> But I hit some issues when using compilebench to do perf benchmark.
>> compile dir kernel-7 691MB in 8.92 seconds (77.53 MB/s)
>
> Thanks for the link - I now better understand where you are coming
> from with these fixes.
>
> Going back to the original message:
>
>> diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
>> index fea49b5..7d19770 100644
>> --- a/include/linux/rbtree_augmented.h
>> +++ b/include/linux/rbtree_augmented.h
>> @@ -199,7 +199,8 @@ __rb_erase_augmented(struct rb_node *node, struct rb_root *root,
>>                 }
>>
>>                 successor->rb_left = tmp = node->rb_left;
>> -               rb_set_parent(tmp, successor);
>> +               if (tmp)
>> +                       rb_set_parent(tmp, successor);
>>
>>                 pc = node->__rb_parent_color;
>>                 tmp = __rb_parent(pc);
>
> Note that node->rb_left was already fetched at the top of
> __rb_erase_augmented(), and was checked to be non-NULL at the time -
> otherwise we would have executed 'Case 1' in that function. So, you
If 'Case 1' is executed, this line of code is also done, how about the result?
'Case 1' seems *not* to change node->rb_left at all.

> are not expected to find tmp == NULL here.
>
>> diff --git a/lib/rbtree.c b/lib/rbtree.c
>> index c0e31fe..2cb01ba 100644
>> --- a/lib/rbtree.c
>> +++ b/lib/rbtree.c
>> @@ -214,7 +214,7 @@ ____rb_erase_color(struct rb_node *parent, struct rb_root *root,
>>                  */
>>                 sibling = parent->rb_right;
>>                 if (node != sibling) {  /* node == parent->rb_left */
>> -                       if (rb_is_red(sibling)) {
>> +                       if (sibling && rb_is_red(sibling)) {
>>                                 /*
>>                                  * Case 1 - left rotate at parent
>>                                  *
>
> Note the loop invariants quoted just above:
>
>                 /*
>                  * Loop invariants:
>                  * - node is black (or NULL on first iteration)
>                  * - node is not the root (parent is not NULL)
>                  * - All leaf paths going through parent and node have a
>                  *   black node count that is 1 lower than other leaf paths.
>                  */
>
> Because of these, each path from sibling to a leaf must include at
> least one black node, which implies that sibling can't be NULL - or to
> put it another way, if sibling is null then the expected invariants
> were violated before we even got there.
In theory, i can understand what you mean, But don't know why and
where it got violated.
>
>> @@ -226,7 +226,8 @@ ____rb_erase_color(struct rb_node *parent, struct rb_root *root,
>>                                  */
>>                                 parent->rb_right = tmp1 = sibling->rb_left;
>>                                 sibling->rb_left = parent;
>> -                               rb_set_parent_color(tmp1, parent, RB_BLACK);
>> +                               if (tmp1)
>> +                                       rb_set_parent_color(tmp1, parent, RB_BLACK);
>>                                 __rb_rotate_set_parents(parent, sibling, root,
>>                                                         RB_RED);
>>                                 augment_rotate(parent, sibling);
>
> This is actually the same invariant here - each path from sibling to a
> leaf must include at least one black node, and sibling is now known to
> be red, so it must have two black children.
Ditto.
>
>
> Now I had a quick look at your code and I couldn't tell at which point
> the invariants are violated. However I did notice a couple suspicious
> things in the very first patch
> (f5c8f2b256d87ac0bf789a787e6b795ac0c736e8):
>
> 1- In both hot_range_tree_free() and and hot_tree_exit(), you try to
> destroy rb trees by iterating on each node with rb_next() and then
yes, but this item may not been freed immediately, You can know each item
has its ref count.
> freeing them. Note that rb_next() can reference prior nodes, which
> have already been freed in your scheme, so that seems quite unsafe.
I checked rb_next() function, and found that if its prior nodes are
freed, is this node's parent  not NULL? If parent is NULL, 'node ==
parent->rb_right' will not been executed, so i don't think any issue
will happen when rb_next() is called here. right?

while ((parent = rb_parent(node)) && node == parent->rb_right)
        node = parent;

>
> The simplest fix would be to do a full rb_erase() on each node before
full rb_erase()? sorry, i don't get what you mean. Do you mean we
should erase all nodes from rbtree, then begin to free them? If yes,
how to iterate them? If no, can you elaborate it?

> freeing it. (you may be able to avoid rebalancing the tree here as
> you're going to destroy it all, but if you really have that need it
> would be better to come up with a new API to cover it rather than
> hardcode it where you need it - I think it's easiest to start with the
> simple dumb fix of using rb_erase).
>
> 2- I did not look long enough to understand the locking, but it wasn't
> clear to me if you lock the rbtrees when doing rb_erase() on them
> (while I could more clearly see that you do it for insertions).
Yes, it get locking when doing rb_erase() or rb_insert(). You can see
there are multiple functions maybe rbtree at the same time. To sync
them, we need to lock the rbtree.

>
> I'm really not sure if either of these will fix the issues you're
> seeing, though. What I would try next would be to add explicit rbtree
> invariant checks before and after rbtree manipulations, like what the
> check() function does in lib/rbtree_test.c, to see at which point do
> they get broken.
Great, any progress so far? :)

>
> --
> Michel "Walken" Lespinasse
> A program is never fully debugged until the last user dies.



-- 
Regards,

Zhi Yong Wu
