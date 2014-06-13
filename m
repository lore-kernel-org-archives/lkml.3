Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaFMRac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:30:32 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:32857 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaFMRa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:30:29 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH 0/2] block: virtio-blk: support multi vq per virtio-blk
Date: Sat, 14 Jun 2014 01:29:20 +0800
Message-Id: <1402680562-8328-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patches try to support multi virtual queues(multi-vq) in one
virtio-blk device, and maps each virtual queue(vq) to blk-mq's
hardware queue.

With this approach, both scalability and performance problems on
virtio-blk device get improved.

For verifying the improvement, I implements virtio-blk multi-vq over
qemu's dataplane feature, and both handling host notification
from each vq and processing host I/O are still kept in the per-device
iothread context, the changes are based on qemu v2.0.0 release, and
can be accessed from below tree:

	git://kernel.ubuntu.com/ming/qemu.git #v2.0.0-virtblk-dataplane-mq

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
- without mutli-vq feature
	-- jobs=2, thoughput: 186K iops
	-- jobs=4, thoughput: 199K iops

2), about thoughput
- without mutli-vq feature
	-- top thoughput: 145K iops
- with mutli-vq feature
    -- top thoughput: 199K iops

So even for one quadcore VM, if the virtqueue number is increased
from 1 to 2, both scalability and performance can get improved a
lot.

Thanks,
--
Ming Lei
 

