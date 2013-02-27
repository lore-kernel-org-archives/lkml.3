Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3B0H6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 02:58:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:18192 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab3B0H6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 02:58:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,746,1355068800"; 
   d="scan'208";a="6778733"
Message-ID: <512DBD24.7090302@cn.fujitsu.com>
Date: Wed, 27 Feb 2013 16:00:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jarkko.sakkinen@intel.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com>	<512B8407.2090807@canonical.com>	<512BD753.4080001@hp.com>	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>	<CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>	<512D58C2.1090403@jp.fujitsu.com>	<CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com>	<512D7FAD.1040003@jp.fujitsu.com>	<CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com>	<512D8EDA.3010602@jp.fujitsu.com> <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com>
In-Reply-To: <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 15:57:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 15:57:48,
	Serialize complete at 2013/02/27 15:57:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 01:11 PM, Yinghai Lu wrote:
> On Tue, Feb 26, 2013 at 8:43 PM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> 2013/02/27 13:04, Yinghai Lu wrote:
>>>
>>> On Tue, Feb 26, 2013 at 7:38 PM, Yasuaki Ishimatsu
>>> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>>>>
>>>> 2013/02/27 11:30, Yinghai Lu wrote:
>>>>>
>>>>> Do you mean you can not boot one socket system with 1G ram ?
>>>>> Assume socket 0 does not support hotplug, other 31 sockets support hot
>>>>> plug.
>>>>>
>>>>> So we could boot system only with socket0, and later one by one hot
>>>>> add other cpus.
>>>>
>>>>
>>>>
>>>> In this case, system can boot. But other cpus with bunch of ram hot
>>>> plug may fails, since system does not have enough memory for cover
>>>> hot added memory. When hot adding memory device, kernel object for the
>>>> memory is allocated from 1G ram since hot added memory has not been
>>>> enabled.
>>>>
>>>
>>> yes, it may fail, if the one node memory need page table and vmemmap
>>> is more than 1g ...
>>>
>>
>>> for hot add memory we need to
>>> 1. add another wrapper for init_memory_mapping, just like
>>> init_mem_mapping() for booting path.
>>> 2. we need make memblock more generic, so we can use it with hot add
>>> memory during runtime.
>>> 3. with that we can initialize page table for hot added node with ram.
>>> a. initial page table for 2M near node top is from node0 ( that does
>>> not support hot plug).
>>> b. then will use 2M for memory below node top...
>>> c. with that we will make sure page table stay on local node.
>>>   alloc_low_pages need to be updated to support that.
>>> 4. need to make sure vmemmap on local node too.
>>
>>
>> I think so too. By this, memory hot plug becomes more useful.
>>
>>>
>>> so hot-remove node will work too later.
>>>
>>> In the long run, we should make booting path and hot adding more
>>> similar and share at most code.
>>> That will make code get more test coverage.
> 
> Tang,  Yasuaki, Andrew,
> 
> Please check if you are ok with attached reverting patch.
> 
> Tim, Don,
> Can you try if attached reverting patch fix all the problems for you ?
> 


Hi, Yinghai, Andrew

In the mails and the changlog of the revert-patch, I think Yinghai
mainly worries about 3 problems.

1) the current implement has bug and bad code.

	Yes. Any bug should be fixed. we should fix it directly, or
	we can revert the related patches and then send the fixed patches.

	But the related patch is only one or two, it is not good idea
	to revert the whole patchset or the whole feature. Right?

	Thank you all for addressing the bug. we are on the way to fix it.

2) many memory can be put into hotplugable memory, but we have not yet moved them
   into hotplugable memory yet. like: vmemmap, some page table ...etc, a lot.

	This is a restriction in the currently kernel, we can't convert them quickly.
	we must convert them step by step. example, we are converting the memory of
	page_cgroup to hotplugable memory.


3) if the user(or firmware) specify the un-hotplugable memory too small, the system can't
   work, even can't boot.

	Any feature/system has its own minimum requirements, the user should
	meet the requirements and specify more un-hotplugable memory.
	so I don't think it is a problem in kernel land.

	But the problem 2)(above) make this feature's "minimum requirements"
	much higher. It is the real thing that Yinghai worries about.

	But all systems which use this feature can offer this higher requirement
	very easily. The users should specify enough un-hotplugable memory
	before and after we decrease the "minimum requirements".

	The whole feature works very well if the user specify enough
	un-hotplugable memory. So the problem 2) and 3) are not urgent
	problems.

And our team has another problem, we are still not good at community work,
(example, the patch TITLE is total misleading), but we are growing up.
We are sorry and thank you for pointing out the mistakes.

The feature/patchset does have problems. But it is not good to tangle
all the problems together and revert the whole feature.

Thanks,
Lai
