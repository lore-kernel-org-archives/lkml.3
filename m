Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaANNai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:30:38 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54301 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaANNaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:30:35 -0500
MIME-Version: 1.0
In-Reply-To: <20140108140307.GA588@infradead.org>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz> <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com> <20140108140307.GA588@infradead.org>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Tue, 14 Jan 2014 15:30:11 +0200
Message-ID: <CA+QCeVRuvNtZ8+9D-NtMOD=B9UEA5HMvKaGdXOQCjO-KTnZdbw@mail.gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gluk <git.user@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cristoph,

On 8 January 2014 16:03, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 07, 2014 at 08:37:23PM +0200, Sergey Meirovich wrote:
>> Actually my initial report (14.67Mb/sec  3755.41 Requests/sec) was about ext4
>> However I have tried XFS as well. It was a bit slower than ext4 on all
>> occasions.
>
> I wasn't trying to say XFS fixes your problem, but that we could
> implement appending AIO writes in XFS fairly easily.
>
> To verify Jan's theory, can you try to preallocate the file to the full
> size and then run the benchmark by doing a:
>
> # fallocate -l <size> <filename>
>
> and then run it?  If that's indeed the issue I'd be happy to implement
> the "real aio" append support for you as well.
>

I've resorted to write simple wrapper around io_submit() and ran it
against preallocated file (exactly to avoid append AIO scenario).
Random data was used to avoid XtremIO online deduplication but results
were still wonderfull for 4k sequential AIO write:

744.77 MB/s   190660.17 Req/sec

Clearly Linux lacks "rial aio" append to be available for any FS.
Seems that you are thinking that it would be relatively easy to
implement it for XFS on Linux? If so - I will really appreciate your
afford.

[root@dca-poc-gtsxdb3 mnt]# dd if=/dev/zero of=4k.data bs=4096 count=524288
524288+0 records in
524288+0 records out
2147483648 bytes (2.1 GB) copied, 5.75357 s, 373 MB/s
[root@dca-poc-gtsxdb3 mnt]# /root/4k
rnd generation (sec.):    195.63
io_submit() accepted 524288 IOs
io_getevents() returned 524288 events
time elapsed (sec.):        2.75
bandwidth (MiB/s):        744.77
IOps:                                     190660.17
[root@dca-poc-gtsxdb3 mnt]#

========================== io_submit() wrapper =============================
#define _GNU_SOURCE

#include <errno.h>
#include <libaio.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>
#include <sys/time.h>


#define FNAME           "4k.data"
#define IOSIZE          4096
#define    REQUESTS    524288

/*  gcc 4k.c -std=gnu99 -laio -o 4k */

int main(void) {
    io_context_t ctx;
    int ret;

    int flag = O_RDWR | O_DIRECT;
    int fd = open(FNAME, flag);
    struct timeval start, end;
        if (fd == -1) {
        printf("open(%s, %d) - failed!\nExiting.\n"
        "If file doesn't exist please precreate it "
        "with dd if=/dev/zero of=%s bs=%d count=%d\n",
        FNAME, flag, FNAME, IOSIZE, REQUESTS);
                return errno;
        }

    memset(&ctx, 0, sizeof(io_context_t));
    if (io_setup(REQUESTS, &ctx)) {
        printf("io_setup(%d, &ctx) failed\n", REQUESTS);
        return -ret;
    }

    void *mem = NULL;
    posix_memalign(&mem, 4096, (size_t) IOSIZE * REQUESTS);
    /* memset(mem, 9, IOSIZE); */
    int urnd = open("/dev/urandom", O_RDONLY);
    void *cur = mem;
    gettimeofday(&start, NULL);
    for (int i = 0;  i < REQUESTS; i++, cur += IOSIZE) {
        read(urnd, cur, IOSIZE);
    }
    gettimeofday(&end, NULL);
    close(urnd);
    double elapsed = (end.tv_sec - start.tv_sec) +
              ((end.tv_usec - start.tv_usec)/1000000.0);
    printf("rnd generation (sec.):\t%.2f\n", elapsed);

    struct iocb *aio = malloc(sizeof(struct iocb) * REQUESTS);
    memset(aio, 0, sizeof(struct iocb) * REQUESTS);
    struct iocb **lio = malloc(sizeof(void *) * REQUESTS);
    memset(lio, 0, sizeof(void *) * REQUESTS);
    struct io_event *event = malloc(sizeof(struct io_event) * REQUESTS);
    memset(event, 0, sizeof(struct io_event) * REQUESTS);

    cur = mem;
    for (int i = 0; i < REQUESTS; i++, cur += IOSIZE) {
        io_prep_pwrite(&aio[i], fd, cur, IOSIZE, i * IOSIZE);
        lio[i] = &aio[i];
    }
    gettimeofday(&start, NULL);
    ret = io_submit(ctx, REQUESTS, lio);
    printf("io_submit() accepted %d IOs\n", ret);
    fdatasync(fd);

    ret = io_getevents(ctx, REQUESTS, REQUESTS, event, NULL);
    printf("io_getevents() returned %d events\n", ret);
    gettimeofday(&end, NULL);

    elapsed = (end.tv_sec - start.tv_sec) +
              ((end.tv_usec - start.tv_usec)/1000000.0);
    printf("time elapsed (sec.):\t%.2f\n", elapsed);
        printf("bandwidth (MiB/s):\t%.2f\n",
        (double) (((long long) IOSIZE * REQUESTS) / (1024 * 1024))
            / elapsed);
        printf("IOps:\t\t\t%.2f\n", (double) REQUESTS
            / elapsed);

    if (io_destroy(ctx)) {
                perror("io_destroy");
                return -1;
        }
    close(fd);
    free(mem);
    free(aio);
    free(lio);
    free(event);

    return 0;
}
