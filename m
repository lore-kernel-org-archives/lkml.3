Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbaFZCJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:09:05 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41212 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbaFZCJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:09:03 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Thu, 26 Jun 2014 10:08:44 +0800
Message-Id: <1403748526-1923-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches try to support multi virtual queues(multi-vq) in one
virtio-blk device, and maps each virtual queue(vq) to blk-mq's
hardware queue.

With this approach, both scalability and performance on virtio-blk
device can get improved.

For verifying the improvement, I implements virtio-blk multi-vq over
qemu's dataplane feature, and both handling host notification
from each vq and processing host I/O are still kept in the per-device
iothread context, the change is based on qemu v2.0.0 release, and
can be accessed from below tree:

	git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-mq.1

For enabling the multi-vq feature, 'num_queues=N' need to be added into
'-device virtio-blk-pci ...' of qemu command line, and suggest to pass
'vectors=N+1' to keep one MSI irq vector per each vq, and the feature
depends on x-data-plane.

Fio(libaio, randread, iodepth=64, bs=4K, jobs=N) is run inside VM to
verify the improvement.

I just create a small quadcore VM and run fio inside the VM, and
num_queues of the virtio-blk device is set as 2, but looks the
improvement is still obvious.

1), about scalability
- without mutli-vq feature
	-- jobs=2, thoughput: 145K iops
	-- jobs=4, thoughput: 100K iops
- with mutli-vq feature
	-- jobs=2, thoughput: 193K iops
	-- jobs=4, thoughput: 202K iops

2), about thoughput
- without mutli-vq feature
	-- thoughput: 145K iops
- with mutli-vq feature
	-- thoughput: 202K iops

So in my test, even for a quad-core VM, if the virtqueue number
is increased from 1 to 2, both scalability and performance can
get improved a lot.

TODO:
	- adjust vq's irq smp_affinity according to blk-mq hw queue's cpumask

V2: (suggestions from Michael and Dave Chinner)
	- allocate virtqueues' pointers dynamically
	- make sure the per-queue spinlock isn't kept in same cache line
	- make each queue's name different

V1:
	- remove RFC since no one objects
	- add '__u8 unused' for pending as suggested by Rusty
	- use virtio_cread_feature() directly, suggested by Rusty

Thanks,
--
Ming Lei


