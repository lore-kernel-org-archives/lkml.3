Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbbABCac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 21:30:32 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41691 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbbABCa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 21:30:27 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CACVXFVMjvdUNO-BHG5MFx=9anQoGf4O1j9vNFfc=amXMxm6FzA@mail.gmail.com>
References: <CA+icZUXCCopMw4ZUyUYPT0seMVT4W0GuNhn3Z5Erte+LMhxzkQ@mail.gmail.com>
	<CA+icZUXcpmFhCJ0=eiVe=XMbVFRCSLxUpaNNh2E7vEStMwjg=A@mail.gmail.com>
	<CA+icZUU=FPioz0SbMA+GYTcsz41ADfE1oCq5zFB3SGrvZyCc6A@mail.gmail.com>
	<CACVXFVMR=-CGq=EWWCorD-DBge=stygvrgY1kuR7rBh_96mA=A@mail.gmail.com>
	<CA+icZUU7Pet-22m8uxFSBFkG8U1drK7XzpdGaFQQBFBNVRTgJQ@mail.gmail.com>
	<CACVXFVOt=A=NzPBqXp8LeHRYNxhwzxwohbnZf7ZnRvqYDgq6+A@mail.gmail.com>
	<CA+icZUU=kQqHBiApjJusudqU0vXu6aXznEuQCt0ESh1nYeKESg@mail.gmail.com>
	<CACVXFVMjvdUNO-BHG5MFx=9anQoGf4O1j9vNFfc=amXMxm6FzA@mail.gmail.com>
Date: Fri, 2 Jan 2015 03:30:26 +0100
Message-ID: <CA+icZUXv5tKUKdavgQ+Z=OBRUDZNzrN2epOh_-MiyPotaKntnA@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] block: loop: convert to blk-mq
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2015 at 3:22 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Thu, Jan 1, 2015 at 11:14 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Thu, Jan 1, 2015 at 1:29 AM, Ming Lei <tom.leiming@gmail.com> wrote:
>> [...]
>>>> How did you test with fio (your fio lines)?
>>>
>>> Your fio command line is basically same with my fio config, and you
>>> can attach one image to loop via:  losetup -f file_name. Looks your
>>> randread result is good, and I can observe ~80 IOPS vs. ~200 IOPS
>>> on my slow HDD. in the randread test too.
>>>
>>> #################fio config##########################
>>> [global]
>>> direct=1
>>> size=128G
>>> bsrange=4k-4k
>>> timeout=30
>>> numjobs=1
>>> ioengine=libaio
>>> iodepth=64
>>> filename=/dev/loop0
>>> group_reporting=1
>>>
>>> [f]
>>> rw=${RW}
>>>
>>
>> Thanks for your fio config-file.
>>
>> When a 1GiB is created on my ext4-system, the IOPS raised up from 515 to 981.
>>
>> # egrep 'iops=|Laying out IO file' fio-test*next20141231-1-loopmq-small*
>> fio-test1-3.19.0-rc2-next20141231-1-loopmq-small.txt:  read :
>> io=1024.0MB, bw=2063.4KB/s, iops=515 , runt=508182msec
>> fio-test2-3.19.0-rc2-next20141231-1-loopmq-small.txt:randread: Laying
>> out IO file(s) (1 file(s) / 1024MB)
>> fio-test2-3.19.0-rc2-next20141231-1-loopmq-small.txt:  read :
>> io=1024.0MB, bw=3924.3KB/s, iops=981 , runt=267206msec
>>
>> I made some more testing with next-20141231 plus block-loop-mq-v3 and
>> block.git#for-linus on top (see attached full patch).
>
> I will submit v4 after block.git#for-linus is merged for avoiding
> the conflict, and blk_mq_freeze_queue() still need to be
> exported.
>
>>
>> This increases IOPS from 981 up to 2103.
>
> Looks there isn't fancy patch for performance boost in block.git#for-linus,
> I am wondering it may be caused by page cache, and before each test,
> I always drop cache via 'echo 3 > /proc/sys/vm/drop_caches' for avoiding
> the effect.
>

OK, good to know.
I played a bit with the --size option, below 1GiB I get some fantastic results.
But I will retest with dropped-caches.

>>
>> # egrep 'iops=|Laying out IO file'
>> fio-test2-3.19.0-rc2-next20141231-1-loopmq-small.txt
>> fio-test2-3.19.0-rc2-next20141231-3-loopmq-small.txt
>> fio-test2-3.19.0-rc2-next20141231-1-loopmq-small.txt:randread: Laying
>> out IO file(s) (1 file(s) / 1024MB)
>> fio-test2-3.19.0-rc2-next20141231-1-loopmq-small.txt:  read :
>> io=1024.0MB, bw=3924.3KB/s, iops=981 , runt=267206msec
>> fio-test2-3.19.0-rc2-next20141231-3-loopmq-small.txt:randread: Laying
>> out IO file(s) (1 file(s) / 1024MB)
>> fio-test2-3.19.0-rc2-next20141231-3-loopmq-small.txt:  read :
>> io=1024.0MB, bw=8414.9KB/s, iops=2103 , runt=124611msec
>>
>> If you like you can have a closer look at the fio benchmark results,
>
> Anyway both us can observe big improvement on randread about
> the patch.
>
>> I also have added two patches which made it easy for me to cope with
>> the merge conflicts within block/loop stuff.
>
> Thanks for your report on this conflict.
>

BTW, I played also with plain block-linus and your patchset on top
against a vanilla Linux v3.19-rc2.

v4 much appreciated.

Feel free to add my Tested-by.

- Sedat -
