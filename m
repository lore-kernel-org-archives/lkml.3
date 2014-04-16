Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaDPEWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:22:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39724 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaDPEWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:22:18 -0400
Message-ID: <534E04F1.4070104@huawei.com>
Date: Wed, 16 Apr 2014 12:20:01 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Kay Sievers <kay@vrfy.org>, <rlove@rlove.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <containers@lists.linux-foundation.org>, <serge.hallyn@ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lennart Poettering" <lennart@poettering.net>, <eparis@parisplace.org>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        <john@johnmccutchan.com>
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
 default hierarchy
References: <1397511846-2904-1-git-send-email-tj@kernel.org> <1397511846-2904-4-git-send-email-tj@kernel.org> <534DEF62.4090900@huawei.com> <CAPXgP12kvPdX0QExwN2JphDfEW=d+7K2c_Y8DbomGd=YVy=VGQ@mail.gmail.com> <87tx9uhr0j.fsf@x220.int.ebiederm.org>
In-Reply-To: <87tx9uhr0j.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/16 11:50, Eric W. Biederman wrote:
> Kay Sievers <kay@vrfy.org> writes:
> 
>> On Tue, Apr 15, 2014 at 7:48 PM, Li Zefan <lizefan@huawei.com> wrote:
>>> On 2014/4/15 5:44, Tejun Heo wrote:
>>>> cgroup users often need a way to determine when a cgroup's
>>>> subhierarchy becomes empty so that it can be cleaned up.  cgroup
>>>> currently provides release_agent for it; unfortunately, this mechanism
>>>> is riddled with issues.
>>>>
>>>> * It delivers events by forking and execing a userland binary
>>>>   specified as the release_agent.  This is a long deprecated method of
>>>>   notification delivery.  It's extremely heavy, slow and cumbersome to
>>>>   integrate with larger infrastructure.
>>>>
>>>> * There is single monitoring point at the root.  There's no way to
>>>>   delegate management of subtree.
>>>>
>>>> * The event isn't recursive.  It triggers when a cgroup doesn't have
>>>>   any tasks or child cgroups.  Events for internal nodes trigger only
>>>>   after all children are removed.  This again makes it impossible to
>>>>   delegate management of subtree.
>>>>
>>>> * Events are filtered from the kernel side.  "notify_on_release" file
>>>>   is used to subscribe to or suppress release event.  This is
>>>>   unnecessarily complicated and probably done this way because event
>>>>   delivery itself was expensive.
>>>>
>>>> This patch implements interface file "cgroup.subtree_populated" which
>>>> can be used to monitor whether the cgroup's subhierarchy has tasks in
>>>> it or not.  Its value is 0 if there is no task in the cgroup and its
>>>> descendants; otherwise, 1, and kernfs_notify() notificaiton is
>>>> triggers when the value changes, which can be monitored through poll
>>>> and [di]notify.
>>>>
>>>
>>> For the old notification mechanism, the path of the cgroup that becomes
>>> empty will be passed to the user specified release agent. Like this:
>>>
>>> # cat /sbin/cpuset_release_agent
>>> #!/bin/sh
>>> rmdir /dev/cpuset/$1
>>>
>>> How do we achieve this using inotify?
>>>
>>> - monitor all the cgroups, or
>>> - monitor all the leaf cgroups, and travel cgrp->parent to delete all
>>>   empty cgroups.
>>> - monitor root cgroup only, and travel the whole hierarchy to find
>>>   empy cgroups when it gets an fs event.
>>>
>>> Seems none of them is scalible.
>>
>> The manager would add all cgroups as watches to one inotify file
>> descriptor, it should not be problem to do that.
> 
> inotify won't work on cgroupfs.
> 

Tejun's working on inotify support for cgroupfs, and I believe this patchset
has been tested, so it works.

So what do you mean by saying it won't work? Could you be more specific?

