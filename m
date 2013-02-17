Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3BQGhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 01:37:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab3BQGhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 01:37:34 -0500
Message-ID: <51207AA1.4090408@redhat.com>
Date: Sun, 17 Feb 2013 14:37:21 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        mst@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 4/9] virtio-blk: use virtqueue_start_buf on req path
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com> <1360671815-2135-5-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1360671815-2135-5-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 08:23 PM, Paolo Bonzini wrote:
> This is similar to the previous patch, but a bit more radical
> because the bio and req paths now share the buffer construction
> code.  Because the req path doesn't use vbr->sg, however, we
> need to add a couple of arguments to __virtblk_add_req.
> 
> We also need to teach __virtblk_add_req how to build SCSI command
> requests.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/block/virtio_blk.c |   74 ++++++++++++++++++++++---------------------
>  1 files changed, 38 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 4a31fcc..22deb65 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -102,18 +102,26 @@ static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
>  }
>  
>  static int __virtblk_add_req(struct virtqueue *vq,
> -			     struct virtblk_req *vbr)
> +			     struct virtblk_req *vbr,
> +			     struct scatterlist *data_sg,
> +			     unsigned data_nents)
>  {
>  	struct scatterlist sg;
>  	enum dma_data_direction dir;
>  	int ret;
>  
> +	int type = vbr->out_hdr.type & ~VIRTIO_BLK_T_OUT;
>  	unsigned int nents = 2;
>  	unsigned int nsg = 2;
>  
> -	if (vbr->nents) {
> +	if (type == VIRTIO_BLK_T_SCSI_CMD) {
> +		BUG_ON(use_bio);

Do we really need the BUG_ON?  Even if with use_bio=1,
VIRTIO_BLK_T_SCSI_CMD cmd can be fired. See this:

# cat /proc/cmdline
root=/dev/mapper/rhel-root console=ttyS0 virtio_blk.use_bio=1

# sg_inq /dev/vda
[   36.042300] ------------[ cut here ]------------
[   36.043021] kernel BUG at drivers/block/virtio_blk.c:118!
[   36.043021] invalid opcode: 0000 [#1] SMP
[   36.043021] Modules linked in:
[   36.043021] CPU 2
[   36.043021] Pid: 3311, comm: sg_inq Not tainted 3.8.0-rc7+ #618 Bochs
Bochs
[   36.043021] RIP: 0010:[<ffffffff816d740d>]  [<ffffffff816d740d>]
__virtblk_add_req+0x1cd/0x1e0
[   36.043021] RSP: 0018:ffff88007b59b9d8  EFLAGS: 00010002
[   36.043021] RAX: 0000000000000001 RBX: 0000000000000002 RCX:
0000000000000002
[   36.043021] RDX: 0000000000000002 RSI: ffff88007a430000 RDI:
ffff88007b422000
[   36.043021] RBP: ffff88007b59ba28 R08: ffff88007b59b9e0 R09:
ffff88007b59b9f4
[   36.043021] R10: 0000000000000001 R11: ffff88007bf57900 R12:
ffff88007a430000
[   36.043021] R13: ffff88007b422000 R14: 0000000000000001 R15:
ffff880077d34088
[   36.043021] FS:  00007eff2efcb740(0000) GS:ffff88007eb00000(0000)
knlGS:0000000000000000
[   36.043021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.043021] CR2: 0000003f33e0f200 CR3: 000000007f023000 CR4:
00000000000006e0
[   36.043021] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   36.043021] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[   36.043021] Process sg_inq (pid: 3311, threadinfo ffff88007b59a000,
task ffff88007f47a3f0)
[   36.043021] Stack:
[   36.043021]  ffff88007b59ba40 ffff880077d34088 ffff88007bf57980
0000000100000001
[   36.043021]  ffff88007fffa6c0 ffff88007a430000 ffff88007f66abc0
ffff880077d34000
[   36.043021]  ffff88007bdab410 0000000000000000 ffff88007b59ba78
ffffffff816d7f6c
[   36.043021] Call Trace:
[   36.043021]  [<ffffffff816d7f6c>] virtblk_request+0xec/0x1c0
[   36.043021]  [<ffffffff8148b947>] __blk_run_queue+0x37/0x50
[   36.043021]  [<ffffffff81486c10>] __elv_add_request+0xb0/0x230
[   36.043021]  [<ffffffff81491c69>] blk_execute_rq_nowait+0x79/0x100
[   36.043021]  [<ffffffff811f06e1>] ? bio_phys_segments+0x21/0x30
[   36.043021]  [<ffffffff81491d5d>] blk_execute_rq+0x6d/0xf0
[   36.043021]  [<ffffffff81491798>] ? blk_rq_append_bio+0x28/0x70
[   36.043021]  [<ffffffff81491ad0>] ? blk_rq_map_user+0x1a0/0x280
[   36.043021]  [<ffffffff814979c4>] sg_io+0x274/0x3e0
[   36.043021]  [<ffffffff81497f15>] scsi_cmd_ioctl+0x3e5/0x460
[   36.043021]  [<ffffffff8118c816>] ? handle_pte_fault+0xf6/0x9c0
[   36.043021]  [<ffffffff8116e8e0>] ? release_pages+0x190/0x1e0
[   36.043021]  [<ffffffff81497fe1>] scsi_cmd_blk_ioctl+0x51/0x70
[   36.043021]  [<ffffffff816d80ac>] virtblk_ioctl+0x6c/0x90
[   36.043021]  [<ffffffff81494068>] __blkdev_driver_ioctl+0x28/0x30
[   36.043021]  [<ffffffff814946d0>] blkdev_ioctl+0x200/0x7b0
[   36.043021]  [<ffffffff811c0836>] ? cp_new_stat+0x116/0x130
[   36.043021]  [<ffffffff811f232c>] block_ioctl+0x3c/0x40
[   36.043021]  [<ffffffff811cceaa>] do_vfs_ioctl+0x9a/0x550
[   36.043021]  [<ffffffff811cd3b7>] sys_ioctl+0x57/0x90
[   36.043021]  [<ffffffff814b7c4e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[   36.043021]  [<ffffffff81c6ad99>] system_call_fastpath+0x16/0x1b
[   36.043021] Code: 24 20 48 8d 7d b0 ba 10 00 00 00 e8 2e 3d de ff 48
8d 75 b0 b9 02 00 00 00 ba 01 00 00 00 4c 89 ef e8 88 bb e6 ff
e9 d9 fe ff ff <0f> 0b eb fe 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
00 55 48
[   36.043021] RIP  [<ffffffff816d740d>] __virtblk_add_req+0x1cd/0x1e0
[   36.043021]  RSP <ffff88007b59b9d8>
[   36.043021] ---[ end trace 93ac0a3ba2789369 ]---


> +		nsg += 3;
> +		nents += 3;
> +	}
> +	if (data_nents) {
>  		nsg++;
> -		nents += vbr->nents;
> +		nents += data_nents;
>  	}
>  
>  	ret = virtqueue_start_buf(vq, vbr, nents, nsg, GFP_ATOMIC);
> @@ -124,14 +132,32 @@ static int __virtblk_add_req(struct virtqueue *vq,
>  	sg_init_one(&sg, &vbr->out_hdr, sizeof(vbr->out_hdr));
>  	virtqueue_add_sg(vq, &sg, 1, dir);
>  
> -	if (vbr->nents) {
> +	/*
> +	 * If this is a packet command we need a couple of additional headers.
> +	 * Behind the normal outhdr we put a segment with the scsi command
> +	 * block, and before the normal inhdr we put the sense data and the
> +	 * inhdr with additional status information.
> +	 */
> +	if (type == VIRTIO_BLK_T_SCSI_CMD) {
> +		sg_init_one(&sg, vbr->req->cmd, vbr->req->cmd_len);
> +		virtqueue_add_sg(vq, &sg, 1, dir);
> +	}
> +
> +	if (data_nents) {
>  		if ((vbr->out_hdr.type & VIRTIO_BLK_T_OUT) == 0)
>  			dir = DMA_FROM_DEVICE;
>  
> -		virtqueue_add_sg(vq, vbr->sg, vbr->nents, dir);
> +		virtqueue_add_sg(vq, data_sg, data_nents, dir);
>  	}
>  
>  	dir = DMA_FROM_DEVICE;
> +	if (type == VIRTIO_BLK_T_SCSI_CMD) {
> +		sg_init_one(&sg, vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
> +		virtqueue_add_sg(vq, &sg, 1, dir);
> +		sg_init_one(&sg, &vbr->in_hdr, sizeof(vbr->in_hdr));
> +		virtqueue_add_sg(vq, &sg, 1, dir);
> +	}
> +
>  	sg_init_one(&sg, &vbr->status, sizeof(vbr->status));
>  	virtqueue_add_sg(vq, &sg, 1, dir);
>  
> @@ -146,7 +172,8 @@ static void virtblk_add_req(struct virtblk_req *vbr)
>  	int ret;
>  
>  	spin_lock_irq(vblk->disk->queue->queue_lock);
> -	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr)) < 0)) {
> +	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr, vbr->sg,
> +						 vbr->nents)) < 0)) {
>  		prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
>  					  TASK_UNINTERRUPTIBLE);
>  
> @@ -299,7 +326,7 @@ static void virtblk_done(struct virtqueue *vq)
>  static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
>  		   struct request *req)
>  {
> -	unsigned long num, out = 0, in = 0;
> +	unsigned int num;
>  	struct virtblk_req *vbr;
>  
>  	vbr = virtblk_alloc_req(vblk, GFP_ATOMIC);
> @@ -336,40 +363,15 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
>  		}
>  	}
>  
> -	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
> -
> -	/*
> -	 * If this is a packet command we need a couple of additional headers.
> -	 * Behind the normal outhdr we put a segment with the scsi command
> -	 * block, and before the normal inhdr we put the sense data and the
> -	 * inhdr with additional status information before the normal inhdr.
> -	 */
> -	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC)
> -		sg_set_buf(&vblk->sg[out++], vbr->req->cmd, vbr->req->cmd_len);
> -
> -	num = blk_rq_map_sg(q, vbr->req, vblk->sg + out);
> -
> -	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC) {
> -		sg_set_buf(&vblk->sg[num + out + in++], vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
> -		sg_set_buf(&vblk->sg[num + out + in++], &vbr->in_hdr,
> -			   sizeof(vbr->in_hdr));
> -	}
> -
> -	sg_set_buf(&vblk->sg[num + out + in++], &vbr->status,
> -		   sizeof(vbr->status));
> -
> +	num = blk_rq_map_sg(q, vbr->req, vblk->sg);
>  	if (num) {
> -		if (rq_data_dir(vbr->req) == WRITE) {
> +		if (rq_data_dir(vbr->req) == WRITE)
>  			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
> -			out += num;
> -		} else {
> +		else
>  			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
> -			in += num;
> -		}
>  	}
>  
> -	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr,
> -			      GFP_ATOMIC) < 0) {
> +	if (__virtblk_add_req(vblk->vq, vbr, vblk->sg, num) < 0) {
>  		mempool_free(vbr, vblk->pool);
>  		return false;
>  	}
> 


-- 
Asias
