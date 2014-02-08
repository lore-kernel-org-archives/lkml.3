Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaBHC1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 21:27:07 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:44775 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaBHC1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 21:27:03 -0500
Message-ID: <52F595F1.8020301@huawei.com>
Date: Sat, 8 Feb 2014 10:26:57 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Glyn Normington <gnormington@gopivotal.com>
CC: <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: Attaching a cgroup subsystem to multiple hierarchies
References: <050BD595-BE55-401D-9B61-E877FB9F06A8@gopivotal.com> <20140206185923.GA2781@dhcp22.suse.cz> <1C806CEE-B69E-4F47-A33F-BC8CE4865223@gopivotal.com>
In-Reply-To: <1C806CEE-B69E-4F47-A33F-BC8CE4865223@gopivotal.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Add Michal back to the Cc list, and Cc cgroup mailing list)

On 2014/2/7 17:21, Glyn Normington wrote:
> Hi Michal
> 
> On 6 Feb 2014, at 18:59, Michal Hocko <mhocko@suse.cz> wrote:
> 
>> On Wed 05-02-14 14:39:52, Glyn Normington wrote:
>>> Reading cgroups.txt and casting around the net leads me to believe
>>> that it is possible to attach a cgroup subsystem (e.g. memory) to
>>> multiple hierarchies, but this seems to result in “mirrored”
>>> hierarchies which are automatically kept in step with each other -
>>> essentially it looks like the same hierarchy at multiple file system
>>> paths.
>>>
>>> Take the following interaction for example:
>>>
>>> \begin{verbatim}
>>> $ pwd   
>>> /home/vagrant
>>> $ mkdir mem1
>>> $ mkdir mem2
>>> $ sudo su
>>> # mount -t cgroup -o memory none /home/vagrant/mem1
>>> # mount -t cgroup -o memory none /home/vagrant/mem2
>>> # cd mem1
>>> # mkdir inst1  
>>> # ls inst1 
>>> cgroup.clone_children  memory.failcnt ...
>>> # ls ../mem2
>>> cgroup.clone_children  inst1 memory.limit_in_bytes ...
>>> # cd inst1
>>> # echo 1000000 > memory.limit_in_bytes 
>>> # cat memory.limit_in_bytes 
>>> 1003520
>>> # cat ../../mem2/inst1/memory.limit_in_bytes 
>>> 1003520
>>> # echo $$ > tasks
>>> # cat tasks
>>> 1365
>>> 1409
>>> # cat ../../mem2/inst1/tasks
>>> 1365
>>> 1411
>>>
>>> Is this working as intended?
>>
>> Yes, it doesn't make any sense to have two different views on the same
>> controllers.
> 
> Then wouldn’t it be better for the second mount to fail?
> 

We don't disallow mounting procfs/sysfs to more than one mount point.
Why we want to do this to cgroupfs?

>>
>>> Is there some other way to attach a subsystem to *distinct*
>>> hierarchies?
>>
>> No.
>>
>>> Distinct hierarchies would allow distinct cgroups, distinct settings
>>> (e.g. memory.limit_in_bytes) and distinct partitions of the tasks in
>>> the system.
>>
>> Which one should be applied then?
> 
> Good question. All of them, I would say: the constraints due to distinct settings would be ANDed together.
> 
> The implementation would be more complex and less efficient as a subsystem's resources consumed by a process would need charging against each hierarchy to which the subsystem was attached.
> 
> I very much doubt this would be worth implementing and I’m not at all suggesting it.
> 

Don't even think about it. :)

>>
>>>
>>> Note: I don’t have a good use for this function - I’m simply
>>> trying to reverse engineer the semantics of cgroups to get a precise
>>> understanding.
>>
>> I think there is no need to reverse engineer ;)
>> Documentation/cgroups/cgroups.txt in the kernel tree does give a decent
>> description IMO.
> 
> I disagree. For example, cgroups.txt does not clearly state whether or not a single subsystem may be attached to distinct hierarchies.
> 
> This seems to have caused confusion elsewhere. For example, Red Hat write “… a single subsystem can be attached to two hierarchies if both of those hierarchies have only that subsystem attached.” ([1]).
> 

No documentation is perfect, but you can make it better by sending us
a patch.

