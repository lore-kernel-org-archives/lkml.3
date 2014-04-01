Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaDAUSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:18:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40017 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaDAUSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:18:15 -0400
MIME-Version: 1.0
X-Originating-IP: [79.136.121.101]
Date: Tue, 1 Apr 2014 22:18:13 +0200
Message-ID: <CABt9es_uq1ixwcyHcL8ptYi2fXQjVFHvaOp71uu2epoQk_ToPw@mail.gmail.com>
Subject: Crash in rbd, need advice
From: Hannes Landeholm <hannes@jumpstarter.io>
To: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, sage@inktank.com,
        Sage Weil <sage@newdream.net>, Alex Elder <elder@inktank.com>,
        Yehuda Sadeh <yehuda@hq.newdream.net>
Cc: Thorwald Lundqvist <thorwald@jumpstarter.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We're running a couple of Arch Linux servers of version 3.13.5-1 in
production and suddenly one of them had a strange problem after
running for a few days. One process (pid 319) was running with a few
threads, one of those threads (pid 322) was eating 100% cpu. I assumed
it was stuck in an infinite loop (this was our own software so I
assumed we had a bug) so I sent a SIGKILL to 319 which caused all
other threads to exit and it turning into a zombie, but thread 322 was
still running. After trying to stop some other services and failing I
realized that sending any signals to any process now didn't work at
all in the system.

This was the process stack output:

$ cat /proc/319/stack
[<ffffffff810642fa>] do_exit+0x73a/0xa80
[<ffffffff810646bf>] do_group_exit+0x3f/0xa0
[<ffffffff81073295>] get_signal_to_deliver+0x295/0x5f0
[<ffffffff810144a8>] do_signal+0x48/0x950
[<ffffffff81014e18>] do_notify_resume+0x68/0xa0
[<ffffffff8152326a>] int_signal+0x12/0x17
[<ffffffffffffffff>] 0xffffffffffffffff
$ cat /proc/319/task/322/stack
[<ffffffff8151c11a>] error_exit+0x2a/0x60
[<ffffffffffffffff>] 0xffffffffffffffff

We're using ceph + rbd and this happened right after doing a rbd
mapping (mounting it) or during the mapping itself, so we suspected
rbd.

A few days later (today) we had a server crash in another server, same
version+distro and it had also just been running a few days as well.
After starting it again we found the following in the system log:

hostname kernel: BUG: unable to handle kernel paging request at ffff87fff75ad450
hostname kernel: IP: [<ffffffffa018c196>] rbd_img_request_fill+0x126/0x930 [rbd]

We compile the kernel ourselves but is only using standard arch
patches. We're also doing a lot of automatic rbd mappings and
unmappings, probably 1000s every day on each server. The machines in
question have 4 cores and we're using a ceph cluster with 6 OSDs
currently.

This problem seem to be correlated with an upgrade we did last week
from running 3.12.9 and 1 core to 3.13.5 and running 4 cores.

Unfortunately we have not had time or ability to reproduce the
problem, but I would appreciate any advice on how to proceed in any
way that allows us to contribute so the problem can be fixed as it
will inevitably happen again. Right now we're considering building the
kernel with debug support and configuring it so it can do a kernel
dump. It would also be interesting to hear any speculation from a
person with more knowledge of the kernel and/or rbd.

Thank you for your time,
--
Hannes Landeholm
Co-founder & CTO
Jumpstarter - www.jumpstarter.io

☎ +46 72 301 35 62
