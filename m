Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaAOSUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:20:51 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:53490 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaAOSUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:20:49 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: next-20140114 - BUG: spinlock wrong CPU on CPU#3, mount/597
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1389810012_2475P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Jan 2014 13:20:12 -0500
Message-ID: <14473.1389810012@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1389810012_2475P
Content-Type: text/plain; charset=us-ascii

Am seeing this at boot on next-20140114, but I hit this same exact stack trace
at least once on next-20131218.  v3.13-rc7 doesn't have the problem, so it's
not a 3.13 release showstopper.  I may not be able to bisect this, as there's 2
or 3 other now-fixed bugs that cause lots of 'bisect skips' because the system
won't boot far enough to hit this issue.

I'm not sure who to blame - Jan beat up on fs/notify/notification.c pretty
heavily a few days ago, but I hit this at least once last month and that file
hasn't been touched since 2012, so the root cause is probably elsewhere.

I'm reasonably sure that rebuilding with CONFIG_DEBUG_SPINLOCK=n will "fix"
my issue, but that's just papering it over...

[   93.724597] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   93.759851] BUG: spinlock wrong CPU on CPU#3, mount/597
[   93.759854]  lock: 0xffff8800b87f04a8, .magic: dead4ead, .owner: mount/597, .owner_cpu: 35
[   93.759857] CPU: 3 PID: 597 Comm: mount Not tainted 3.13.0-rc8-next-20140114 #151
[   93.759858] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A11 03/12/2013
[   93.759863]  0000000000000000 ffff8800b87e7cd8 ffffffff8164e7e7 ffff8800b8194590
[   93.759867]  ffff8800b87e7cf8 ffffffff8107c42c ffff8800b87f04a8 0000000000000001
[   93.759871]  ffff8800b87e7d18 ffffffff8107c457 ffff8800b87f04a8 ffffffff81aa8b43
[   93.759872] Call Trace:
[   93.759879]  [<ffffffff8164e7e7>] dump_stack+0x4f/0xa2
[   93.759883]  [<ffffffff8107c42c>] spin_dump+0x8c/0x91
[   93.759886]  [<ffffffff8107c457>] spin_bug+0x26/0x28
[   93.759889]  [<ffffffff8107c75e>] do_raw_spin_unlock+0xdc/0xf3
[   93.759892]  [<ffffffff816586b0>] _raw_spin_unlock_irqrestore+0x27/0x83
[   93.759895]  [<ffffffff81073b76>] __wake_up+0x3f/0x46
[   93.759899]  [<ffffffff811630c6>] fsnotify_add_notify_event+0xba/0xdf
[   93.759902]  [<ffffffff81166058>] ? SyS_inotify_rm_watch+0xf3/0xf3
[   93.759905]  [<ffffffff81166265>] fanotify_handle_event+0x16f/0x256
[   93.759910]  [<ffffffff8112069b>] ? ac_get_obj.constprop.61+0x39/0x1be
[   93.759913]  [<ffffffff8116293b>] send_to_group.isra.1+0x114/0x123
[   93.759915]  [<ffffffff81162c49>] fsnotify+0x2dd/0x41d
[   93.759918]  [<ffffffff8165864a>] ? _raw_spin_unlock+0x5b/0x67
[   93.759922]  [<ffffffff8112a73d>] do_sys_open+0x109/0x12e
[   93.759925]  [<ffffffff8112a77b>] SyS_open+0x19/0x1b
[   93.759928]  [<ffffffff8165f7a2>] system_call_fastpath+0x16/0x1b
[   93.994336] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs

Any brilliant ideas?

--==_Exmh_1389810012_2475P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUtbRXAdmEQWDXROgAQLZLRAAleDb9vEwNP7TrT5i6akS3gC9o3vvkpDe
bYQ/rHIYscsG68cJwgb1id/kX+f72r4/lc8oHVLcrQPBeSAPAC1PSY/rC30Ou2SU
x8WvVj96ZeddJzw/JH8r5XQOTR75Hwe7ipm9zn3EYzhQYKvquV+eyQ0N+cDJY0ta
XDq0m3i9YE7QC8k6Yno4FMRqi1IFwHYdVTgGkQXftCPM7OaPFpTJ1Tc7KZuLyz9G
q54PavB3JsDkBt71TG4DEOL2/wNThy5mG7/YyyH41/XFHar2OCYeuXIolms2vtit
bQ4Kbzoibf5c/hN4s9sIs2ikPHUopIA2u13wEa3ymhUjoSsSG9N3LuXagNVYuzcz
N35IBX5F/QIoJhiUJPVvp+wy6QawKMMn3oNqtCpCWYpRF4MaT+BSZQ3j9zrs18vZ
L3fG+c67OrVFuNTjEkzn3C8rgEeb9sqrNKScgh8T5LPwtyb+LqV0VQaKHITz0QN+
p80VsNsZiIdzYliZdx23AxHpb2AskY3OVOQ4QVGMweNFzaSDAj2mx74DmIlhznOf
3wJDPko0IzR3wdrIW8FrayN3XwA8E8aATNPRmxtNQgJyh24lC7r9hW4wRWm2UHE3
WfpNcCf17Rit8PugMwZT0lSGcpip4vFj1rZlAXTRBEC/wazknnQg1ub53BbBMvgb
K7DoDSTu0fk=
=Wrcx
-----END PGP SIGNATURE-----

--==_Exmh_1389810012_2475P--
