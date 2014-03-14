Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaCNNag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:30:36 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60408 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaCNNad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:30:33 -0400
Message-ID: <53230475.5050805@gopivotal.com>
Date: Fri, 14 Mar 2014 13:30:29 +0000
From: Glyn Normington <gnormington@gopivotal.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Steve Powell <spowell@gopivotal.com>
Subject: Re: [PATCH] control groups: documentation improvements
References: <20140310113928.GC18700@gnimac.gopivotal.com> <20140310140724.GA25290@htj.dyndns.org> <531DC971.6020208@gopivotal.com> <20140310142014.GC25290@htj.dyndns.org> <5321D6FA.4040500@gopivotal.com> <53225C69.3010202@huawei.com>
In-Reply-To: <53225C69.3010202@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li

Thanks! Inline...

Tejun: Li agrees with our reasoning on the "views" issue, but we'd like 
your feedback too in preparation for a new patch.

Regards,
Glyn & Steve
On 14/03/2014 01:33, Li Zefan wrote:
> On 2014/3/14 0:04, Glyn Normington wrote:
>> Hi Tejun
>>
>> Stepping back from the patch for a while, we'd like to explore the issues you raise. Please bear with us as we try to capture the ideas precisely.
>>
>> Continued inline...
>>
>> Regards,
>> Glyn (& Steve Powell, copied)
>>
>> On 10/03/2014 14:20, Tejun Heo wrote:
>>> Hey,
>>>
>>> On Mon, Mar 10, 2014 at 02:17:21PM +0000, Glyn Normington wrote:
>>>> Then we missed how to create a hierarchy with no associated
>>>> subsystems. The only way I can think of is to use mount, specify no
>>>> subsystems on -o (which defaults to all the subsystems defined in
>>>> the kernel), and run it in a kernel with no subsystems defined
>>>> (which seems unlikely these days).
>>>>
>>>> Is that what you had in mind or is there some other way of creating
>>>> a hierarchy with no subsystems attached?
>>> Hierarchy name should be specified "-o name=" for hierarchies w/o any
>>> controllers.
>> According to cgroups.txt:
>>
>>   When passing a name=<x> option for a new hierarchy, you need to
>>   specify subsystems manually; the legacy behaviour of mounting all
>>   subsystems when none are explicitly specified is not supported when
>>   you give a subsystem a name.
>>
>> So the documentation certainly does not make it clear that it is valid to specify no subsystems.
>>
>> We tried this (on a 3.11 kernel) and can't get it to work:
>>
>> # mount -t cgroup -o name=th none /home/glyn/h1
> # mount -t cgroup -o name=th,none none /home/glyn/h1
Great! We'll make sure to document this when we submit the next version 
of the patch.
>
> and then
>
> # mount -t cgroup -o name=th none /home/glyn/h2
>
>> mount: wrong fs type, bad option, bad superblock on none,
>>      missing codepage or helper program, or other error
>>      (for several filesystems (e.g. nfs, cifs) you might
>>      need a /sbin/mount.<type> helper program) In some
>>      cases useful info is found in syslog - try dmesg |
>>      tail or so
>>
>> Please could you supply an example which works?
>>
>>>>>> Clarify that subsystems may be attached to multiple hierarchies,
>>>>>> although this isn't very useful, and explain what happens.
>>>>> And a subsystem may only be attached to a single hierarchy.
>>>> Perhaps that's what should happen, but the following experiment
>>>> demonstrates a subsystem being attached to two hierarchies:
>>>>
>>>> $ pwd
>>>> /home/vagrant
>>>> $ mkdir mem1
>>>> $ mkdir mem2
>>>> $ sudo su
>>>> # mount -t cgroup -o memory none /home/vagrant/mem1
>>>> # mount -t cgroup -o memory none /home/vagrant/mem2
>>>> # cd mem1
>>>> # mkdir inst1
>>>> # ls inst1
>>>> cgroup.clone_children  memory.failcnt ...
>>>> # ls ../mem2
>>>> cgroup.clone_children  inst1 memory.limit_in_bytes ...
>>>> # cd inst1
>>>> # echo 1000000 > memory.limit_in_bytes
>>>> # cat memory.limit_in_bytes
>>>> 1003520
>>>> # cat ../../mem2/inst1/memory.limit_in_bytes
>>>> 1003520
>>>> # echo $$ > tasks
>>>> # cat tasks
>>>> 1365
>>>> 1409
>>>> # cat ../../mem2/inst1/tasks
>>>> 1365
>>>> 1411
>>> You're mounting the same hierarchy twice.  Those are two views into
>>> the same hierarchy.
>>>
>>> Thanks.
>>>
>> Yes, it does appear that this is what is going on, but to explain it this way turns out to be more complicated than one might expect. Here's an attempt...
>>
> Yeah, this can only confuse people.
>
> I don't think we need extra explanation, because we all know the same
> filesystem can have more than one mount point, and cgroupfs is no
> different.
Thanks.
>
>> ---
>>   A*hierarchy*  is a non-empty set of cgroups arranged in a tree and a
>>   non-empty set of subsystems such that the cgroups in the hierarchy
>>   partition all the tasks in the system (in other words, every task in the
>>   system is in exactly one of the cgroups in the hierarchy) and each
>>   subsystem attaches its own state to each cgroup in the hierarchy.
>>
>>   There may be zero or more active hierarchies. Each hierarchy has one
>>   or more views associated with it. A *view* is an instance of the cgroup
>>   virtual filesystem. The tree of cgroups of a hierarchy is represented
>>   by the directory tree in the cgroup virtual filesystem of each view of
>>   the hierarchy. All the directory trees in the cgroup virtual filesystem
>>   of the views of a given hierarchy have identical content.
>>
>>   No subsystem may participate in more than one hierarchy.
>> ---
>>
>> We'd also need to explain the behaviour of mount and umount with respect to views. The first time a cgroup mount is performed with a given set of subsystems, a hierarchy is created and a view of the hierarchy is created and associated with a cgroup filesystem at the mount point. Subsequently, if another cgroup mount is performed with the same set of subsystems, no new hierarchy is created but a new view of the existing hierarchy is created and associated with the cgroup filesystem at the new mount point.
>>
>> Unmounting a cgroup mount point destroys a particular view and destroys the hierarchy associated with the view if and only if the view is the only (remaining) view of the hierarchy.
>>
>> So does introducing the concept of a view really help? The wording in the patch does without the concept by allowing two "hierarchies" to have identical content (so they are indistinguishable).
>>
>> "views" don't seem to have any practical benefit. If we can avoid explaining concepts which have no use, we probably should. ;-)
>>
>>
>> .
>>

