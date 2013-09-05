Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762778Ab3IEBZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 21:25:42 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:55127 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3IEBZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 21:25:41 -0400
MIME-Version: 1.0
In-Reply-To: <1378343540.2064.23.camel@buesod1.americas.hpqcorp.net>
References: <1377269106-26468-1-git-send-email-zwu.kernel@gmail.com>
	<CANN689ET-2q_7WY+4HZjMqQEmLpOQyWOrOzRnP3ADc8TAzoEXw@mail.gmail.com>
	<CAEH94Li5KuN4V7KVAYJ9YY72HWVS2_gf-_L4zscV1K5fMw58XQ@mail.gmail.com>
	<CANN689E4aCwMQwceUntqJiN7vj_m4g+3MYpBJb717VXR6mbpSA@mail.gmail.com>
	<CAEH94Ljp2ebCF6yhbh=MynTJCLbLh8D5cRV9pPO-Gzx1c7YU5A@mail.gmail.com>
	<1378339153.2064.6.camel@buesod1.americas.hpqcorp.net>
	<CAEH94LgRXWkkqrnKE+xpgNBkVDFTZ5gV5PbPUzMtkoaZnAUneA@mail.gmail.com>
	<1378343540.2064.23.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 5 Sep 2013 09:25:40 +0800
Message-ID: <CAEH94Li2LibE7rCNOK0jX483p2A9paNoxVG8NYGDnkofVHeaeQ@mail.gmail.com>
Subject: Re: [PATCH] rbtree: Add some necessary condition checks
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Michel Lespinasse <walken@google.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 9:12 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Thu, 2013-09-05 at 08:37 +0800, Zhi Yong Wu wrote:
>> On Thu, Sep 5, 2013 at 7:59 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> > On Thu, 2013-09-05 at 01:22 +0800, Zhi Yong Wu wrote:
>> >> On Mon, Sep 2, 2013 at 4:57 PM, Michel Lespinasse <walken@google.com> wrote:
>> >> > On Sun, Sep 1, 2013 at 11:30 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>> >> >> In Tue, Aug 27, 2013 at 6:01 AM, Michel Lespinasse <walken@google.com> wrote:
>> >> >>> On Fri, Aug 23, 2013 at 7:45 AM,  <zwu.kernel@gmail.com> wrote:
>> >> >>>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >> >>>>
>> >> >>>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >> >>>> ---
>> >> >>>>  include/linux/rbtree_augmented.h | 3 ++-
>> >> >>>>  lib/rbtree.c                     | 5 +++--
>> >> >>>>  2 files changed, 5 insertions(+), 3 deletions(-)
>> >> >>>
>> >> >>> So, you are saying that the checks are necessary, but you are not saying why.
>> >> >>>
>> >> >>> The way I see it, the checks are *not* necessary, because the rbtree
>> >> >>> invariants guarantee them to be true. The only way for the checks to
>> >> >>> fail would be if people directly manipulate the rbtrees without going
>> >> >>> through the proper APIs, and if they do that then I think they're on
>> >> >>> their own. So to me, I think it's the same situation as dereferencing
>> >> >>> a pointer without checking if it's NULL, because you know it should
>> >> >>> never be NULL - which in my eyes is perfectly acceptable.
>> >> >> In my patchset, some rbtree APIs to be invoked, and I think that those
>> >> >> rbtree APIs are used corrently, Below is the pointer of its code:
>> >> >> https://github.com/wuzhy/kernel/compare/torvalds:master...hot_tracking
>> >> >> But I hit some issues when using compilebench to do perf benchmark.
>> >> >> compile dir kernel-7 691MB in 8.92 seconds (77.53 MB/s)
>> >> >
>> >> > Thanks for the link - I now better understand where you are coming
>> >> > from with these fixes.
>> >> >
>> >> > Going back to the original message:
>> >> >
>> >> >> diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
>> >> >> index fea49b5..7d19770 100644
>> >> >> --- a/include/linux/rbtree_augmented.h
>> >> >> +++ b/include/linux/rbtree_augmented.h
>> >> >> @@ -199,7 +199,8 @@ __rb_erase_augmented(struct rb_node *node, struct rb_root *root,
>> >> >>                 }
>> >> >>
>> >> >>                 successor->rb_left = tmp = node->rb_left;
>> >> >> -               rb_set_parent(tmp, successor);
>> >> >> +               if (tmp)
>> >> >> +                       rb_set_parent(tmp, successor);
>> >> >>
>> >> >>                 pc = node->__rb_parent_color;
>> >> >>                 tmp = __rb_parent(pc);
>> >> >
>> >> > Note that node->rb_left was already fetched at the top of
>> >> > __rb_erase_augmented(), and was checked to be non-NULL at the time -
>> >> > otherwise we would have executed 'Case 1' in that function. So, you
>> >> > are not expected to find tmp == NULL here.
>> >> >
>> >> >> diff --git a/lib/rbtree.c b/lib/rbtree.c
>> >> >> index c0e31fe..2cb01ba 100644
>> >> >> --- a/lib/rbtree.c
>> >> >> +++ b/lib/rbtree.c
>> >> >> @@ -214,7 +214,7 @@ ____rb_erase_color(struct rb_node *parent, struct rb_root *root,
>> >> >>                  */
>> >> >>                 sibling = parent->rb_right;
>> >> >>                 if (node != sibling) {  /* node == parent->rb_left */
>> >> >> -                       if (rb_is_red(sibling)) {
>> >> >> +                       if (sibling && rb_is_red(sibling)) {
>> >> >>                                 /*
>> >> >>                                  * Case 1 - left rotate at parent
>> >> >>                                  *
>> >> >
>> >> > Note the loop invariants quoted just above:
>> >> >
>> >> >                 /*
>> >> >                  * Loop invariants:
>> >> >                  * - node is black (or NULL on first iteration)
>> >> >                  * - node is not the root (parent is not NULL)
>> >> >                  * - All leaf paths going through parent and node have a
>> >> >                  *   black node count that is 1 lower than other leaf paths.
>> >> >                  */
>> >> >
>> >> > Because of these, each path from sibling to a leaf must include at
>> >> > least one black node, which implies that sibling can't be NULL - or to
>> >> > put it another way, if sibling is null then the expected invariants
>> >> > were violated before we even got there.
>> >> >
>> >> >> @@ -226,7 +226,8 @@ ____rb_erase_color(struct rb_node *parent, struct rb_root *root,
>> >> >>                                  */
>> >> >>                                 parent->rb_right = tmp1 = sibling->rb_left;
>> >> >>                                 sibling->rb_left = parent;
>> >> >> -                               rb_set_parent_color(tmp1, parent, RB_BLACK);
>> >> >> +                               if (tmp1)
>> >> >> +                                       rb_set_parent_color(tmp1, parent, RB_BLACK);
>> >> >>                                 __rb_rotate_set_parents(parent, sibling, root,
>> >> >>                                                         RB_RED);
>> >> >>                                 augment_rotate(parent, sibling);
>> >> >
>> >> > This is actually the same invariant here - each path from sibling to a
>> >> > leaf must include at least one black node, and sibling is now known to
>> >> > be red, so it must have two black children.
>> >> If sibling is red, it can be made sure to have two non-null black
>> >> children?
>> >
>> > This is guaranteed by cases 1 and 2 in __rb_insert().
>> ah, but this code is very tricky.
>>
>
> While it's not trivial, it is a lot more readable than a whole bunch of
> red-black tree implementations out there - not to mention optimized.
>
> AFAICT by the thread, you have yet to provide a case where, by properly
> using the rbtree API, the tree implementation does not comply.
>
>> >
>> >> but my patchset sometimes trigger red sibling to have no
>> >> non-null black children. Do you know what reason usually cause this?
>> >> You know rbtree code is very tricky.
>> >
>> > I haven't looked at your code, but a good way of verifying the tree
>> > integrity is running rbtree_test.
>> rbtree_test seem to be not available for my patchset.
>
> Why not? Is this an older kernel you're dealing with?
It was built with latest kernel upstream. As i said below, it will
cause this perf testing to be running very very slowly.
>
>> my perf testing
>> is super large scale, and it will try to create 1,0000,000 rb_nodes,
>> while rbtree_test try to verify the rbtree when every rb_node is
>> reserted or erased. This will cause my perf testing to be running very
>> very slowly.
>>
>
> May I ask what you are attempting to do here? Are you trying to stress
My patchset is using the rbtree to record I/O frequency for each inode
and its range in VFS layer. Its rbtree may be very, very big if you
create a lot of files.
> the kernel's rbtree implementation?
No. I am trying to stress the rbtree which is created by my patchset.
Below is my patchset, and i don't find it is calling the rbtree APIs
uncorrectly. right?
https://github.com/wuzhy/kernel/compare/torvalds:master...hot_tracking
>
> Well, performance isn't a concern when doing this kind of testing. Yes,
> the tree integrity verification (check() calls) is done when inserting
> and deleting every node, which is the whole purpose of such tests. I
> admit that the rbtree_test module is a bit limited as to user options -
> ie: making the amount of nodes be a parameter is on my todo list. That
> said, the check() function does properly test the rbtree properties, and
> so far it complies.
>
> Thanks,
> Davidlohr
>



-- 
Regards,

Zhi Yong Wu
