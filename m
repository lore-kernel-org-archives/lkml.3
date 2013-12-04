Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3LDL5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:57:14 -0500
Received: from relay.parallels.com ([195.214.232.42]:46552 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab3LDL5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:57:11 -0500
Message-ID: <529F1883.3030907@parallels.com>
Date: Wed, 4 Dec 2013 15:56:51 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Glauber Costa <glommer@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: remove KMEM_ACCOUNTED_ACTIVATED
References: <1385989693-28788-1-git-send-email-vdavydov@parallels.com> <20131202181501.GA5524@dhcp22.suse.cz> <CAA6-i6rWsZNQmFY5L-=yc6TaTGyg4hP4qn9gMZVsu8wWJ=1ywg@mail.gmail.com> <529CDDB3.3090301@parallels.com> <CAA6-i6q+WooWMSbJwLS=ByVu=fgAQuep99iP7tAXiuLABu2gVA@mail.gmail.com> <529D9100.4070207@parallels.com> <CAA6-i6q2viRkbjYOHcoiCHgvdfbfo-4j0k9gj9AA4SH1YToqVg@mail.gmail.com> <529EDB41.8030505@parallels.com> <CAA6-i6o+ZuM_fq+PdQJZ40S0d7K35cBvbTELg49+SgLKP5F0xA@mail.gmail.com>
In-Reply-To: <CAA6-i6o+ZuM_fq+PdQJZ40S0d7K35cBvbTELg49+SgLKP5F0xA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 02:08 PM, Glauber Costa wrote:
>>> Could you do something clever with just one flag? Probably yes. But I
>>> doubt it would
>>> be that much cleaner, this is just the way that patching sites work.
>> Thank you for spending your time to listen to me.
>>
> Don't worry! I thank you for carrying this forward.
>
>> Let me try to explain what is bothering me.
>>
>> We have two state bits for each memcg, 'active' and 'activated'. There
>> are two scenarios where the bits can be modified:
>>
>> 1) The kmem limit is set on a memcg for the first time -
>> memcg_update_kmem_limit(). Here we call memcg_update_cache_sizes(),
>> which sets the 'activated' bit on success, then update static branching,
>> then set the 'active' bit. All three actions are done atomically in
>> respect to other tasks setting the limit due to the set_limit_mutex.
>> After both bits are set, they never get cleared for the memcg.
>>
> So far so good. But again, note how you yourself describe it:
> the cations are done atomically  *in respect to other tasks setting the limit*
>
> But there are also tasks that are running its courses naturally and
> just allocating
> memory. For those, some call sites will be on, some will be off. We need to make
> sure that *none* of them uses the patched site until *all* of them are patched.
> This has nothing to do with updates, this is all about the readers.
>
>> 2) When a subgroup of a kmem-active cgroup is created -
>> memcg_propagate_kmem(). Here we copy kmem_account_flags from the parent,
>> then increase static branching refcounter, then call
>> memcg_update_cache_sizes() for the new memcg, which may clear the
>> 'activated' bit on failure. After successful execution, the state bits
>> never get cleared for the new memcg.
>>
>> In scenario 2 there is no need bothering about the flags setting order,
>> because we don't have any tasks in the cgroup yet - the tasks can be
>> moved in only after css_online finishes when we have both of the bits
>> set and the static branching enabled. Actually, we already do not bother
>> about it, because we have both bits set before the cgroup is fully
>> initialized (memcg_update_cache_sizes() is called).
>>
> Yes, after the first cgroup is set none of that matters. But it is just easier
> and less error prone just to follow the same path every time. As I have said,
> if you can come up with a more clever way to deal with the problem above
> that doesn't involve the double flag - and you can prove it works - I
> am definitely
> fine with it. But this is subtle code, and in the past - Michal can
> attest this - we've
> changed this being sure it would work just to see it explode in our faces.
>
> So although I am willing to review every patch for correctness on that
> front (I never
> said I liked the 2-flags scheme...), unless you have a bug or real
> problem on it,
> I would advise against changing it if its just to make it more readable.
>
> But again, don't take me too seriously on this. If you and Michal think you can
> come up with something better, I'm all for it.

All right, I finally get you :-)

Although I still don't think we need the second flag, I now understand
that it's better not to change the code that works fine especially the
change does not make it neither more readable nor more effective. Since
I can be mistaken about the flags usage (it's by far not unlikely), it's
better to leave it as is rather than being at risk of catching spurious
hangs that might be caused by this modification.

Thanks for the detailed explanation!
