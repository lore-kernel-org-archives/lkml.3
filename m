Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbaLQBKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:10:10 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:56081 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaLQBKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:10:08 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@parisplace.org>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: linux-next 20141216 BUG: sleeping function called from invalid context at mm/slab.c:2849
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1418778594_1890P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Dec 2014 20:09:54 -0500
Message-ID: <2966.1418778594@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1418778594_1890P
Content-Type: text/plain; charset=us-ascii

Not sure who's to blame here, but I'm tending towards selinux based on
who was holding the locks...

Spotted these two while booting single-user on 20141216.  20141208
doesn't throw these, so it's something in the last week or so..

Tossed it twice - once for /sbin/sulogin, and then a second time for /bin/bash.

[   34.061285] BUG: sleeping function called from invalid context at mm/slab.c:2849
[   34.062863] in_atomic(): 1, irqs_disabled(): 0, pid: 885, name: sulogin
[   34.064416] 2 locks held by sulogin/885:
[   34.064418]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff91152e30>] prepare_bprm_creds+0x28/0x8b
[   34.064428]  #1:  (tty_files_lock){+.+.+.}, at: [<ffffffff9123e787>] selinux_bprm_committing_creds+0x55/0x22b
[   34.064438] CPU: 1 PID: 885 Comm: sulogin Not tainted 3.18.0-next-20141216 #30
[   34.064440] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A15 06/20/2014
[   34.064442]  ffff880223744f10 ffff88022410f9b8 ffffffff916ba529 0000000000000375
[   34.064447]  ffff880223744f10 ffff88022410f9e8 ffffffff91063185 0000000000000006
[   34.064452]  0000000000000000 0000000000000000 0000000000000000 ffff88022410fa38
[   34.064457] Call Trace:
[   34.064463]  [<ffffffff916ba529>] dump_stack+0x50/0xa8
[   34.064467]  [<ffffffff91063185>] ___might_sleep+0x1b6/0x1be
[   34.064472]  [<ffffffff910632a6>] __might_sleep+0x119/0x128
[   34.064477]  [<ffffffff91140720>] cache_alloc_debugcheck_before.isra.45+0x1d/0x1f
[   34.064480]  [<ffffffff91141d81>] kmem_cache_alloc+0x43/0x1c9
[   34.064484]  [<ffffffff914e148d>] __alloc_skb+0x42/0x1a3
[   34.064488]  [<ffffffff914e2b62>] skb_copy+0x3e/0xa3
[   34.064492]  [<ffffffff910c263e>] audit_log_end+0x83/0x100
[   34.064496]  [<ffffffff9123b8d3>] ? avc_audit_pre_callback+0x103/0x103
[   34.064500]  [<ffffffff91252a73>] common_lsm_audit+0x441/0x450
[   34.064503]  [<ffffffff9123c163>] slow_avc_audit+0x63/0x67
[   34.064506]  [<ffffffff9123c42c>] avc_has_perm+0xca/0xe3
[   34.064510]  [<ffffffff9123dc2d>] inode_has_perm+0x5a/0x65
[   34.064514]  [<ffffffff9123e7ca>] selinux_bprm_committing_creds+0x98/0x22b
[   34.064519]  [<ffffffff91239e64>] security_bprm_committing_creds+0xe/0x10
[   34.064522]  [<ffffffff911515e6>] install_exec_creds+0xe/0x79
[   34.064527]  [<ffffffff911974cf>] load_elf_binary+0xe36/0x10d7
[   34.064542]  [<ffffffff9115198e>] search_binary_handler+0x81/0x18c
[   34.064545]  [<ffffffff91153376>] do_execveat_common.isra.31+0x4e3/0x7b7
[   34.064548]  [<ffffffff91153669>] do_execve+0x1f/0x21
[   34.064552]  [<ffffffff91153967>] SyS_execve+0x25/0x29
[   34.064557]  [<ffffffff916c61a9>] stub_execve+0x69/0xa0

[   48.826654] BUG: sleeping function called from invalid context at mm/slab.c:2849
[   48.829282] in_atomic(): 1, irqs_disabled(): 0, pid: 885, name: bash
[   48.829284] 2 locks held by bash/885:
[   48.829297]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff91152e30>] prepare_bprm_creds+0x28/0x8b
[   48.829307]  #1:  (&(&newf->file_lock)->rlock){+.+.+.}, at: [<ffffffff91166b8b>] iterate_fd+0x34/0x11c
[   48.829310] CPU: 3 PID: 885 Comm: bash Not tainted 3.18.0-next-20141216 #30
[   48.829311] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A15 06/20/2014
[   48.829317]  ffff880223744f10 ffff88022410f928 ffffffff916ba529 0000000000000375
[   48.829321]  ffff880223744f10 ffff88022410f958 ffffffff91063185 0000000000000002
[   48.829325]  0000000000000000 0000000000000000 0000000000000000 ffff88022410f9a8
[   48.829327] Call Trace:
[   48.829333]  [<ffffffff916ba529>] dump_stack+0x50/0xa8
[   48.829338]  [<ffffffff91063185>] ___might_sleep+0x1b6/0x1be
[   48.829341]  [<ffffffff910632a6>] __might_sleep+0x119/0x128
[   48.829347]  [<ffffffff91140720>] cache_alloc_debugcheck_before.isra.45+0x1d/0x1f
[   48.829350]  [<ffffffff91141d81>] kmem_cache_alloc+0x43/0x1c9
[   48.829356]  [<ffffffff914e148d>] __alloc_skb+0x42/0x1a3
[   48.829360]  [<ffffffff914e2b62>] skb_copy+0x3e/0xa3
[   48.829367]  [<ffffffff910c263e>] audit_log_end+0x83/0x100
[   48.829372]  [<ffffffff9123b8d3>] ? avc_audit_pre_callback+0x103/0x103
[   48.829377]  [<ffffffff91252a73>] common_lsm_audit+0x441/0x450
[   48.829381]  [<ffffffff9123c163>] slow_avc_audit+0x63/0x67
[   48.829386]  [<ffffffff9123c42c>] avc_has_perm+0xca/0xe3
[   48.829391]  [<ffffffff9123e255>] ? selinux_file_permission+0x9b/0x9b
[   48.829395]  [<ffffffff9123e0b9>] file_has_perm+0x6d/0x7c
[   48.829400]  [<ffffffff9123e283>] match_file+0x2e/0x3b
[   48.829404]  [<ffffffff91166c4b>] iterate_fd+0xf4/0x11c
[   48.829409]  [<ffffffff9123e802>] selinux_bprm_committing_creds+0xd0/0x22b
[   48.829415]  [<ffffffff91239e64>] security_bprm_committing_creds+0xe/0x10
[   48.829419]  [<ffffffff911515e6>] install_exec_creds+0xe/0x79
[   48.829426]  [<ffffffff911974cf>] load_elf_binary+0xe36/0x10d7
[   48.829431]  [<ffffffff9115198e>] search_binary_handler+0x81/0x18c
[   48.829435]  [<ffffffff91153376>] do_execveat_common.isra.31+0x4e3/0x7b7
[   48.829462]  [<ffffffff91153669>] do_execve+0x1f/0x21
[   48.829466]  [<ffffffff91153967>] SyS_execve+0x25/0x29
[   48.829472]  [<ffffffff916c61a9>] stub_execve+0x69/0xa0


--==_Exmh_1418778594_1890P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVJDX4QdmEQWDXROgAQLDXhAAhDZ1wF2LTuxfdT5uRcSKkabb/KD326KM
Quch1470E7LSRrs7CVOflyx1JLmk40qDXIW9w4CzJ0WtzdKdH47HaCnHBkdxR1j7
gZG3KJk8XwkHS+1QO2j5DlJ7IJN+kjTGFrmtK79bxHzqdbdqJXN6A8x/g3gu7E/2
wK9cuQEJh0PwShhyJcQMCMyadN2Px4ZTfidBK5tInoAA5ANZKMTG0jUTB4ZHLFme
2nqXI/BoZkaqCS5SrCqiVojCsxzMtNiZLiweL/XsT2MbaNsRmIjnjlyizXOkg5te
wIlC00TJCIAFvBkiLv9Hcu15q7MGv3Tg9stQ4ANxcLD/6C/uRGugtiBmzhGqcpcR
9+bZuJwG8BHg26s5sayODb4WyNgnEPp+UwWbpTP07TMZFX91QEaNltTcQsdcjHEo
dA+++X1ng5aeHF+hJu5ZxofuqeyU0+WE44sOD7HcLGs1UCYX+IkpowG5LClw+URZ
Jiidda/CESH0VRTkPe/JrsHVoEfwVX0nF8Z8QvtsnrG717Wa3qujUhfopGn6ILkJ
uHgmg1tZ2Otbm56A0C+I6zxZ5/xTkTatXKV5sUVtv5MCWJ2Yz/AK3TFH5AGfOU2s
G7f4gIlUhv+6iTFRt7/C9fgatYeLe5liVOsS9+EirAgCcrqLD8iNSggkMYcyknvr
zFfFNdcMyQI=
=hs2E
-----END PGP SIGNATURE-----

--==_Exmh_1418778594_1890P--
