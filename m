Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaIMPPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 11:15:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36511 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaIMPPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 11:15:50 -0400
MIME-Version: 1.0
In-Reply-To: <87oaulhav5.fsf@rustcorp.com.au>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
	<20140902162146.GA28741@infradead.org>
	<5405EF38.60007@kernel.dk>
	<20140903121902.7a9f5a5a@tom-ThinkPad-T410>
	<87bnquk4fe.fsf@rustcorp.com.au>
	<878ulyjn23.fsf@rustcorp.com.au>
	<87y4trhwqr.fsf@rustcorp.com.au>
	<CACVXFVOX=Tcc9fN_C0FuEHsF22dave9vXtoVct5sx1iK1AWRXg@mail.gmail.com>
	<87oaulhav5.fsf@rustcorp.com.au>
Date: Sat, 13 Sep 2014 23:15:47 +0800
Message-ID: <CACVXFVPf-3DazWWAjGSavdN2KzP=P7FBN9+OZUTTr8qjp5aH7w@mail.gmail.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
From: Ming Lei <ming.lei@canonical.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Fri, Sep 12, 2014 at 9:43 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Ming Lei <ming.lei@canonical.com> writes:
>> On Thu, Sep 11, 2014 at 7:38 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> Rusty Russell <rusty@rustcorp.com.au> writes:
>>>> Rusty Russell <rusty@rustcorp.com.au> writes:
>>>> Here's what I have.  It seems to work as expected, but I haven't
>>>> benchmarked it.
>>>
>>> Hi Ming,
>>>
>>>         Any chance you can run your benchmarks against this patch?
>>
>> I can run the previous benchmark against this patch, but I am wondering
>> if it is enough since the change need lots of test cases to verify.
>
> Indeed, I'll particularly need to run network tests as well, but you're
> the one who suggesting the fix for block so I'm relying on you to see
> if this helps :)
>
>> BTW, looks your patch doesn't against upstream kernel, since I can't
>> find alloc_indirect() in drivers/virtio/virtio_ring.c
>
> Yes, the code in my pending-rebases tree has been reworked.  Here's
> the backport for you:

I didn't know your virtio tree, otherwise I can pull your tree by myself, :-)

Follows my virtio-blk test and result:

1, FIO script
[global]
direct=1
size=128G
bsrange=${BS}-${BS}
timeout=60
numjobs=4
ioengine=libaio
iodepth=64
filename=/dev/vdb     #backed by /dev/nullb0, 4 virtqueues per virtio-blk
group_reporting=1

[f]
rw=randread

2, hypervisor(patched QEMU with multi virtqueue support)

git://kernel.ubuntu.com/ming/linux.git v3.17-block-dev_v3

3, host
- 2 sockets, 8 physical cores(16 threads), Intel Xeon 2.13GHz
- 24G RAM

4, QEMU command line
$QEMUPATH \
    -name 'kvm-test'  \
    -M pc  \
    -vga none  \
    -drive id=drive_image1,if=none,format=raw,cache=none,aio=native,file=rootfs.img
\
    -device virtio-blk-pci,id=image1,drive=drive_image1,bootindex=1,scsi=off,config-wce=off,x-data-plane=on,bus=pci.0,addr=02
\
    -drive id=drive_image3,if=none,format=raw,cache=none,aio=native,file=/dev/nullb0
\
    -device virtio-blk-pci,id=image3,drive=drive_image3,bootindex=3,scsi=off,config-wce=off,x-data-plane=on,vectors=5,num_queues=4,bus=pci.0,addr=04
\
    -device virtio-net-pci,mac=9a:be:bf:c0:c1:c2,id=idDyAIbK,vectors=4,netdev=idabMX4S,bus=pci.0,addr=05
\
    -netdev user,id=idabMX4S,hostfwd=tcp::5000-:22  \
    -m 8192  \
    -smp 4,maxcpus=4  \
    -kernel $KERNEL_IMG \
    -append 'earlyprintk console=ttyS0 mem=8192M rootfstype=ext4
root=/dev/vda rw virtio_blk.queue_depth=128 loglevel=9
no_console_suspend ip=dhcp'  \
    -nographic  \
    -rtc base=utc,clock=host,driftfix=none \
    -enable-kvm

5, result
5.1 without Rusty's virtio-vring patch
- BS=4K, throughput: 179K
- BS=256K, throughput: 27540

5.2 with Rusty's virtio-vring patch
- BS=4K, throughput: 173K
- BS=256K, throughput: 25350

Looks throughput decreases if BS is 256K in case of your patch.

Thanks,
--
Ming Lei
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 4d08f45a9c29..5a911e1f7462 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -78,6 +78,11 @@ struct vring_virtqueue
>         /* Number we've added since last sync. */
>         unsigned int num_added;
>
> +       /* How many descriptors have been added. */
> +       unsigned int num_in_use;
> +       /* Maximum descriptors in use (degrades over time). */
> +       unsigned int max_in_use;
> +
>         /* Last used index we've seen. */
>         u16 last_used_idx;
>
> @@ -184,6 +189,31 @@ static inline int vring_add_indirect(struct vring_virtqueue *vq,
>         return head;
>  }
>
> +static bool try_indirect(struct vring_virtqueue *vq, unsigned int total_sg)
> +{
> +       unsigned long num_expected;
> +
> +       if (!vq->indirect)
> +               return false;
> +
> +       /* Completely full?  Don't even bother with indirect alloc */
> +       if (!vq->vq.num_free)
> +               return false;
> +
> +       /* We're not going to fit?  Try indirect. */
> +       if (total_sg > vq->vq.num_free)
> +               return true;
> +
> +       /* We should be tracking this. */
> +       BUG_ON(vq->max_in_use < vq->num_in_use);
> +
> +       /* How many more descriptors do we expect at peak usage? */
> +       num_expected = vq->max_in_use - vq->num_in_use;
> +
> +       /* If each were this size, would they overflow? */
> +       return (total_sg * num_expected > vq->vq.num_free);
> +}
> +
>  static inline int virtqueue_add(struct virtqueue *_vq,
>                                 struct scatterlist *sgs[],
>                                 struct scatterlist *(*next)
> @@ -226,7 +256,7 @@ static inline int virtqueue_add(struct virtqueue *_vq,
>
>         /* If the host supports indirect descriptor tables, and we have multiple
>          * buffers, then go indirect. FIXME: tune this threshold */
> -       if (vq->indirect && total_sg > 1 && vq->vq.num_free) {
> +       if (try_indirect(vq, total_sg)) {
>                 head = vring_add_indirect(vq, sgs, next, total_sg, total_out,
>                                           total_in,
>                                           out_sgs, in_sgs, gfp);
> @@ -291,6 +321,14 @@ add_head:
>         virtio_wmb(vq->weak_barriers);
>         vq->vring.avail->idx++;
>         vq->num_added++;
> +       vq->num_in_use++;
> +
> +       /* Every vq->vring.num descriptors, decay the maximum value */
> +       if (unlikely(avail == 0))
> +               vq->max_in_use >>= 1;
> +
> +       if (vq->num_in_use > vq->max_in_use)
> +               vq->max_in_use = vq->num_in_use;
>
>         /* This is very unlikely, but theoretically possible.  Kick
>          * just in case. */
> @@ -569,6 +607,7 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
>                 virtio_mb(vq->weak_barriers);
>         }
>
> +       vq->num_in_use--;
>  #ifdef DEBUG
>         vq->last_add_time_valid = false;
>  #endif
> @@ -791,6 +830,8 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
>         vq->last_used_idx = 0;
>         vq->num_added = 0;
>         list_add_tail(&vq->vq.list, &vdev->vqs);
> +       vq->num_in_use = 0;
> +       vq->max_in_use = 0;
>  #ifdef DEBUG
>         vq->in_use = false;
>         vq->last_add_time_valid = false;
