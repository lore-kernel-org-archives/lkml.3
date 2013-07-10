Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3GJLAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:00:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39271 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3GJLAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:00:43 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 0/2] virtio tools: build failure
Date: Wed, 10 Jul 2013 16:26:58 +0530
Message-Id: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is actually a bug report.  As you can see, I tried fixing the
build but failed.  The problem is that the vringh_test target was
added by:

  1515c5c (tools/virtio: add vring_test, 2013-03-20)

but then

  f558a84 (Add missing module license tag to vring helpers, 2013-05-03)

broke the build by adding a MODULE_LICENSE that is undefined for the
purposes of virtio tools.  I tried moving the definition of
MODULE_LICENSE from virtio.h to module.h, but then the build failed
with multiple __MODULE_LICENSE_name declarations.  After trying
several things, I decided to revert f558a84: that builds vringh
successfully.  Unfortunately, vhost_test doesn't build with tons of
errors:

make -C `pwd`/../.. M=`pwd`/vhost_test
make[1]: Entering directory `/home/artagnon/src/linux'
  CC [M]  /home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.o
In file included from /home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.c:1:0:
drivers/vhost/test.c: In function ‘handle_vq’:
drivers/vhost/test.c:41:31: warning: initialization from incompatible pointer type [enabled by default]
  struct vhost_virtqueue *vq = &n->dev.vqs[VHOST_TEST_VQ];
                               ^
drivers/vhost/test.c: In function ‘vhost_test_open’:
drivers/vhost/test.c:112:2: warning: passing argument 2 of ‘vhost_dev_init’ from incompatible pointer type [enabled by default]
  r = vhost_dev_init(dev, n->vqs, VHOST_TEST_VQ_MAX);
  ^
In file included from drivers/vhost/test.c:21:0,
                 from /home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.c:1:
drivers/vhost/vhost.c:283:6: note: expected ‘struct vhost_virtqueue **’ but argument is of type ‘struct vhost_virtqueue *’
 long vhost_dev_init(struct vhost_dev *dev,
      ^
In file included from /home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.c:1:0:
drivers/vhost/test.c: In function ‘vhost_test_flush_vq’:
drivers/vhost/test.c:143:37: error: request for member ‘poll’ in something not a structure or union
  vhost_poll_flush(&n->dev.vqs[index].poll);
                                     ^
drivers/vhost/test.c: In function ‘vhost_test_ioctl’:
drivers/vhost/test.c:271:14: error: ‘VHOST_NET_FEATURES’ undeclared (first use in this function)
   features = VHOST_NET_FEATURES;
              ^
drivers/vhost/test.c:271:14: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [/home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.o] Error 1
make[1]: *** [_module_/home/artagnon/src/linux/tools/virtio/vhost_test] Error 2
make[1]: Leaving directory `/home/artagnon/src/linux'
make: *** [mod] Error 2

I just gave up trying to fix the build, and thought I should atleast
submit a bug report.  Maybe I'm missing something?

Thanks.

Ramkumar Ramachandra (2):
  virtio tools: strip bad include-path from Makefile
  virtio tools: add .gitignore

 tools/virtio/.gitignore | 3 +++
 tools/virtio/Makefile   | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 tools/virtio/.gitignore

-- 
1.8.3.2.736.g869de25

