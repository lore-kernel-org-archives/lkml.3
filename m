Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaFZHq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbaFZHq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:46:28 -0400
Date: Thu, 26 Jun 2014 10:46:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/2] block: virtio-blk: support multi vq per virtio-blk
Message-ID: <20140626074645.GB21823@redhat.com>
References: <1403748526-1923-1-git-send-email-ming.lei@canonical.com>
 <53ABAA34.6070006@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ABAA34.6070006@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:05:56PM -0600, Jens Axboe wrote:
> On 2014-06-25 20:08, Ming Lei wrote:
> >Hi,
> >
> >These patches try to support multi virtual queues(multi-vq) in one
> >virtio-blk device, and maps each virtual queue(vq) to blk-mq's
> >hardware queue.
> >
> >With this approach, both scalability and performance on virtio-blk
> >device can get improved.
> >
> >For verifying the improvement, I implements virtio-blk multi-vq over
> >qemu's dataplane feature, and both handling host notification
> >from each vq and processing host I/O are still kept in the per-device
> >iothread context, the change is based on qemu v2.0.0 release, and
> >can be accessed from below tree:
> >
> >	git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-mq.1
> >
> >For enabling the multi-vq feature, 'num_queues=N' need to be added into
> >'-device virtio-blk-pci ...' of qemu command line, and suggest to pass
> >'vectors=N+1' to keep one MSI irq vector per each vq, and the feature
> >depends on x-data-plane.
> >
> >Fio(libaio, randread, iodepth=64, bs=4K, jobs=N) is run inside VM to
> >verify the improvement.
> >
> >I just create a small quadcore VM and run fio inside the VM, and
> >num_queues of the virtio-blk device is set as 2, but looks the
> >improvement is still obvious.
> >
> >1), about scalability
> >- without mutli-vq feature
> >	-- jobs=2, thoughput: 145K iops
> >	-- jobs=4, thoughput: 100K iops
> >- with mutli-vq feature
> >	-- jobs=2, thoughput: 193K iops
> >	-- jobs=4, thoughput: 202K iops
> >
> >2), about thoughput
> >- without mutli-vq feature
> >	-- thoughput: 145K iops
> >- with mutli-vq feature
> >	-- thoughput: 202K iops
> 
> Of these numbers, I think it's important to highlight that the 2 thread case
> is 33% faster and the 2 -> 4 thread case scales linearly (100%) while the
> pre-patch case sees negative scaling going from 2 -> 4 threads (-39%).
> 
> I haven't run your patches yet, but from looking at the code, it looks good.
> It's pretty straightforward. See feel free to add my reviewed-by.
> 
> Rusty, do you want to ack this (and I'll slurp it up for 3.17)

Looks like I found some issues, so not yet pls.

> or take this
> yourself? Or something else?
> 
> 
> -- 
> Jens Axboe
