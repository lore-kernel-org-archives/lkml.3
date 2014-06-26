Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbaFZA5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:57:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:41874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbaFZA5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:57:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="357430413"
Message-ID: <53AB6FFF.4000506@linux.intel.com>
Date: Thu, 26 Jun 2014 08:57:35 +0800
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
        Liu ShuoX <shuox.liu@intel.com>, Rocher@vger.kernel.org,
        Jeremy <jeremy.rocher@intel.com>
Subject: Re: Should Pstore(ramoops) records customized information?
References: <539E6D4D.5000802@huawei.com> <53A164DB.1020305@huawei.com> <3908561D78D1C84285E8C5FCA982C28F32838E10@ORSMSX114.amr.corp.intel.com> <53A2D5BB.5040500@huawei.com> <3908561D78D1C84285E8C5FCA982C28F3283A5E3@ORSMSX114.amr.corp.intel.com> <53A41125.4080802@huawei.com> <53AA1A9F.8030108@linux.intel.com> <53AAC9D8.4010204@huawei.com>
In-Reply-To: <53AAC9D8.4010204@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/6/25 21:08, Liu hua wrote:
> 于 2014/6/25 8:41, Zhang, Yanmin 写道:
>> On 2014/6/20 18:47, Liu hua wrote:
>>> On 2014/6/20 7:42, Luck, Tony wrote:
>>>
>>>>> BTW, I note that "extern struct pstore_info *psinfo" locates in
>>>>> fs/pstore/internal.h. So users out of directory "fs/pstore/" can not use pstore to
>>>>> record messages. We do not want other kernel users to use pstore, right?  And can we
>>>>> break this?
>>>> Yes we can make some interface visible to the rest of the kernel ... probably
>>>> not the raw "*psinfo" though. Perhaps the pstore_alloc_ring_buffer() and
>>>> pstore_write_ring_buffer() functions should be the ones exported to the
>>>> rest of the kernel.
>>>>
>>>>> ditoo.. Since other backends like efi and erst may can not privide such ring buffer.
>>>>> So pstore_alloc_ring_buffer should be a funciton pointer of pstore_info struct.
>>>> Yes - that allows less capable backend like ERST and efivars to not provide the
>>>> service.  Since it becomes internal, you can drop the "pstore_" prefix.  E.g.
>>>> something like:
>>>>
>>>> int pstore_alloc_ring_buffer(char *name, int size)
>>>> {
>>>>      return psinfo->alloc_ring_buffer(name, size);
>>>> }
>>>> EXPORT_SYMBOL_GPL(pstore_alloc_ring_buffer);
>>>>
>>>> ... and you have to find/make some global header for the "extern" declaration.
>>> I will make these RFC patch series according to our discussion. Thanks you very to
>>> valuable advice.
>> Sorry for seeing your email late.We already worked out some patches to restructure
>> pstore. Would you like to try patchset http://article.gmane.org/gmane.linux.kernel/1697680/?
>>
>> We have more patches available to add some flags to disable/enable specific zones.
> That's great! I have tried your patches. BTW, Your patches do not work on ARM platform,
> before I changed linker scripts;

Initially, we just implemented it on x86. It's easy to extend it to ARM. Mostly change the arm
vmlinux.lds.S to add the sections. Pls. also change setup_arch to allocate memory blocks for
pstore.
In the patchset, there is an example patch, including reserve memory and zone examples.
Pls. reference it.

>   And can we use this method in modules(I failed to do that)?

It's a good question. There are many approaches to support modules.
1) Define the zone in built-in files and export it.Then, you can use it in module.
2) Define the zone and new tracer functions in built-in files and export
the tracer functions.

>
> After a quick glance and try, I think my idea is a little different from yours. I will reply you
> later.

Pls. Share your opinions. We are improving pstore to make it easier to be used.

