Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaE3HAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:00:48 -0400
Received: from ozlabs.org ([103.22.144.67]:44116 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaE3HAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:00:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] virtio_ring: unify direct/indirect code paths.
In-Reply-To: <87d2ew6lfr.fsf@rustcorp.com.au>
References: <87oayh6s3s.fsf@rustcorp.com.au> <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au> <1401348405-18614-5-git-send-email-rusty@rustcorp.com.au> <20140529112905.GD30210@redhat.com> <87d2ew6lfr.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 30 May 2014 15:51:35 +0930
Message-ID: <874n077pn4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
>> On Thu, May 29, 2014 at 04:56:45PM +0930, Rusty Russell wrote:
>>> virtqueue_add() populates the virtqueue descriptor table from the sgs
>>> given.  If it uses an indirect descriptor table, then it puts a single
>>> descriptor in the descriptor table pointing to the kmalloc'ed indirect
>>> table where the sg is populated.
>>> +	for (i = 0; i < total_sg; i++)
>>> +		desc[i].next = i+1;
>>> +	return desc;
>>
>> Hmm we are doing an extra walk over descriptors here.
>> This might hurt performance esp for big descriptors.
>
> Yes, this needs to be benchmarked; since it's cache hot my gut feel is
> that it's a NOOP, but on modern machines my gut feel is always wrong.

CC's trimmed.

Well, I was almost right about being wrong.

I wrote a userspace virtio_ring microbench which does 10000000
virtqueue_add_outbuf() calls (which go indirect) and not much else.

Read as <MIN>-<MAX>(<MEAN>+/-<STDDEV>):
Current kernel:           936153354- 967745359(9.44739e+08+/-6.1e+06)ns
Using sg_next:           1061485790-1104800648(1.08254e+09+/-6.6e+06)ns
Unifying indirect path:  1214289435-1272686712(1.22564e+09+/-8e+06)ns
Using indirect flag:     1125610268-1183528965(1.14172e+09+/-8e+06)ns

Of course this might be lost in the noise on real networking, so that's
my job on Monday.

Subject: vring_bench: simple benchmark for adding descriptors to a virtqueue.

This userspace benchark uses the kernel code to add 8 16-element
scatterlists to a virtqueue, then consume them and start again.

For example:
	$ for i in `seq 10`; do ./vring_bench; done | stats --trim-outliers
	936153354-967745359(9.44739e+08+/-6.1e+06)ns
	9999872 returned

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/tools/virtio/.gitignore b/tools/virtio/.gitignore
index 1cfbb0157a46..ff32cca971d8 100644
--- a/tools/virtio/.gitignore
+++ b/tools/virtio/.gitignore
@@ -1,3 +1,4 @@
 *.d
 virtio_test
 vringh_test
+vring_bench
diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index 3187c62d9814..103101273049 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -1,6 +1,7 @@
 all: test mod
-test: virtio_test vringh_test
+test: virtio_test vringh_test vring_bench
 virtio_test: virtio_ring.o virtio_test.o
+vring_bench: virtio_ring.o vring_bench.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
 CFLAGS += -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
@@ -9,6 +10,6 @@ mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test
 .PHONY: all test mod clean
 clean:
-	${RM} *.o vringh_test virtio_test vhost_test/*.o vhost_test/.*.cmd \
+	${RM} *.o vringh_test virtio_test vring_bench vhost_test/*.o vhost_test/.*.cmd \
               vhost_test/Module.symvers vhost_test/modules.order *.d
 -include *.d
diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
index fba705963968..8dcff8e3374c 100644
--- a/tools/virtio/linux/kernel.h
+++ b/tools/virtio/linux/kernel.h
@@ -109,4 +109,7 @@ static inline void free_page(unsigned long addr)
 	(void) (&_min1 == &_min2);		\
 	_min1 < _min2 ? _min1 : _min2; })
 
+/* Just make it compile */
+#define list_for_each_entry(iter, list, member)
+
 #endif /* KERNEL_H */
diff --git a/tools/virtio/vring_bench.c b/tools/virtio/vring_bench.c
new file mode 100644
index 000000000000..0d7544fd26ad
--- /dev/null
+++ b/tools/virtio/vring_bench.c
@@ -0,0 +1,125 @@
+#define _GNU_SOURCE
+#include <time.h>
+#include <getopt.h>
+#include <string.h>
+#include <poll.h>
+#include <sys/eventfd.h>
+#include <stdlib.h>
+#include <assert.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <linux/virtio.h>
+#include <linux/virtio_ring.h>
+
+/* Unused */
+void *__kmalloc_fake, *__kfree_ignore_start, *__kfree_ignore_end;
+
+static struct vring vring;
+static uint16_t last_avail_idx;
+static unsigned int returned;
+
+static bool vq_notify(struct virtqueue *vq)
+{
+	/* "Use" them all. */
+	while (vring.avail->idx != last_avail_idx) {
+		unsigned int i, head;
+
+		i = last_avail_idx++ & (vring.num - 1);
+		head = vring.avail->ring[i];
+		assert(head < vring.num);
+
+		i = vring.used->idx & (vring.num - 1);
+		vring.used->ring[i].id = head;
+		vring.used->ring[i].len = 0;
+		vring.used->idx++;
+	}
+	return true;
+}
+
+static void vq_callback(struct virtqueue *vq)
+{
+	unsigned int len;
+	void *p;
+
+	while ((p = virtqueue_get_buf(vq, &len)) != NULL)
+		returned++;
+}
+
+/* Ring size 128, just like qemu uses */
+#define VRING_NUM 128
+#define SG_SIZE 16
+
+static inline struct timespec time_sub(struct timespec recent,
+				       struct timespec old)
+{
+	struct timespec diff;
+
+	diff.tv_sec = recent.tv_sec - old.tv_sec;
+	if (old.tv_nsec > recent.tv_nsec) {
+		diff.tv_sec--;
+		diff.tv_nsec = 1000000000 + recent.tv_nsec - old.tv_nsec;
+	} else
+		diff.tv_nsec = recent.tv_nsec - old.tv_nsec;
+
+	return diff;
+}
+
+static struct timespec time_now(void)
+{
+	struct timespec ret;
+	clock_gettime(CLOCK_REALTIME, &ret);
+	return ret;
+}
+
+static inline uint64_t time_to_nsec(struct timespec t)
+{
+	uint64_t nsec;
+
+	nsec = t.tv_nsec + (uint64_t)t.tv_sec * 1000000000;
+	return nsec;
+}
+
+int main(int argc, char *argv[])
+{
+	struct virtqueue *vq;
+	struct virtio_device vdev;
+	void *ring;
+	unsigned int i, num;
+	int e;
+	struct scatterlist sg[SG_SIZE];
+	struct timespec start;
+
+	sg_init_table(sg, SG_SIZE);
+
+	e = posix_memalign(&ring, 4096, vring_size(VRING_NUM, 4096));
+	assert(e >= 0);
+
+	vdev.features[0] = (1UL << VIRTIO_RING_F_INDIRECT_DESC) |
+		(1UL << VIRTIO_RING_F_EVENT_IDX);
+
+	vq = vring_new_virtqueue(0, VRING_NUM, 4096, &vdev, true, ring,
+				 vq_notify, vq_callback, "benchmark");
+	assert(vq);
+	vring_init(&vring, VRING_NUM, ring, 4096);
+
+	num = atoi(argv[1] ?: "10000000");
+
+	start = time_now();
+	for (i = 0; i < num; i++) {
+	again:
+		e = virtqueue_add_outbuf(vq, sg, SG_SIZE, sg, GFP_ATOMIC);
+		if (e < 0) {
+			virtqueue_kick(vq);
+			vring_interrupt(0, vq);
+			goto again;
+		}
+	}
+	printf("%lluns\n",
+	       (long long)time_to_nsec(time_sub(time_now(), start)));
+	printf("%u returned\n", returned);
+	return 0;
+}


