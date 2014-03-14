Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbaCNK4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:56:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42409 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaCNK4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:56:33 -0400
Date: Fri, 14 Mar 2014 10:56:28 +0000
From: =?iso-8859-1?Q?Lu=EDs?= Henriques <luis.henriques@canonical.com>
To: Christian Borntraeger <christian@borntraeger.net>
Cc: stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: 3.10.33 stable lockdep warning
Message-ID: <20140314105628.GA3117@hercules>
References: <5321B378.9000603@borntraeger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5321B378.9000603@borntraeger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 02:32:40PM +0100, Christian Borntraeger wrote:
> 3.10.33 spits the following warning:
> 
> [   14.463408] ------------[ cut here ]------------
> [   14.463411] WARNING: at block/elevator.c:193
> [   14.463413] Modules linked in: vhost_net macvtap macvlan kvm dasd_eckd_mod dasd_mod zfcp scsi_transport_fc scsi_tgt qeth qdio ccwgroup dm_multipath sunrpc
> [   14.463430] CPU: 10 PID: 18762 Comm: dasdconf.sh Tainted: G        W    3.10.33+ #344
> [   14.463433] task: 00000004a4020000 ti: 00000004cfca8000 task.ti: 00000004cfca8000
> [   14.463435] Krnl PSW : 0704c00180000000 00000000003c6d56 (elevator_init+0xfe/0x144)
> [   14.463441]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:3
> Krnl GPRS: 0000000000000000 00000004a4020000 0000000000000000 00000004d199f028
> [   14.463446]            000000000019b4ae 0000000000000f13 0000000000000000 00000004ddcbb038
> [   14.463449]            00000004ddcbb000 ffffffff00000000 00000004bfcfd850 00000004b820c800
> [   14.463451]            000003ff801bcd2a 00000004d199e440 00000000003c6d4c 00000004cfcabb10
> [   14.463460] Krnl Code: 00000000003c6d46: c0e5ffeea38f	brasl	%r14,19b464
>            00000000003c6d4c: ec26ff9f007e	cij	%r2,0,6,3c6c8a
>           #00000000003c6d52: a7f40001		brc	15,3c6d54
>           >00000000003c6d56: a7f4ff9a		brc	15,3c6c8a
>            00000000003c6d5a: c020008b0327	larl	%r2,15273a8
>            00000000003c6d60: a7390000		lghi	%r3,0
>            00000000003c6d64: c0e5fffffb58	brasl	%r14,3c6414
>            00000000003c6d6a: b9040012		lgr	%r1,%r2
> [   14.463481] Call Trace:
> [   14.463482] ([<00000000003c6d4c>] elevator_init+0xf4/0x144)
> [   14.463486]  [<000003ff801b4daa>] dasd_change_state+0x36a/0xbe0 [dasd_mod]
> [   14.463492]  [<000003ff801b56b6>] dasd_set_target_state+0x96/0x110 [dasd_mod]
> [   14.463498]  [<000003ff801b5bc8>] dasd_generic_set_online+0xc4/0x2e4 [dasd_mod]
> [   14.463503]  [<00000000004d2ecc>] ccw_device_set_online+0xcc/0x4e0
> [   14.463507]  [<00000000004d3336>] online_store_recog_and_online+0x56/0x12c
> [   14.463510]  [<00000000004d58fa>] online_store+0x1b2/0x248
> [   14.463514]  [<00000000002f1b38>] sysfs_write_file+0xe4/0x188
> [   14.463517]  [<0000000000270a26>] vfs_write+0xa6/0x1cc
> [   14.463520]  [<0000000000270f68>] SyS_write+0x60/0xac
> [   14.463523]  [<0000000000636a9c>] sysc_nr_ok+0x22/0x28
> [   14.463526]  [<000003fffd6a8984>] 0x3fffd6a8984
> [   14.463529] 4 locks held by dasdconf.sh/18762:
> [   14.463531]  #0:  (sb_writers#3){.+.+.+}, at: [<0000000000270b3e>] vfs_write+0x1be/0x1cc
> [   14.463539]  #1:  (&buffer->mutex){+.+.+.}, at: [<00000000002f1a9a>] sysfs_write_file+0x46/0x188
> [   14.463546]  #2:  (s_active#28){.+.+.+}, at: [<00000000002f1b16>] sysfs_write_file+0xc2/0x188
> [   14.463554]  #3:  (&device->state_mutex){+.+.+.}, at: [<000003ff801b566c>] dasd_set_target_state+0x4c/0x110 [dasd_mod]
> [   14.463563] Last Breaking-Event-Address:
> [   14.463565]  [<00000000003c6d52>] elevator_init+0xfa/0x144
> [   14.463568] ---[ end trace 3ec4802a2d4e0d3e ]---
> 
> So I guess we should pull in
> commit ef0899410ff630b2e75306da49996dbbfa318165
> Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
> AuthorDate: Thu Oct 31 13:24:28 2013 +0100
> Commit:     Jens Axboe <axboe@kernel.dk>
> CommitDate: Fri Nov 8 09:10:29 2013 -0700
> 
>     s390/dasd: hold request queue sysfs lock when calling elevator_init()
> 
> for 3.10.34 or later.
> I can confirm that this patch fixes the issue.
> Thanks
> 
> Christian
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks Christian, I will queue this patch for the 3.11 kernel.

Cheers,
--
Luís
