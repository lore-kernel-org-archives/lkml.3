Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaF3JGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:06:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:36363 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbaF3JGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:06:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="358303132"
Message-ID: <53B12872.50609@linux.intel.com>
Date: Mon, 30 Jun 2014 17:05:54 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liu hua <sdu.liu@huawei.com>, "Luck, Tony" <tony.luck@intel.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        Liu ShuoX <shuox.liu@intel.com>, Rocher@linux.intel.com,
        Jeremy <jeremy.rocher@intel.com>, zhangzhiqiang.zhang@huawei.com
Subject: Re: Should Pstore(ramoops) records customized information?
References: <539E6D4D.5000802@huawei.com> <53A164DB.1020305@huawei.com> <3908561D78D1C84285E8C5FCA982C28F32838E10@ORSMSX114.amr.corp.intel.com> <53A2D5BB.5040500@huawei.com> <3908561D78D1C84285E8C5FCA982C28F3283A5E3@ORSMSX114.amr.corp.intel.com> <53A41125.4080802@huawei.com> <53AA1A9F.8030108@linux.intel.com> <53AAC9D8.4010204@huawei.com> <53AB6FFF.4000506@linux.intel.com> <53AD5E4D.1030700@huawei.com>
In-Reply-To: <53AD5E4D.1030700@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/27 20:06, Liu hua wrote:
> 于 2014/6/26 8:57, Zhang, Yanmin 写道:
>> On 2014/6/25 21:08, Liu hua wrote:
>>> 于 2014/6/25 8:41, Zhang, Yanmin 写道:
>>>> On 2014/6/20 18:47, Liu hua wrote:
>>>>> On 2014/6/20 7:42, Luck, Tony wrote:
>>>>>
>>>>>>> BTW, I note that "extern struct pstore_info *psinfo" locates in
>>>>>>> fs/pstore/internal.h. So users out of directory "fs/pstore/" can not use pstore to
>>>>>>> record messages. We do not want other kernel users to use pstore, right?  And can we
>>>>>>> break this?
>>>>>> Yes we can make some interface visible to the rest of the kernel ... probably
>>>>>> not the raw "*psinfo" though. Perhaps the pstore_alloc_ring_buffer() and
>>>>>> pstore_write_ring_buffer() functions should be the ones exported to the
>>>>>> rest of the kernel.
>>>>>>
>>>>>>> ditoo.. Since other backends like efi and erst may can not privide such ring buffer.
>>>>>>> So pstore_alloc_ring_buffer should be a funciton pointer of pstore_info struct.
>>>>>> Yes - that allows less capable backend like ERST and efivars to not provide the
>>>>>> service.  Since it becomes internal, you can drop the "pstore_" prefix.  E.g.
>>>>>> something like:
>>>>>>
>>>>>> int pstore_alloc_ring_buffer(char *name, int size)
>>>>>> {
>>>>>>       return psinfo->alloc_ring_buffer(name, size);
>>>>>> }
>>>>>> EXPORT_SYMBOL_GPL(pstore_alloc_ring_buffer);
>>>>>>
>>>>>> ... and you have to find/make some global header for the "extern" declaration.
>>>>> I will make these RFC patch series according to our discussion. Thanks you very to
>>>>> valuable advice.
>>>> Sorry for seeing your email late.We already worked out some patches to restructure
>>>> pstore. Would you like to try patchset http://article.gmane.org/gmane.linux.kernel/1697680/?
>>>>
>>>> We have more patches available to add some flags to disable/enable specific zones.
>>> That's great! I have tried your patches. BTW, Your patches do not work on ARM platform,
>>> before I changed linker scripts;
>> Initially, we just implemented it on x86. It's easy to extend it to ARM. Mostly change the arm
>> vmlinux.lds.S to add the sections. Pls. also change setup_arch to allocate memory blocks for
>> pstore.
>> In the patchset, there is an example patch, including reserve memory and zone examples.
>> Pls. reference it.
>>
>>>    And can we use this method in modules(I failed to do that)?
>> It's a good question. There are many approaches to support modules.
>> 1) Define the zone in built-in files and export it.Then, you can use it in module.
>> 2) Define the zone and new tracer functions in built-in files and export
>> the tracer functions.
>>
>>> After a quick glance and try, I think my idea is a little different from yours. I will reply you
>>> later.
>> Pls. Share your opinions. We are improving pstore to make it easier to be used.
>>
> This feature can use in real products (actually we have done that), because usually several
> mega-byte-size ram is enough and it is very useful for fault location. So I want that pstore
> can be implemented in products, not just in labs.
>
> These seems that there are at least two ways to make pstore visible to other kernel users:
>
>
> (1) static allocation:(your way, maybe my description is not good, please correct me)
>
> 	When kernel image is made, zones are determinate;
> 	So if moudules want to use a zone, we should define it in kernel source before compiling
> 	and export it;
>
>        (a)advantage:
> 	
> 	This method will not fail at most time if it passed at first time.
>
>        (b)disadvantage:
> 	
> 	Engineer should change the kernel source code if he want to get a zone to record something. For lab,
>          it is good enough; but for products, different products may use different kernel source codes if they
>          want record different messages. It is very expensive.
>
> (2) dynamic alloction: (ring buffer similar to your zone)
> 	
> 	(1) We should introduce metadata to describe the ring buffers in the ramoops bankend.
> 	    So when initializing, we just need to read metadata. then we know information of all ring buffers.
> 	    So we can read and manage all ring buffers in a list named "ring_buffer_list";
>
> 	(2) when we call pstore_alloc_ring_buffer(name,size). If "ring_buffer_list" contains this ring buffer,
> 	    we do nothing if size check passes. Else we create a ring buffer description and add it to list;
>
> 	(3) When we call pstore_write_ring_buffer(name,str). we find this ring buffer in "ring_buffer_list" by name;
> 	    and then copy strings to this ring buffer.
> 	
> 	
> 	disadvantage:
>
> 	   (1) So this alloc maybe fail when name is the same, but size isn't;
> 	   (2) We should find a way to format the backend. erase is not enough. (earse just clear the data of a ring buffer,
> 		but the ring buffer still exists).
>
> 	advantage:
> 	   (1) Os venders can implement this feature. Then people can use it even they can not compile the kernel.
> 	   (2) We can determin how to use the ramoops backend at runtime, rather than before compiling the kernel.
>
>
>
> So which way do we really need?
> And what do you think, Tony or others ?

I got your pointer. It's indeed a special requirement that using pstore in modules without recompiling
kernel source codes, especially when OS vendors don't allow to recompile kernel codes.

We can extend pstore zone by below methods:
1) Add function register_dynamic_zone. It uses the same static ZONE data structure and defines most members of
ZONE like static zones.
2) Add a kernel boot cmdline parameter, which can define ZONE name and size. At booting early stage,
kernel parses the parameter and reserves memory block for these dynamic zones.
3) When a module calls register_dynamic_zone, kernel checks the reserved dynamic zone memory using
zone name as key, and uses that memory.

One issue is pstore core codes would create pstore file entries and copy old contents to cached memory. It's
hard to release the memory and files. It means we can only insmod the modules and can't rmmod the modules if
the modules use register_dynamic_zone.

Another issue is: usually we save callchain in traces in the ZONE. If you use a module and load it to kernel
randomly, the module might be in different virtual space addresses at different loading. So we need save
callchain symbol names instead of binary addresses, which might hurt performance too much.

Does it match with your requirement?

Yanmin

