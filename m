Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaE3F6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:58:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaE3F6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:58:20 -0400
MIME-Version: 1.0
In-Reply-To: <5387FC96.4030508@kernel.dk>
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com>
	<5387F8B2.1070509@kernel.dk>
	<CACVXFVPoG6_fL_MTRF+616W7UdHpSgjtMLBLeBn4OGR63haw3w@mail.gmail.com>
	<5387FC96.4030508@kernel.dk>
Date: Fri, 30 May 2014 13:58:17 +0800
Message-ID: <CACVXFVMN7do7WaHGQCwy=nkpCm1Vp2ZrCuAHmnXhbANPEqvQyg@mail.gmail.com>
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world switch
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:35 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-05-29 21:34, Ming Lei wrote:
>>
>> On Fri, May 30, 2014 at 11:19 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 2014-05-29 20:49, Ming Lei wrote:
>>>>
>>>>
>>>> Firstly, it isn't necessary to hold lock of vblk->vq_lock
>>>> when notifying hypervisor about queued I/O.
>>>>
>>>> Secondly, virtqueue_notify() will cause world switch and
>>>> it may take long time on some hypervisors(such as, qemu-arm),
>>>> so it isn't good to hold the lock and block other vCPUs.
>>>>
>>>> On arm64 quad core VM(qemu-kvm), the patch can increase I/O
>>>> performance a lot with VIRTIO_RING_F_EVENT_IDX enabled:
>>>>          - without the patch: 14K IOPS
>>>>          - with the patch: 34K IOPS
>>>
>>>
>>>
>>> Patch looks good to me. I don't see a hit on my qemu-kvm testing, but it
>>> definitely makes sense and I can see it hurting in other places.
>>
>>
>> It isn't easy to observe the improvement on x86 VM, especially
>> with few vCPUs, because qemu-system-x86_64 only takes
>> several microseconds to handle the notification, but on arm64, it
>> may take hundreds of microseconds, so the improvement is
>> obvious on arm VM.
>>
>> I hope this patch can be merged, at least arm VM can benefit
>> from it.
>
>
> If Rusty agrees, I'd like to add it for 3.16 with a stable marker.

Interesting, even on x86, I still can observe the improvement
when the numjobs is set as 2 in the fio script(see commit log), but
when numjobs is set as 4, 8, 12, the difference isn't obvious between
patched kernel and non-patched kernel.

1, environment
- host: 2sockets, each CPU(4cores, 2 threads), total 16 logical cores
- guest: 16cores, 8GB ram
- guest kernel: 3.15-rc7-next with patch[1]
- fio: the script in commit log with numjobs set as 2

2, result
- without the patch: ~104K IOPS
- with the patch: ~140K IOPS


Rusty, considered the same trick has been applied in virt-scsi,
do you agree to take the same approach in virt-blk too?


[1], http://marc.info/?l=linux-kernel&m=140135041423441&w=2

Thanks,
--
Ming Lei
