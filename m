Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaF0MHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:07:03 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:58439 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaF0MHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:07:00 -0400
Message-ID: <53AD5E4D.1030700@huawei.com>
Date: Fri, 27 Jun 2014 20:06:37 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        Liu ShuoX <shuox.liu@intel.com>, <Rocher@linux.intel.com>,
        Jeremy <jeremy.rocher@intel.com>, <zhangzhiqiang.zhang@huawei.com>
Subject: Re: Should Pstore(ramoops) records customized information?
References: <539E6D4D.5000802@huawei.com> <53A164DB.1020305@huawei.com> <3908561D78D1C84285E8C5FCA982C28F32838E10@ORSMSX114.amr.corp.intel.com> <53A2D5BB.5040500@huawei.com> <3908561D78D1C84285E8C5FCA982C28F3283A5E3@ORSMSX114.amr.corp.intel.com> <53A41125.4080802@huawei.com> <53AA1A9F.8030108@linux.intel.com> <53AAC9D8.4010204@huawei.com> <53AB6FFF.4000506@linux.intel.com>
In-Reply-To: <53AB6FFF.4000506@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.53AD5E5C.0082,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: e02cf0e5456ad60c3f7efe63ff012d29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/6/26 8:57, Zhang, Yanmin 写道:
> 
> On 2014/6/25 21:08, Liu hua wrote:
>> 于 2014/6/25 8:41, Zhang, Yanmin 写道:
>>> On 2014/6/20 18:47, Liu hua wrote:
>>>> On 2014/6/20 7:42, Luck, Tony wrote:
>>>>
>>>>>> BTW, I note that "extern struct pstore_info *psinfo" locates in
>>>>>> fs/pstore/internal.h. So users out of directory "fs/pstore/" can not use pstore to
>>>>>> record messages. We do not want other kernel users to use pstore, right?  And can we
>>>>>> break this?
>>>>> Yes we can make some interface visible to the rest of the kernel ... probably
>>>>> not the raw "*psinfo" though. Perhaps the pstore_alloc_ring_buffer() and
>>>>> pstore_write_ring_buffer() functions should be the ones exported to the
>>>>> rest of the kernel.
>>>>>
>>>>>> ditoo.. Since other backends like efi and erst may can not privide such ring buffer.
>>>>>> So pstore_alloc_ring_buffer should be a funciton pointer of pstore_info struct.
>>>>> Yes - that allows less capable backend like ERST and efivars to not provide the
>>>>> service.  Since it becomes internal, you can drop the "pstore_" prefix.  E.g.
>>>>> something like:
>>>>>
>>>>> int pstore_alloc_ring_buffer(char *name, int size)
>>>>> {
>>>>>      return psinfo->alloc_ring_buffer(name, size);
>>>>> }
>>>>> EXPORT_SYMBOL_GPL(pstore_alloc_ring_buffer);
>>>>>
>>>>> ... and you have to find/make some global header for the "extern" declaration.
>>>> I will make these RFC patch series according to our discussion. Thanks you very to
>>>> valuable advice.
>>> Sorry for seeing your email late.We already worked out some patches to restructure
>>> pstore. Would you like to try patchset http://article.gmane.org/gmane.linux.kernel/1697680/?
>>>
>>> We have more patches available to add some flags to disable/enable specific zones.
>> That's great! I have tried your patches. BTW, Your patches do not work on ARM platform,
>> before I changed linker scripts;
> 
> Initially, we just implemented it on x86. It's easy to extend it to ARM. Mostly change the arm
> vmlinux.lds.S to add the sections. Pls. also change setup_arch to allocate memory blocks for
> pstore.
> In the patchset, there is an example patch, including reserve memory and zone examples.
> Pls. reference it.
> 
>>   And can we use this method in modules(I failed to do that)?
> 
> It's a good question. There are many approaches to support modules.
> 1) Define the zone in built-in files and export it.Then, you can use it in module.
> 2) Define the zone and new tracer functions in built-in files and export
> the tracer functions.
> 
>>
>> After a quick glance and try, I think my idea is a little different from yours. I will reply you
>> later.
> 
> Pls. Share your opinions. We are improving pstore to make it easier to be used.
> 

This feature can use in real products (actually we have done that), because usually several
mega-byte-size ram is enough and it is very useful for fault location. So I want that pstore
can be implemented in products, not just in labs.

These seems that there are at least two ways to make pstore visible to other kernel users:


(1) static allocation:(your way, maybe my description is not good, please correct me)

	When kernel image is made, zones are determinate;
	So if moudules want to use a zone, we should define it in kernel source before compiling
	and export it;

      (a)advantage:
	
	This method will not fail at most time if it passed at first time.

      (b)disadvantage:
	
	Engineer should change the kernel source code if he want to get a zone to record something. For lab,
        it is good enough; but for products, different products may use different kernel source codes if they
        want record different messages. It is very expensive.

(2) dynamic alloction: (ring buffer similar to your zone)
	
	(1) We should introduce metadata to describe the ring buffers in the ramoops bankend.
	    So when initializing, we just need to read metadata. then we know information of all ring buffers.
	    So we can read and manage all ring buffers in a list named "ring_buffer_list";

	(2) when we call pstore_alloc_ring_buffer(name,size). If "ring_buffer_list" contains this ring buffer,
	    we do nothing if size check passes. Else we create a ring buffer description and add it to list;

	(3) When we call pstore_write_ring_buffer(name,str). we find this ring buffer in "ring_buffer_list" by name;
	    and then copy strings to this ring buffer.
	
	
	disadvantage:

	   (1) So this alloc maybe fail when name is the same, but size isn't;
	   (2) We should find a way to format the backend. erase is not enough. (earse just clear the data of a ring buffer,
		but the ring buffer still exists).

	advantage:
	   (1) Os venders can implement this feature. Then people can use it even they can not compile the kernel.
	   (2) We can determin how to use the ramoops backend at runtime, rather than before compiling the kernel.



So which way do we really need?
And what do you think, Tony or others ?

Thanks,
Liu Hua



