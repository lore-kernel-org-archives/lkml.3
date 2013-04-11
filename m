Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3DKLVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:21:51 -0400
Received: from relay.parallels.com ([195.214.232.42]:54368 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3DKLVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:21:50 -0400
Message-ID: <51669CDF.9090705@parallels.com>
Date: Thu, 11 Apr 2013 15:22:07 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "miklos@szeredi.hu" <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [fuse-devel] [PATCH v2 0/6] fuse: process direct IO asynchronously
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
In-Reply-To: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

Any feedback would be highly appreciated.

Thanks,
Maxim

12/14/2012 07:20 PM, Maxim V. Patlasov пишет:
> Hi,
>
> Existing fuse implementation always processes direct IO synchronously: it
> submits next request to userspace fuse only when previous is completed. This
> is suboptimal because: 1) libaio DIO works in blocking way; 2) userspace fuse
> can't achieve parallelism  processing several requests simultaneously (e.g.
> in case of distributed network storage); 3) userspace fuse can't merge
> requests before passing it to actual storage.
>
> The idea of the patch-set is to submit fuse requests in non-blocking way
> (where it's possible) and either return -EIOCBQUEUED or wait for their
> completion synchronously. The patch-set to be applied on top of for-next of
> Miklos' git repo.
>
> To estimate performance improvement I used slightly modified fusexmp over
> tmpfs (clearing O_DIRECT bit from fi->flags in xmp_open). For synchronous
> operations I used 'dd' like this:
>
> dd of=/dev/null if=/fuse/mnt/file bs=2M count=256 iflag=direct
> dd if=/dev/zero of=/fuse/mnt/file bs=2M count=256 oflag=direct conv=notrunc
>
> For AIO I used 'aio-stress' like this:
>
> aio-stress -s 512 -a 4 -b 1 -c 1 -O -o 1 /fuse/mnt/file
> aio-stress -s 512 -a 4 -b 1 -c 1 -O -o 0 /fuse/mnt/file
>
> The throughput on some commodity (rather feeble) server was (in MB/sec):
>
>               original / patched
>
> dd reads:    ~322     / ~382
> dd writes:   ~277     / ~288
>
> aio reads:   ~380     / ~459
> aio writes:  ~319     / ~353
>
> Changed in v2 - cleanups suggested by Brian:
>   - Updated fuse_io_priv with an async field and file pointer to preserve
>     the current style of interface (i.e., use this instead of iocb).
>   - Trigger the type of request submission based on the async field.
>   - Pulled up the fuse_write_update_size() call out of __fuse_direct_write()
>     to make the separate paths more consistent.
>
> Thanks,
> Maxim
>
> ---
>
> Maxim V. Patlasov (6):
>        fuse: move fuse_release_user_pages() up
>        fuse: add support of async IO
>        fuse: make fuse_direct_io() aware about AIO
>        fuse: enable asynchronous processing direct IO
>        fuse: truncate file if async dio failed
>        fuse: optimize short direct reads
>
>
>   fs/fuse/cuse.c   |    6 +
>   fs/fuse/file.c   |  290 +++++++++++++++++++++++++++++++++++++++++++++++-------
>   fs/fuse/fuse_i.h |   19 +++-
>   3 files changed, 276 insertions(+), 39 deletions(-)
>

