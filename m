Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3GJMRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:17:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab3GJMRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:17:02 -0400
Date: Wed, 10 Jul 2013 15:18:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] virtio tools: build failure
Message-ID: <20130710121813.GD11386@redhat.com>
References: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:26:58PM +0530, Ramkumar Ramachandra wrote:
> Hi,
> 
> This is actually a bug report.  As you can see, I tried fixing the
> build but failed.  The problem is that the vringh_test target was
> added by:
> 
>   1515c5c (tools/virtio: add vring_test, 2013-03-20)
> 
> but then
> 
>   f558a84 (Add missing module license tag to vring helpers, 2013-05-03)
> 
> broke the build by adding a MODULE_LICENSE that is undefined for the
> purposes of virtio tools.  I tried moving the definition of
> MODULE_LICENSE from virtio.h to module.h, but then the build failed
> with multiple __MODULE_LICENSE_name declarations.  After trying
> several things, I decided to revert f558a84: that builds vringh
> successfully.  Unfortunately, vhost_test doesn't build with tons of
> errors:
> 
> make -C `pwd`/../.. M=`pwd`/vhost_test
> make[1]: Entering directory `/home/artagnon/src/linux'
>   CC [M]  /home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.o
> In file included from /home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.c:1:0:
> drivers/vhost/test.c: In function ‘handle_vq’:
> drivers/vhost/test.c:41:31: warning: initialization from incompatible pointer type [enabled by default]
>   struct vhost_virtqueue *vq = &n->dev.vqs[VHOST_TEST_VQ];
>                                ^
> drivers/vhost/test.c: In function ‘vhost_test_open’:
> drivers/vhost/test.c:112:2: warning: passing argument 2 of ‘vhost_dev_init’ from incompatible pointer type [enabled by default]
>   r = vhost_dev_init(dev, n->vqs, VHOST_TEST_VQ_MAX);
>   ^
> In file included from drivers/vhost/test.c:21:0,
>                  from /home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.c:1:
> drivers/vhost/vhost.c:283:6: note: expected ‘struct vhost_virtqueue **’ but argument is of type ‘struct vhost_virtqueue *’
>  long vhost_dev_init(struct vhost_dev *dev,
>       ^
> In file included from /home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.c:1:0:
> drivers/vhost/test.c: In function ‘vhost_test_flush_vq’:
> drivers/vhost/test.c:143:37: error: request for member ‘poll’ in something not a structure or union
>   vhost_poll_flush(&n->dev.vqs[index].poll);
>                                      ^
> drivers/vhost/test.c: In function ‘vhost_test_ioctl’:
> drivers/vhost/test.c:271:14: error: ‘VHOST_NET_FEATURES’ undeclared (first use in this function)
>    features = VHOST_NET_FEATURES;
>               ^
> drivers/vhost/test.c:271:14: note: each undeclared identifier is reported only once for each function it appears in
> make[2]: *** [/home/artagnon/src/linux/tools/virtio/vhost_test/vhost_test.o] Error 1
> make[1]: *** [_module_/home/artagnon/src/linux/tools/virtio/vhost_test] Error 2
> make[1]: Leaving directory `/home/artagnon/src/linux'
> make: *** [mod] Error 2
> 
> I just gave up trying to fix the build, and thought I should atleast
> submit a bug report.  Maybe I'm missing something?
> 
> Thanks.
> 
> Ramkumar Ramachandra (2):
>   virtio tools: strip bad include-path from Makefile
>   virtio tools: add .gitignore
> 
>  tools/virtio/.gitignore | 3 +++
>  tools/virtio/Makefile   | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>  create mode 100644 tools/virtio/.gitignore

Right.  I sent a pull request to Linus which fixes some of these errors,
and Rusty queued fixes for the rest.
So you'll be able to build it again once 3.11-rc1 is out.


> -- 
> 1.8.3.2.736.g869de25
