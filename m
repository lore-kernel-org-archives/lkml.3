Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaDPDuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:50:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46699 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaDPDus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:50:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kay Sievers <kay@vrfy.org>
Cc: Li Zefan <lizefan@huawei.com>, rlove@rlove.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        LKML <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>, eparis@parisplace.org,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        john@johnmccutchan.com
References: <1397511846-2904-1-git-send-email-tj@kernel.org>
	<1397511846-2904-4-git-send-email-tj@kernel.org>
	<534DEF62.4090900@huawei.com>
	<CAPXgP12kvPdX0QExwN2JphDfEW=d+7K2c_Y8DbomGd=YVy=VGQ@mail.gmail.com>
Date: Tue, 15 Apr 2014 20:50:20 -0700
In-Reply-To: <CAPXgP12kvPdX0QExwN2JphDfEW=d+7K2c_Y8DbomGd=YVy=VGQ@mail.gmail.com>
	(Kay Sievers's message of "Tue, 15 Apr 2014 20:33:26 -0700")
Message-ID: <87tx9uhr0j.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/MdaOe8TSN7w7fLKyTsuypSs9o8dxuhTQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4885]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Kay Sievers <kay@vrfy.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the default hierarchy
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay@vrfy.org> writes:

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

inotify won't work on cgroupfs.

Eric
