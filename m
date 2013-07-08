Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3GHV0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 17:26:32 -0400
Received: from mx-out.ocsa-data.net ([194.36.166.37]:53857 "EHLO
	mx-out.ocsa-data.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GHV03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 17:26:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 08 Jul 2013 23:26:26 +0200
From: Yann Droneaud <ydroneaud@opteya.com>
To: Roland Dreier <roland@purestorage.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        ydroneaud@opteya.com
Subject: Re: [PATCH 03/13] infiniband: use =?UTF-8?Q?get=5Funused=5Ffd=5Ff?=
 =?UTF-8?Q?lags=28=30=29=20instead=20of=20get=5Funused=5Ffd=28=29?=
Organization: OPTEYA
In-Reply-To: <CAL1RGDXV1_BjSLrQDFdVQ1_D75+bMtOtikHOUp8VBiy_OJUf=w@mail.gmail.com>
References: <cover.1372777600.git.ydroneaud@opteya.com>
 <651e35493f6a970610d35785e1972ec9e2426abf.1372777600.git.ydroneaud@opteya.com>
 <CAL1RGDXV1_BjSLrQDFdVQ1_D75+bMtOtikHOUp8VBiy_OJUf=w@mail.gmail.com>
Message-ID: <f58540dc64fec1ac0e496dfcd3cc1af7@meuh.org>
User-Agent: Roundcube Webmail/0.9.2
X-abuse-contact: abuse@ocsa-data.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 08.07.2013 20:23, Roland Dreier a écrit :
> Thanks, I just applied a patch to convert to
> get_unused_fd_flags(O_CLOEXEC) in uverbs, since there isn't anything
> useful that can be done with uverbs fds across an exec.
> 

Thanks.

In fact, InfiniBand was my main target and I kept this change (setting 
O_CLOEXEC)
for another batch.

It's following my patch on libibverbs "[PATCH] open files with close on 
exec flag"
http://thread.gmane.org/gmane.linux.drivers.rdma/15727
http://marc.info/?l=linux-rdma&m=136908991102575&w=2

This patch was already quoting Dan Walsh, "Excuse me son, but your code 
is leaking !!!"
http://danwalsh.livejournal.com/53603.html but I couldn't resist to post 
it again.

BTW, I was working on the rationnal/commit message for setting flags to 
O_CLOEXEC
on kernel side, please find the draft if revelant.

--------------------8<----------------------

InfiniBand verbs/RDMA: use O_CLOEXEC

This subsystem is allocating new file descriptor through the InfiniBand 
verbs / RDMA API.

Thoses file descriptors are created after a write() from userspace to a 
special device file.
No read operation is needed to get the file descriptor: it is returned 
to userspace
in a buffer whose address was stored as part of the buffer passed to 
write().
If the write() succeed, the response buffer is updated and the new file 
descriptor is available.

But such file descriptors are mostly hidden to application developpers
by libibverbs / librdma_cm libraries API.
In fact, application developpers could use InfiniBand verbs / RDMA 
without
using directly the file descriptors.

Here's how are created the two file descriptors (using mlx4 as example):

- ibv_context.async_fd:

   ---- kernel ----

   ib_uverbs_get_context() : linux/drivers/infiniband/core/uverbs_cmd.c
   uverbs_cmd_table[IB_USER_VERBS_CMD_GET_CONTEXT]() : 
linux/drivers/infiniband/core/uverbs_main.c
   ib_uverbs_write() : linux/drivers/infiniband/core/uverbs_main.c
   uverbs_mmap_fops.write : linux/drivers/infiniband/core/uverbs_main.c

   ---- userspace ----

   ibv_cmd_get_context() : libibverbs/src/cmd.c
   mlx4_alloc_context() : libmlx4/src/mlx4.c
   mlx4_dev_ops.alloc_context : libmlx4/src/mlx4.c
   __ibv_open_device() : libibverbs/src/device.c

- ibv_comp_channel.fd:

   ---- kernel ----

   ib_uverbs_create_comp_channel() : 
linux/drivers/infiniband/core/uverbs_cmd.c
   uverbs_cmd_table[IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL]() : 
linux/drivers/infiniband/core/uverbs_main.c
   ib_uverbs_write() : linux/drivers/infiniband/core/uverbs_main.c
   uverbs_mmap_fops.write : linux/drivers/infiniband/core/uverbs_main.c

   ---- userspace ----

   ibv_create_comp_channel() : libibverbs/src/verbs.c

But those file descriptors are of no use for another program executed 
through exec():

- without the memory mappings for special memory pages,
   the file descriptor are of no use ...

- the userland libraries/drivers are not ready to
   found the devices already opened.

[ In fact, supporting fork() is already a challenge for thoses API. ]

So those file descriptors can safely be opened with O_CLOEXEC without
disturbing users of InfiniBand verbs /RDMA


--------------------8<----------------------


Regards.

-- 
Yann Droneaud
OPTEYA

