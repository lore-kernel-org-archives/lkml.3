Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaDGF4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:56:31 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:43361 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaDGF42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVgEtDqbK6-JoMn8-1D_cOsRTGPozvbmxbCBKi1+ss-rQ@mail.gmail.com>
References: <1592838.91HrDxMk9i@comer>
	<CAM_iQpVgEtDqbK6-JoMn8-1D_cOsRTGPozvbmxbCBKi1+ss-rQ@mail.gmail.com>
Date: Sun, 6 Apr 2014 22:56:27 -0700
Message-ID: <CAM_iQpU+A+1FxFNkibvbkM=vkWVw7QmHJzE_AODVTgzUEjdeDg@mail.gmail.com>
Subject: Re: 3.14 tc oops
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Kelly Anderson <kelly@xilka.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 9:24 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Apr 2, 2014 at 7:24 AM, Kelly Anderson <kelly@xilka.com> wrote:
>> Hi,
>>
>> I hit a kernel oops when starting traffic control on my armv7 router, I don't
>> think the architecture is related, the same tc code worked perfectly with
>> earlier kernel versions, i.e. 3.13.x.
>>
>> I also attached an object dump with line numbers to make identifying the
>> problem a bit easier.
>>
>> Please cc me to keep me in the loop, I can test patches.
>
>
> Thanks for the report! Looks like it is caused by one of my patches,
> I will look into this shortly.
>

Which tc filter are you using on that htb qdisc? (tc filter show dev ....)

I suspect it's tcindex filter, if so please try the following patch:

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index eed8404..14618cc 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -298,8 +298,10 @@ tcindex_set_parms(struct net *net, struct
tcf_proto *tp, unsigned long base,
        tcf_exts_change(tp, &cr.exts, &e);

        tcf_tree_lock(tp);
-       if (old_r && old_r != r)
+       if (old_r && old_r != r) {
                memset(old_r, 0, sizeof(*old_r));
+               tcf_exts_init(&old_r->exts, TCA_TCINDEX_ACT,
TCA_TCINDEX_POLICE);
+       }

        memcpy(p, &cp, sizeof(cp));
        memcpy(r, &cr, sizeof(cr));
