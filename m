Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab3ICG6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:58:11 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:45753 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3ICG6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:58:10 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689GKX4Wyo48+3L6-auTCEE3HKwj0-pCZDZs8bM=xCKPOcA@mail.gmail.com>
References: <1377269106-26468-1-git-send-email-zwu.kernel@gmail.com>
	<CANN689ET-2q_7WY+4HZjMqQEmLpOQyWOrOzRnP3ADc8TAzoEXw@mail.gmail.com>
	<CAEH94Li5KuN4V7KVAYJ9YY72HWVS2_gf-_L4zscV1K5fMw58XQ@mail.gmail.com>
	<CANN689E4aCwMQwceUntqJiN7vj_m4g+3MYpBJb717VXR6mbpSA@mail.gmail.com>
	<CAEH94LgTa6k7eQzPijeKfaxXMo94a-Wtw11Tnbm_ezpgY12O8w@mail.gmail.com>
	<CANN689GKX4Wyo48+3L6-auTCEE3HKwj0-pCZDZs8bM=xCKPOcA@mail.gmail.com>
Date: Tue, 3 Sep 2013 14:58:09 +0800
Message-ID: <CAEH94LiaAMCO9zXWx5AEqh_bwJiaVY829ka4hTdJ9iDaibVkNg@mail.gmail.com>
Subject: Re: [PATCH] rbtree: Add some necessary condition checks
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 1:48 PM, Michel Lespinasse <walken@google.com> wrote:
> On Mon, Sep 2, 2013 at 9:45 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>> On Mon, Sep 2, 2013 at 4:57 PM, Michel Lespinasse <walken@google.com> wrote:
>>> Thanks for the link - I now better understand where you are coming
>>> from with these fixes.
>>>
>>> Going back to the original message:
>>>
>>>> diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
>>>> index fea49b5..7d19770 100644
>>>> --- a/include/linux/rbtree_augmented.h
>>>> +++ b/include/linux/rbtree_augmented.h
>>>> @@ -199,7 +199,8 @@ __rb_erase_augmented(struct rb_node *node, struct rb_root *root,
>>>>                 }
>>>>
>>>>                 successor->rb_left = tmp = node->rb_left;
>>>> -               rb_set_parent(tmp, successor);
>>>> +               if (tmp)
>>>> +                       rb_set_parent(tmp, successor);
>>>>
>>>>                 pc = node->__rb_parent_color;
>>>>                 tmp = __rb_parent(pc);
>>>
>>> Note that node->rb_left was already fetched at the top of
>>> __rb_erase_augmented(), and was checked to be non-NULL at the time -
>>> otherwise we would have executed 'Case 1' in that function. So, you
>> If 'Case 1' is executed, this line of code is also done, how about the result?
>> 'Case 1' seems *not* to change node->rb_left at all.
>
> Wait, I believe this line of code is executed only in Case 2 and Case 3 ?
>
>>>> diff --git a/lib/rbtree.c b/lib/rbtree.c
>>>> index c0e31fe..2cb01ba 100644
>>>> --- a/lib/rbtree.c
>>>> +++ b/lib/rbtree.c
>>>> @@ -214,7 +214,7 @@ ____rb_erase_color(struct rb_node *parent, struct rb_root *root,
>>>>                  */
>>>>                 sibling = parent->rb_right;
>>>>                 if (node != sibling) {  /* node == parent->rb_left */
>>>> -                       if (rb_is_red(sibling)) {
>>>> +                       if (sibling && rb_is_red(sibling)) {
>>>>                                 /*
>>>>                                  * Case 1 - left rotate at parent
>>>>                                  *
>>>
>>> Note the loop invariants quoted just above:
>>>
>>>                 /*
>>>                  * Loop invariants:
>>>                  * - node is black (or NULL on first iteration)
>>>                  * - node is not the root (parent is not NULL)
>>>                  * - All leaf paths going through parent and node have a
>>>                  *   black node count that is 1 lower than other leaf paths.
>>>                  */
>>>
>>> Because of these, each path from sibling to a leaf must include at
>>> least one black node, which implies that sibling can't be NULL - or to
>>> put it another way, if sibling is null then the expected invariants
>>> were violated before we even got there.
>> In theory, i can understand what you mean, But don't know why and
>> where it got violated.
>
> Same here. My point is, I don't think we can fix the issue without
> answering that question.
>
>>> Now I had a quick look at your code and I couldn't tell at which point
>>> the invariants are violated. However I did notice a couple suspicious
>>> things in the very first patch
>>> (f5c8f2b256d87ac0bf789a787e6b795ac0c736e8):
>>>
>>> 1- In both hot_range_tree_free() and and hot_tree_exit(), you try to
>>> destroy rb trees by iterating on each node with rb_next() and then
>> yes, but this item may not been freed immediately, You can know each item
>> has its ref count.
>
> Are items guaranteed to have another refcount than the one we're dropping ?
>
>>> freeing them. Note that rb_next() can reference prior nodes, which
>>> have already been freed in your scheme, so that seems quite unsafe.
>> I checked rb_next() function, and found that if its prior nodes are
>> freed, is this node's parent  not NULL?
>
> No, if the parent was freed with just a put() operation, the child
> will still have a pointer to it. This is why I suggested using
> rb_erase() on each node before freeing them, so that we don't keep
> pointers to freed nodes.
>
>>> The simplest fix would be to do a full rb_erase() on each node before
>> full rb_erase()? sorry, i don't get what you mean. Do you mean we
>> should erase all nodes from rbtree, then begin to free them? If yes,
>> how to iterate them? If no, can you elaborate it?
>
> No, I meant to call rb_erase() on each individual node right before
> the corresponding put() operation.
It has been done in current code.
>
>>> 2- I did not look long enough to understand the locking, but it wasn't
>>> clear to me if you lock the rbtrees when doing rb_erase() on them
>>> (while I could more clearly see that you do it for insertions).
>> Yes, it get locking when doing rb_erase() or rb_insert(). You can see
>> there are multiple functions maybe rbtree at the same time. To sync
>> them, we need to lock the rbtree.
>
> Yes, agree we need to lock rbtree in all such operations. I just
> wasn't able to determine if it's done around rb_erase() calls, but it
Yes, the locking has been done around rb_erase().
> definitely needs to be.
>
>>> I'm really not sure if either of these will fix the issues you're
>>> seeing, though. What I would try next would be to add explicit rbtree
>>> invariant checks before and after rbtree manipulations, like what the
>>> check() function does in lib/rbtree_test.c, to see at which point do
>>> they get broken.
>> Great, any progress so far? :)
>
> Unfortunately no.
Look forward to seeing it.
>
> --
> Michel "Walken" Lespinasse
> A program is never fully debugged until the last user dies.



-- 
Regards,

Zhi Yong Wu
