Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbaFSMVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:21:44 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:35115 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbaFSMVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:21:42 -0400
Message-ID: <53A2D5BB.5040500@huawei.com>
Date: Thu, 19 Jun 2014 20:21:15 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>
Subject: Re: Should Pstore(ramoops) records customized information?
References: <539E6D4D.5000802@huawei.com> <53A164DB.1020305@huawei.com> <3908561D78D1C84285E8C5FCA982C28F32838E10@ORSMSX114.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32838E10@ORSMSX114.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/19 1:50, Luck, Tony wrote:

Hi Tony,

Thanks for you reply.

>> (1) The backend (ramoops) provides servel memory regions staticly. Each region
>>  is a ring buffer, which does not connect with certain PSTORE_TYPE_ID. So no one
>>  can modify or use it before allocation.
>>
>> (2) A pstore user allocs a memory region, pstore will return a pstore_type_id.
>>
>>        pstore_type_id = alloc_pstroe_region()
>>
>> (3) This user record certain message to this region.
>>
>>        psinfo->write(pstore_type_id, ...)
> 
> Don't you need to match up the number of back-end ring buffer regions
> with the number of users in the kernel that call alloc_pstore_region()?
> 
> Or do you envision that the backend can create these regions on demand?

I have do some experiments on ramoops. This may be realizable.

This idea comes from real products'demands . Becasue ram is rather cheap and
we do not need to add new hardware, product engineers want to record several
kinds of messages into reserved ram. (including kernel snapshot, softlookup, ftrace;
panic, even the user-space events and so on). Different products usually care about
different messages.

So we realized a mechanism named "KBOX" to provide ring-buffer alloction on reserved memory.
Kernel users can allocate and use a ring buffer. I think pstore(ramoops) may also need
this feature.

BTW, I note that "extern struct pstore_info *psinfo" locates in
fs/pstore/internal.h. So users out of directory "fs/pstore/" can not use pstore to
record messages. We do not want other kernel users to use pstore, right?  And can we
break this?

> 
> Would different users need different sized regions? I think logging of
> console messages might be able to work with a smaller ring buffer
> than the ftrace logger. So perhaps we need a "size" argument when allocating?

Yes, I will add this to my RFC patches.
> 
> Since these "regions" are in fact "ring buffers", the name of the allocation
> routine should make that clear.  So call it "pstore_alloc_ring_buffer()"
Yes, ditto..

> After the system hangs/crashes ... how would you like pstore to
> name these objects in /sys/fs/pstore/ for applications to pick them
> up for analysis?  Maybe pstore_alloc_ring_buffer() needs a "char *name"
> argument as well as a size?
> 
ditoo.. Since other backends like efi and erst may can not privide such ring buffer.
So pstore_alloc_ring_buffer should be a funciton pointer of pstore_info struct.

Thanks very much again. if pstore can accept this feature, it will be a great news for us.
we will drop our "KBOX" gradually, using pstore instead. If necessary, I will try to send
patch series to do this. What do you think about it?

Thanks,
Liu Hua



> -Tony
> 


