Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763038Ab3ECJ73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:59:29 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50324 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762984Ab3ECJ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:59:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130503091149.GA17496@dhcp22.suse.cz>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
	<1356456367-14660-1-git-send-email-handai.szj@taobao.com>
	<20130102104421.GC22160@dhcp22.suse.cz>
	<20130503091149.GA17496@dhcp22.suse.cz>
Date: Fri, 3 May 2013 17:59:24 +0800
Message-ID: <CAFj3OHU1DMVKuzaHGbnBnRGzzvzUC6+t-k2zb3v=BnZP0CiEcg@mail.gmail.com>
Subject: Re: [PATCH V3 4/8] memcg: add per cgroup dirty pages accounting
From: Sha Zhengju <handai.szj@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Glauber Costa <glommer@parallels.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sha Zhengju <handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 5:11 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Wed 02-01-13 11:44:21, Michal Hocko wrote:
>> On Wed 26-12-12 01:26:07, Sha Zhengju wrote:
>> > From: Sha Zhengju <handai.szj@taobao.com>
>> >
>> > This patch adds memcg routines to count dirty pages, which allows memory controller
>> > to maintain an accurate view of the amount of its dirty memory and can provide some
>> > info for users while cgroup's direct reclaim is working.
>>
>> I guess you meant targeted resp. (hard/soft) limit reclaim here,
>> right? It is true that this is direct reclaim but it is not clear to me
>> why the usefulnes should be limitted to the reclaim for users. I would
>> understand this if the users was in fact in-kernel users.
>>
>> [...]
>> > To prevent AB/BA deadlock mentioned by Greg Thelen in previous version
>> > (https://lkml.org/lkml/2012/7/30/227), we adjust the lock order:
>> > ->private_lock --> mapping->tree_lock --> memcg->move_lock.
>> > So we need to make mapping->tree_lock ahead of TestSetPageDirty in __set_page_dirty()
>> > and __set_page_dirty_nobuffers(). But in order to avoiding useless spinlock contention,
>> > a prepare PageDirty() checking is added.
>>
>> But there is another AA deadlock here I believe.
>> page_remove_rmap
>>   mem_cgroup_begin_update_page_stat           <<< 1
>>   set_page_dirty
>>     __set_page_dirty_buffers
>>       __set_page_dirty
>>         mem_cgroup_begin_update_page_stat     <<< 2
>>         move_lock_mem_cgroup
>>           spin_lock_irqsave(&memcg->move_lock, *flags);
>
> JFYI since abf09bed (s390/mm: implement software dirty bits) this is no
> longer possible. I haven't checked wheter there are other cases like
> this one and it should be better if mem_cgroup_begin_update_page_stat
> was recursive safe if that can be done without too many hacks.
> I will have a look at this (hopefully) sometimes next week.
>

Hi Michal,


I'm sorry for not being able to return to this problem immediately after LSF/MM.
That is good news. IIRC, it's the only place we have encountered
recursive problem in accounting memcg dirty pages. But I'll try to
revive my previous work of simplifying
mem_cgroup_begin_update_page_stat() lock.
I'll back to it in next few days.


--
Thanks,
Sha
