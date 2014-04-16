Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaDPESV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:18:21 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:58338 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaDPESP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:18:15 -0400
Message-ID: <534E0434.2090403@huawei.com>
Date: Wed, 16 Apr 2014 12:16:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Tejun Heo <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <john@johnmccutchan.com>, <rlove@rlove.org>, <eparis@parisplace.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <serge.hallyn@ubuntu.com>, Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
 default hierarchy
References: <1397511846-2904-1-git-send-email-tj@kernel.org> <1397511846-2904-4-git-send-email-tj@kernel.org> <534DEF62.4090900@huawei.com> <CAPXgP12kvPdX0QExwN2JphDfEW=d+7K2c_Y8DbomGd=YVy=VGQ@mail.gmail.com>
In-Reply-To: <CAPXgP12kvPdX0QExwN2JphDfEW=d+7K2c_Y8DbomGd=YVy=VGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/16 11:33, Kay Sievers wrote:
> On Tue, Apr 15, 2014 at 7:48 PM, Li Zefan <lizefan@huawei.com> wrote:
>> On 2014/4/15 5:44, Tejun Heo wrote:
>>> cgroup users often need a way to determine when a cgroup's
>>> subhierarchy becomes empty so that it can be cleaned up.  cgroup
>>> currently provides release_agent for it; unfortunately, this mechanism
>>> is riddled with issues.
>>>
>>> * It delivers events by forking and execing a userland binary
>>>   specified as the release_agent.  This is a long deprecated method of
>>>   notification delivery.  It's extremely heavy, slow and cumbersome to
>>>   integrate with larger infrastructure.
>>>
>>> * There is single monitoring point at the root.  There's no way to
>>>   delegate management of subtree.
>>>
>>> * The event isn't recursive.  It triggers when a cgroup doesn't have
>>>   any tasks or child cgroups.  Events for internal nodes trigger only
>>>   after all children are removed.  This again makes it impossible to
>>>   delegate management of subtree.
>>>
>>> * Events are filtered from the kernel side.  "notify_on_release" file
>>>   is used to subscribe to or suppress release event.  This is
>>>   unnecessarily complicated and probably done this way because event
>>>   delivery itself was expensive.
>>>
>>> This patch implements interface file "cgroup.subtree_populated" which
>>> can be used to monitor whether the cgroup's subhierarchy has tasks in
>>> it or not.  Its value is 0 if there is no task in the cgroup and its
>>> descendants; otherwise, 1, and kernfs_notify() notificaiton is
>>> triggers when the value changes, which can be monitored through poll
>>> and [di]notify.
>>>
>>
>> For the old notification mechanism, the path of the cgroup that becomes
>> empty will be passed to the user specified release agent. Like this:
>>
>> # cat /sbin/cpuset_release_agent
>> #!/bin/sh
>> rmdir /dev/cpuset/$1
>>
>> How do we achieve this using inotify?
>>
>> - monitor all the cgroups, or
>> - monitor all the leaf cgroups, and travel cgrp->parent to delete all
>>   empty cgroups.
>> - monitor root cgroup only, and travel the whole hierarchy to find
>>   empy cgroups when it gets an fs event.
>>
>> Seems none of them is scalible.
> 
> The manager would add all cgroups as watches to one inotify file
> descriptor, it should not be problem to do that.
> 

Never use inotify. Thanks for explanation, so I think inotify can scale
to thounsands of cgroups after I googled a bit.

