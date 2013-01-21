Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab3AUNZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:25:30 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:40185 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3AUNZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:25:28 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: next-20130117 - kernel BUG with aio
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1358774694_1966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 21 Jan 2013 08:24:54 -0500
Message-ID: <3544.1358774694@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.50FD41A7.00EF,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1358774694_1966P
Content-Type: text/plain; charset=us-ascii

Am seeing a reproducible BUG in the kernel with next-20130117
whenever I fire up VirtualBox.  Unfortunately, I hadn't done that
in a while, so the last 'known good' kernel was next-20121203.

I'm strongly suspecting one of Kent Overstreet's 32 patches against aio,
because 'git blame' shows those landing on Jan 12, and not much else
happening to fs/aio.c in ages.

The stack traceback ring any bells before I go to bisect this?

[  327.375581] BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1138
[  327.375588] in_atomic(): 0, irqs_disabled(): 1, pid: 2096, name: AioMgr0-N
[  327.375590] INFO: lockdep is turned off.
[  327.375593] irq event stamp: 0
[  327.375595] hardirqs last  enabled at (0): [<          (null)>]           (null)
[  327.375599] hardirqs last disabled at (0): [<ffffffff8102d9eb>] copy_process.part.40+0x565/0x14be
[  327.375607] softirqs last  enabled at (0): [<ffffffff8102d9eb>] copy_process.part.40+0x565/0x14be
[  327.375611] softirqs last disabled at (0): [<          (null)>]           (null)
[  327.375616] Pid: 2096, comm: AioMgr0-N Tainted: P           O 3.8.0-rc3-next-20130117-dirty #49
[  327.375618] Call Trace:
[  327.375624]  [<ffffffff810770ba>] ? print_irqtrace_events+0x9d/0xa1
[  327.375630]  [<ffffffff8105a576>] __might_sleep+0x19f/0x1a7
[  327.375635]  [<ffffffff81617ab4>] __do_page_fault+0x2a4/0x57c
[  327.375641]  [<ffffffff810dbb55>] ? invalidate_inode_pages2_range+0x2e0/0x2f8
[  327.375645]  [<ffffffff811843f4>] ? ext4_direct_IO+0x224/0x3c2
[  327.375650]  [<ffffffff81186438>] ? noalloc_get_block_write+0x57/0x57
[  327.375654]  [<ffffffff81182c4d>] ? ext4_readpages+0x41/0x41
[  327.375659]  [<ffffffff810b7caf>] ? time_hardirqs_off+0x1b/0x2f
[  327.375663]  [<ffffffff81615373>] ? error_sti+0x5/0x6
[  327.375667]  [<ffffffff8107522f>] ? trace_hardirqs_off_caller+0x1f/0x9e
[  327.375672]  [<ffffffff8124ad2d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  327.375676]  [<ffffffff81617d95>] do_page_fault+0x9/0xb
[  327.375680]  [<ffffffff81615182>] page_fault+0x22/0x30
[  327.375685]  [<ffffffff811522af>] ? kioctx_ring_unlock+0xd/0x5f
[  327.375689]  [<ffffffff811524c7>] batch_complete_aio+0x1c6/0x212
[  327.375694]  [<ffffffff8117fc63>] ? ext4_unwritten_wait+0x98/0x98
[  327.375697]  [<ffffffff81152b3a>] aio_complete_batch+0x125/0x132
[  327.375702]  [<ffffffff8117fc63>] ? ext4_unwritten_wait+0x98/0x98
[  327.375705]  [<ffffffff81153931>] do_io_submit+0x781/0x84b
[  327.375710]  [<ffffffff81153a06>] sys_io_submit+0xb/0xd
[  327.375715]  [<ffffffff8161b0d2>] system_call_fastpath+0x16/0x1b

(and that BUG cascades into a second one:

[  327.375724] BUG: unable to handle kernel NULL pointer dereference at 0000000000000250
[  327.375729] IP: [<ffffffff811522af>] kioctx_ring_unlock+0xd/0x5f
[  327.375733] PGD d0d36067 PUD da749067 PMD 0
[  327.375740] Oops: 0002 [#1] PREEMPT SMP
...
[  327.375829] Call Trace:
[  327.375833]  [<ffffffff811524c7>] batch_complete_aio+0x1c6/0x212
[  327.375838]  [<ffffffff8117fc63>] ? ext4_unwritten_wait+0x98/0x98
[  327.375842]  [<ffffffff81152b3a>] aio_complete_batch+0x125/0x132
[  327.375846]  [<ffffffff8117fc63>] ? ext4_unwritten_wait+0x98/0x98
[  327.375850]  [<ffffffff81153931>] do_io_submit+0x781/0x84b
[  327.375855]  [<ffffffff81153a06>] sys_io_submit+0xb/0xd
[  327.375859]  [<ffffffff8161b0d2>] system_call_fastpath+0x16/0x1b
[  327.375861] Code: 00 50 48 8d 5f 90 48 81 c7 98 01 00 00 e8 0e 9c f0 ff 48 89 df e8 87 fd ff ff 58 5b 5d c3 55 48 89 e5 41 54 41 89 f4 53
48 89 fb <89> b3 50 02 00 00 48 8b 47 50 48 8b 38 e8 37 f9 ff ff 44 89 60
[  327.375937] RIP  [<ffffffff811522af>] kioctx_ring_unlock+0xd/0x5f
[  327.375942]  RSP <ffff8800b8965db8>
[  327.375944] CR2: 0000000000000250
[  327.375949] ---[ end trace b119850056dcfba4 ]---


--==_Exmh_1358774694_1966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUP1BpgdmEQWDXROgAQLJmQ/7BHIaSHEjwpprfG0d/SUBMyeWqzlu/mbw
yqhCdCdpwZH2TgLBsLgE6IkKBTunmGgWkSNRXA9JyoFt4aqqXV9igMz9tCEqN2n6
za0sLWrkUhNfZ2vDjfHgZV5KFO7XNxOp/2z4dpJJ0qhoCxuExgDoXZeQ6Z5Zras7
akbhCHoyXFKY+GPkAp/5HrvUElciOiUjWas56BnE8z++wb0pR935i/9aGvKbGvth
6gqSuVXp/cURw2AnJnNeKoyHxoG3hwKX5PDyOu4s3TNg+UglUZq1+rSo2i2wpxDy
W81aLSaQemw1H80GJYUECB7A8pwkC92iqAhh3DyA9BKx55eJUKCB+BNP8lwZ8p7a
Tj9ZmU8do3LiWl1rxhkGgE57/OnQGbaGiFgm9M9Vngg3kVukAID1swnZZPsKWbke
ZtIkLGjnW3+B729aKm0ESdTfkwjdpykEIl40GzI2ukbkZqlpnrBykZLtyqfKHBEu
7dtN7tMy2C6SoM4IbwoxWzmON2GD+WVdrtExvQw5f38YK8ofALzX4umaVvxzrQt6
6k05uM87xbFzayrMIZKjC3q4yRRMMyQleTCNCeRpacvGntLFygrpYA0Lmm0dYzwh
XcmG9o+Bfu6Zt1JAGNxzz1FBEQXhJUj4qVQ7fne5ZiFDzb2Agp0aeq8swB6uca7N
I5tG6HgpaNQ=
=F2G9
-----END PGP SIGNATURE-----

--==_Exmh_1358774694_1966P--

