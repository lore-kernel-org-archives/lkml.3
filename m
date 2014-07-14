Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaGNTV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:21:59 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42515 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbaGNTVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:21:51 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Maurizio Lombardi <mlombard@redhat.com>, Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: next-20140707 - crash during cryptsetup.
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
References: <6964.1404835247@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1405365631_3151P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jul 2014 15:20:31 -0400
Message-ID: <10386.1405365631@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1405365631_3151P
Content-Type: text/plain; charset=us-ascii

System died a horrid death when cryptsetup was trying to get an encrypted
disk up and running.

Bisected down to this commit, and vanilla next-20140714 crashes the same way,
but  boots fine with this single commit reverted:

commit 254c4407cb84a6dec90336054615b0f0e996bb7c
Author: Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue Jul 1 10:55:15 2014 -0600

    bio: modify __bio_add_page() to accept pages that don't start a new segment

    The original behaviour is to refuse to add a new page if the maximum
    number of segments has been reached, regardless of the fact the page we
    are going to add can be merged into the last segment or not.

    Unfortunately, when the system runs under heavy memory fragmentation
    conditions, a driver may try to add multiple pages to the last segment.
    The original code won't accept them and EBUSY will be reported to
    userspace.

    This patch modifies the function so it refuses to add a page only in case
    the latter starts a new segment and the maximum number of segments has
    already been reached.


[   25.929846] ------------[ cut here ]------------
[   25.929873] kernel BUG at fs/direct-io.c:747!
[   25.929893] invalid opcode: 0000 [#1] PREEMPT SMP
[   25.929922] Modules linked in:
[   25.929940] CPU: 3 PID: 308 Comm: systemd-cryptse Not tainted 3.16.0-rc4-next-20140707 #247
[   25.929974] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A14 01/13/2014
[   25.930004] task: ffff880222609e50 ti: ffff8802225b4000 task.ti: ffff8802225b4000
[   25.930034] RIP: 0010:[<ffffffff8116bee5>]  [<ffffffff8116bee5>] dio_send_cur_page+0xd7/0xe3
[   25.930074] RSP: 0018:ffff8802225b7aa0  EFLAGS: 00010202
[   25.930096] RAX: 0000000000000001 RBX: ffff8802225b7c01 RCX: 0000000000000000
[   25.930126] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81d13cf0
[   25.930155] RBP: ffff8802225b7ac8 R08: 0000000000000000 R09: 0000000000000001
[   25.930184] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800c6e8dc00
[   25.930213] R13: ffff8802225b7bc0 R14: 000000000000007a R15: 000000000000007c
[   25.930243] FS:  00007f5908c49840(0000) GS:ffff88022dd80000(0000) knlGS:0000000000000000
[   25.930276] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.930300] CR2: 00000000006ecf18 CR3: 0000000222bb1000 CR4: 00000000001407e0
[   25.930329] Stack:
[   25.930339]  0000000100000000 ffff8800c6e8dc00 ffffea0002ba9d68 0000000000000800
[   25.930380]  ffff8802225b7c28 ffff8802225b7b08 ffffffff8116bfa2 0000000022110780
[   25.930419]  ffff8800c6e8dc00 ffffea0002ba9d68 0000000000000800 0000000000000001
[   25.930458] Call Trace:
[   25.930473]  [<ffffffff8116bfa2>] submit_page_section+0xb1/0x114
[   25.930499]  [<ffffffff8116cad6>] do_blockdev_direct_IO+0xa28/0xd1f
[   25.930527]  [<ffffffff81169558>] ? I_BDEV+0xd/0xd
[   25.930549]  [<ffffffff8116cdfc>] __blockdev_direct_IO+0x2f/0x31
[   25.930575]  [<ffffffff8116cdfc>] ? __blockdev_direct_IO+0x2f/0x31
[   25.930601]  [<ffffffff81169558>] ? I_BDEV+0xd/0xd
[   25.930622]  [<ffffffff811698e2>] blkdev_direct_IO+0x2e/0x30
[   25.930647]  [<ffffffff81169558>] ? I_BDEV+0xd/0xd
[   25.930669]  [<ffffffff810f314c>] generic_file_read_iter+0x93/0x5c8
[   25.930697]  [<ffffffff81169c8a>] blkdev_read_iter+0x35/0x37
[   25.930722]  [<ffffffff81139725>] new_sync_read+0x74/0x98
[   25.930746]  [<ffffffff81139e0c>] vfs_read+0xce/0x124
[   25.930768]  [<ffffffff8113a665>] SyS_read+0x4b/0x79
[   25.930791]  [<ffffffff8167ea92>] system_call_fastpath+0x16/0x1b
[   25.930816] Code: fe ff ff 48 89 df e8 40 fe ff ff 48 c7 c7 f0 3c d1 81 85 c0 89 45 dc 0f 95 c3 31 d2 0f b6 f3 e8 4f ad f6 ff 84 db 8b 45 dc 74 02 <0f> 0b 5a 5b 41 5c 41 5d 41 5e 5d c3 55 48 89 e5 41 57 4d 89 cf
[   25.931060] RIP  [<ffffffff8116bee5>] dio_send_cur_page+0xd7/0xe3
[   25.931088]  RSP <ffff8802225b7aa0>
[   25.931132] ---[ end trace 5bdcfa6254e32464 ]---


--==_Exmh_1405365631_3151P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU8QtfwdmEQWDXROgAQJzkBAAuswTHyx3d2ejRHnIuCr09H+crv+oAxVZ
3KlK4L1Acpnu1s7CF3dFNLQ7INd+oe2fNfTHg9ma/T9Un+bju3N/y9/+MVZ57+R/
DPzHQOt8sNGWa06G0efcJ6xsvKAKy1xiJptlDAY2jyr1t5oIOZfLkyjsSqUIdtoP
dB/DBN2NmuMN3TCo1nHxc6gkznv3vNuSWfUkYvJ/qHuUhriN795m1/72hHm77ATC
muhnMyWGNNwyPgOry4qaYcN9tYygYlCe/YD4VdDo4l4cioQATdQWwjwOkZcfddNi
9rLhBzjEN0cdGovPCyiA4DG4VUffE9Gar/S5WOeJzmiKLIDgov8nF4qVHUNB4mZb
g7qBW6AByMhc06Ck07jdPWn45tQktsLr0OSmgLcM72yYyDt1SzWVJvg/UXBPV3uR
m9+hYS8Tcn37Yj4IvNrJGR8YPXkzDshjzmiZJtR6QzCtqWoE07KrlL4V3O2Q36zy
JidXiX7BxgwqExN8WYtaVLWMQ5QIiXo1f4n4GA+5wdU4I4VwaO9k/fnK6votXNn5
xdaVg4sHjHaqjhn1q227wh4LOOlHI+7zZn1AIPuFb+MudfelvhXKz1KUBcfGu2fB
MVWYxZNsu5YL+acMIwZTMsFhfiBwzqwnpP58ZmHtM2fkL8cSlJddmZsvbRsm5Kso
47ThbUtjSiQ=
=nwX3
-----END PGP SIGNATURE-----

--==_Exmh_1405365631_3151P--
