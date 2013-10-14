Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3JNKYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:24:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24357 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3JNKYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:24:22 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-14-525bc6545e17
Message-id: <525BC653.5070901@samsung.com>
Date: Mon, 14 Oct 2013 12:24:19 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.0.1
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] videobuf2: Add missing lock held on vb2_fop_relase
References: <"Hans Verkuil <hverkuil"@xs4all.nl>
 <1381736489-27852-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1381736489-27852-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t/xa7ohx6KDDKbsl7Y42/SG3eLyrjls
	Fj0btrJaXFwnbzHl7U92i67ueUwWh9+0szqwe+ycdZfd4/Gvl2wefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAldHz8zJrQbtCxbvjl9kaGP9KdTFyckgImEh8+LeJEcIWk7hwbz0biC0ksJRR
	4uWUoi5GLiD7E6PEpD1vwYp4BbQkfrY+YQKxWQRUJfr//WcHsdkEDCW63naBNYsKhEpMXTiB
	DaJeUOLH5HssIINEQAbdOTqNGSTBLKAvMXfLUrChwgLuEo3tk1khNhdIPDt6H2wBp4CXxN3F
	f1kg6s0kHrWsg+qVl9i85i3zBEaBWUh2zEJSNgtJ2QJG5lWMoqmlyQXFSem5hnrFibnFpXnp
	esn5uZsYIaH9ZQfj4mNWhxgFOBiVeHgFnKKDhFgTy4orcw8xSnAwK4nwCs4DCvGmJFZWpRbl
	xxeV5qQWH2Jk4uCUamBMv3Hg+y9+1gzV879XW5yf41Pfctty7dpjDZo7Hiea/Vm/T/jrBF7h
	2fN42EJLmLV+sC15snb/G/nip5dOSkxOzbTYprTm5YP0bKkST7mEEreNu5Yv5FM0d3r5npf9
	yde/ohcdck89vGli5+6WIvjieSbvjQkGSRpm/76/69fy7rx7SpbjRdYsJZbijERDLeai4kQA
	mA+wuEsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2013-10-14 09:41, Ricardo Ribalda Delgado wrote:
> vb2_fop_relase does not held the lock although it is modifying the
> queue->owner field.
>
> This could lead to race conditions on the vb2_perform_io function
> when multiple applications are accessing the video device via
> read/write API:
>
> [ 308.297741] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000260
> [ 308.297759] IP: [<ffffffffa07a9fd2>] vb2_perform_fileio+0x372/0x610
> [videobuf2_core]
> [ 308.297794] PGD 159719067 PUD 158119067 PMD 0
> [ 308.297812] Oops: 0000 #1 SMP
> [ 308.297826] Modules linked in: qt5023_video videobuf2_dma_sg
> qtec_xform videobuf2_vmalloc videobuf2_memops videobuf2_core
> qtec_white qtec_mem gpio_xilinx qtec_cmosis qtec_pcie fglrx(PO)
> spi_xilinx spi_bitbang qt5023
> [ 308.297888] CPU: 1 PID: 2189 Comm: java Tainted: P O 3.11.0-qtec-standard #1
> [ 308.297919] Hardware name: QTechnology QT5022/QT5022, BIOS
> PM_2.1.0.309 X64 05/23/2013
> [ 308.297952] task: ffff8801564e1690 ti: ffff88014dc02000 task.ti:
> ffff88014dc02000
> [ 308.297962] RIP: 0010:[<ffffffffa07a9fd2>] [<ffffffffa07a9fd2>]
> vb2_perform_fileio+0x372/0x610 [videobuf2_core]
> [ 308.297985] RSP: 0018:ffff88014dc03df8 EFLAGS: 00010202
> [ 308.297995] RAX: 0000000000000000 RBX: ffff880158a23000 RCX: dead000000100100
> [ 308.298003] RDX: 0000000000000000 RSI: dead000000200200 RDI: 0000000000000000
> [ 308.298012] RBP: ffff88014dc03e58 R08: 0000000000000000 R09: 0000000000000001
> [ 308.298020] R10: ffffea00051e8380 R11: ffff88014dc03fd8 R12: ffff880158a23070
> [ 308.298029] R13: ffff8801549040b8 R14: 0000000000198000 R15: 0000000001887e60
> [ 308.298040] FS: 00007f65130d5700(0000) GS:ffff88015ed00000(0000)
> knlGS:0000000000000000
> [ 308.298049] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 308.298057] CR2: 0000000000000260 CR3: 0000000159630000 CR4: 00000000000007e0
> [ 308.298064] Stack:
> [ 308.298071] ffff880156416c00 0000000000198000 0000000000000000
> ffff880100000001
> [ 308.298087] ffff88014dc03f50 00000000810a79ca 0002000000000001
> ffff880154904718
> [ 308.298101] ffff880156416c00 0000000000198000 ffff880154904338
> ffff88014dc03f50
> [ 308.298116] Call Trace:
> [ 308.298143] [<ffffffffa07aa3c4>] vb2_read+0x14/0x20 [videobuf2_core]
> [ 308.298198] [<ffffffffa07aa494>] vb2_fop_read+0xc4/0x120 [videobuf2_core]
> [ 308.298252] [<ffffffff8154ee9e>] v4l2_read+0x7e/0xc0
> [ 308.298296] [<ffffffff8116e639>] vfs_read+0xa9/0x160
> [ 308.298312] [<ffffffff8116e882>] SyS_read+0x52/0xb0
> [ 308.298328] [<ffffffff81784179>] tracesys+0xd0/0xd5
> [ 308.298335] Code: e5 d6 ff ff 83 3d be 24 00 00 04 89 c2 4c 8b 45 b0
> 44 8b 4d b8 0f 8f 20 02 00 00 85 d2 75 32 83 83 78 03 00 00 01 4b 8b
> 44 c5 48 <8b> 88 60 02 00 00 85 c9 0f 84 b0 00 00 00 8b 40 58 89 c2 41
> 89
> [ 308.298487] RIP [<ffffffffa07a9fd2>] vb2_perform_fileio+0x372/0x610
> [videobuf2_core]
> [ 308.298507] RSP <ffff88014dc03df8>
> [ 308.298514] CR2: 0000000000000260
> [ 308.298526] ---[ end trace e8f01717c96d1e41 ]---
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 9fc4bab..3a961ee 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2588,8 +2588,15 @@ int vb2_fop_release(struct file *file)
>   	struct video_device *vdev = video_devdata(file);
>   
>   	if (file->private_data == vdev->queue->owner) {
> +		struct mutex *lock;
> +
> +		lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> +		if (lock)
> +			mutex_lock(lock);
>   		vb2_queue_release(vdev->queue);
>   		vdev->queue->owner = NULL;
> +		if (lock)
> +			mutex_unlock(lock);
>   	}
>   	return v4l2_fh_release(file);
>   }

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland

