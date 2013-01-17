Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab3AQB6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:58:24 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:54889 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3AQB6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:58:23 -0500
MIME-Version: 1.0
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Wed, 16 Jan 2013 17:57:52 -0800
Message-ID: <CAPLs8y8JFGEgB8Hhig66D0_+QTwBWsVGe9aq-pQNx_YWAkd+6A@mail.gmail.com>
Subject: does io_cancel always return -EAGAIN?
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is io_cancel implemented by drivers the Linux kernel?

io_cancel depends on kiocb->ki_cancel being set:
- https://github.com/torvalds/linux/blob/v3.7/fs/aio.c#L1734


Seems that ki_cancel is only set by some usb/gadget code:

http://livegrep.com/search?q=ki_cancel

$ git grep ki_cancel
  drivers/usb/gadget/inode.c:     iocb->ki_cancel = ep_aio_cancel;
  fs/aio.c:               cancel = iocb->ki_cancel;
  fs/aio.c:       req->ki_cancel = NULL;
  fs/aio.c:       req->ki_cancel = NULL;
  fs/aio.c:       if (kiocb && kiocb->ki_cancel) {
  fs/aio.c:               cancel = kiocb->ki_cancel;
  include/linux/aio.h:    int                     (*ki_cancel)(struct
kiocb *, struct io_event *);




======

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <libaio.h>

int main(int argc, char* argv[]) {
  io_context_t ctx;
  int fd = open("/proc/self/exe", O_RDONLY);

  int rc = io_queue_init(10, &ctx);
  if (rc != 0) {
    fprintf(stderr, "io_queue_init: %s\n", strerror(-rc));
    return 1;
  }

  struct iocb cb;
  struct iocb* pcb = &cb;

  char buf[4096];
  // read 4K from the start of the file
  io_prep_pread(&cb, fd, buf, sizeof(buf), 0);
  rc = io_submit(ctx, 1, &pcb);
  if (rc != 1) {
    fprintf(stderr, "io_submit: %s\n", strerror(-rc));
    return 1;
  }

  io_event event;
  rc = io_cancel(ctx, &cb, &event);
  if (rc != 0) {
    fprintf(stderr, "io_cancel: %s\n", strerror(-rc));
    // fall through to show that the read operation was correct
    // return 1;
  }

  rc = io_getevents(ctx, 1, 1, &event, NULL);
  if (rc != 1) {
    fprintf(stderr, "io_getevents: %s\n", strerror(-rc));
    return 1;
  }


  if (event.obj != &cb) {
    fprintf(stderr, "io_getevents: unknown cb\n");
    return -1;
  }

  if (event.res != sizeof(buf)) {
    fprintf(stderr, "io_getevents: didn't read all what we requested\n");
    return -1;
  }

  rc = io_queue_release(ctx);
  if (rc != 0) {
    fprintf(stderr, "io_queue_release: %s\n", strerror(-rc));
    return 1;
  }
  return 0;
}

======


Relevant output from strace:

  open("/proc/self/exe", O_RDONLY)        = 3
  io_setup(10, {140328162443264})         = 0
  io_submit(140328162443264, 1, {{(nil), 0, 0, 0, 3}}) = 1
  io_cancel(140328162443264, {(nil), 0, 0, 0, 3}, {...}) = -1 EINVAL
(Invalid argument)
  write(2, "io_cancel: Invalid argument\n", 28io_cancel: Invalid argument) = 28
  io_getevents(140328162443264, 1, 1, {{(nil), 0x7fff41536a60, 4096,
0}}, NULL) = 1
  io_destroy(140328162443264)             = 0

--
 .
..: Lucian
