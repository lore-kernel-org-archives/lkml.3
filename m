Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab3CGUWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:22:21 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:43131 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740Ab3CGUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:22:19 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: next-20130306 - BUG: unable to handle kernel paging reques in avc_has_perm_noaudit
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1362687651_1805P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Mar 2013 15:20:51 -0500
Message-ID: <3077.1362687651@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.5138F6A5.0081,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1362687651_1805P
Content-Type: text/plain; charset=us-ascii

Seeing this in next-20130306:

[  180.958482] BUG: unable to handle kernel paging request at ffffffffffffffe0
[  180.958488] IP: [<ffffffff811e5661>] avc_has_perm_noaudit+0xbf/0x1bc

[  180.958506] Pid: 1910, comm: systemd-udevd Tainted: G           O 3.9.0-rc1-next-20130306-dirty #64 Dell Inc. Latitude E6500

[  180.958537]  [<ffffffff811e5790>] avc_has_perm_flags+0x32/0xe4
[  180.958540]  [<ffffffff81071c81>] ? mark_lock+0x2e/0x225
[  180.958543]  [<ffffffff811e5ada>] avc_has_perm+0xf/0x11
[  180.958546]  [<ffffffff811e5e92>] selinux_inode_rename+0x84/0x138
[  180.958549]  [<ffffffff811002b6>] ? __kmalloc_track_caller+0x107/0x119
[  180.958552]  [<ffffffff811e36db>] security_inode_rename+0x6f/0x7a
[  180.958556]  [<ffffffff81115a8f>] vfs_rename+0x1e2/0x36a
[  180.958558]  [<ffffffff81115e04>] SYSC_renameat+0x1ed/0x282
[  180.958562]  [<ffffffff81123485>] ? mntput+0x49/0x50
[  180.958566]  [<ffffffff81068576>] ? __read_seqcount_retry.constprop.21+0x20/0x25
[  180.958568]  [<ffffffff81068b1c>] ? current_kernel_time+0x2a/0x41
[  180.958572]  [<ffffffff81094215>] ? __audit_syscall_entry+0xf9/0x125
[  180.958575]  [<ffffffff8111681f>] SyS_renameat+0x9/0xb
[  180.958577]  [<ffffffff81116837>] SyS_rename+0x16/0x1b
[  180.958581]  [<ffffffff815f55d2>] system_call_fastpath+0x16/0x1b

Most suspicious-looking recent commit in git log:

ommit 65dff759d2948cf18e2029fc5c0c595b8b7da3a5
Author: Li Zefan <lizefan@huawei.com>
Date:   Fri Mar 1 15:01:56 2013 +0800

    cgroup: fix cgroup_path() vs rename() race

    rename() will change dentry->d_name. The result of this race can
    be worse than seeing partially rewritten name, but we might access
    a stale pointer because rename() will re-allocate memory to hold
    a longer name.

I admit not having any clue what crazy antics systemd was trying to do
at the time.  If this doesn't ring a bell, I'll go bisect it.

--==_Exmh_1362687651_1805P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUTj2owdmEQWDXROgAQJZEA//XabyFyzQ6/tr8hJRFSoVm1PY4Dh2hxDC
8c+2q3asnxICHht0llNcZacGXb6IKfEXum7u74HI2TppwDRPyDWLDfbFSLpLNl5w
AGdtxjStjk4UX8yd/IVfKXNJiJzZfFvXu30lqa8p1NJaES30hAWtyhuoVPbnA9H7
VdEhUJuM8Yz585xBsaAZpKtX7+KC88GjTOSRb79qRgsFamqDUPSrGpgD5/RFmwvq
oUjn6Dhge1hjZol7RYiVluAsMPih4r1T/NpSpSSx15XJLtQvtU3uTgho4/u/OwY+
CcqbYOrub95KF3gmKUgS/+3zx16mnHEBP09LhfMq/+gEWX84zbGNu2LKI7VLCziw
FhF6axayJVteelBD/0r0O19RWKDa4BFKw8RaU3b/ZCupFkcR6yeplGenmg6Ekx7K
KP6SprOZoRy+A83CrbjNcRnrO8eGtA3u4v0baTEhfppOzEvfKJTyr8HHhJnr2eVy
qeICSgWK2vCS/vPB0jR2pZgdR9yHk+8JAvoQu5Z9s+MJRrrqX+0JB0V6VCNpp8ji
JHuWjiSCpOXUll+iBZc3q4eBubeAShAaoo5jmhagJyFhYKvJ3PFE6DZZj5OrymxZ
w+7C29grTwKC0JbfnSPJcpGUA1U0SGr85+EmqgX085lB10xWUWTamXnQeO+PeD6n
Epe2VpCg8wI=
=MZOi
-----END PGP SIGNATURE-----

--==_Exmh_1362687651_1805P--

