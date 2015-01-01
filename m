Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbbAAA3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 19:29:39 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54765 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbbAAA3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 19:29:38 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUU7Pet-22m8uxFSBFkG8U1drK7XzpdGaFQQBFBNVRTgJQ@mail.gmail.com>
References: <CA+icZUXCCopMw4ZUyUYPT0seMVT4W0GuNhn3Z5Erte+LMhxzkQ@mail.gmail.com>
	<CA+icZUXcpmFhCJ0=eiVe=XMbVFRCSLxUpaNNh2E7vEStMwjg=A@mail.gmail.com>
	<CA+icZUU=FPioz0SbMA+GYTcsz41ADfE1oCq5zFB3SGrvZyCc6A@mail.gmail.com>
	<CACVXFVMR=-CGq=EWWCorD-DBge=stygvrgY1kuR7rBh_96mA=A@mail.gmail.com>
	<CA+icZUU7Pet-22m8uxFSBFkG8U1drK7XzpdGaFQQBFBNVRTgJQ@mail.gmail.com>
Date: Thu, 1 Jan 2015 08:29:37 +0800
Message-ID: <CACVXFVOt=A=NzPBqXp8LeHRYNxhwzxwohbnZf7ZnRvqYDgq6+A@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] block: loop: convert to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 8:18 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Jan 1, 2015 at 1:01 AM, Ming Lei <tom.leiming@gmail.com> wrote:
>> Hi Sedat,
>>
>> On Thu, Jan 1, 2015 at 6:32 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> Forgot to CC LKML and linux-fsdevel.
>>>
>>> - Sedat -
>>
>>>
>>> OK, I have installed fio (1.59-1) and libaio1 (0.3.109-2ubuntu1) here.
>>>
>>> You say in [1]:
>>>
>>> "In the following test:
>>> - base: v3.19-rc2-2041231
>>> - loop over file in ext4 file system on SSD disk
>>> - bs: 4k, libaio, io depth: 64, O_DIRECT, num of jobs: 1
>>> - throughput: IOPS"
>>>
>>> I tried to reproduce that inspired by [2]...
>>>
>>> root# fio --name=randread --rw=randread --bs=4k --ioengine=libaio
>>> --iodepth=64 --direct=1 --numjobs=1 --size=1G
>>>
>>> ...you had no size given (here: 1GiB) - fio requires that parameter to run.
>>>
>>> This results in 165 VS. 515 IOPS here.
>>
>> Thanks for your test.
>>
>> Also if your disk is quick enough, you will observe improvement on
>> read test too.
>>
>
> This is no SSD here.
>
> # dmesg | egrep -i 'hitachi|ata1|sda'
> [    0.457892] ata1: SATA max UDMA/133 abar m2048@0xf0708000 port
> 0xf0708100 irq 25
> [    0.777445] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    0.778759] ata1.00: ATA-8: Hitachi HTS545050A7E380, GG2OA6C0, max UDMA/133
> [    0.778778] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    0.780154] ata1.00: configured for UDMA/133
> [    0.780970] scsi 0:0:0:0: Direct-Access     ATA      Hitachi
> HTS54505 A6C0 PQ: 0 ANSI: 5
> [    0.782050] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks:
> (500 GB/465 GiB)
> [    0.782058] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    0.782255] sd 0:0:0:0: [sda] Write Protect is off
> [    0.782262] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.782339] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    0.800644]  sda: sda1 sda2 sda3
> [    0.802029] sd 0:0:0:0: [sda] Attached SCSI disk
>
> How did you test with fio (your fio lines)?

Your fio command line is basically same with my fio config, and you
can attach one image to loop via:  losetup -f file_name. Looks your
randread result is good, and I can observe ~80 IOPS vs. ~200 IOPS
on my slow HDD. in the randread test too.

#################fio config##########################
[global]
direct=1
size=128G
bsrange=4k-4k
timeout=30
numjobs=1
ioengine=libaio
iodepth=64
filename=/dev/loop0
group_reporting=1

[f]
rw=${RW}



Thanks,
Ming Lei
