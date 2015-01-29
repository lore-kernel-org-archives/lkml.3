Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbbA2PLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:11:09 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:39478 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbbA2PLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:11:06 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: linux-next - process hangs in do_exit().
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1422544258_1909P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Jan 2015 10:10:58 -0500
Message-ID: <6559.1422544258@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1422544258_1909P
Content-Type: text/plain; charset=us-ascii

Saw my laptop grind to a halt this morning where processes would hang
while trying to exit.  Looks like Al was last person to touch kernel/acct.c
back around Jan 9:

commit 9e251d02041432487d89cb340e72490c4bbc198a
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri Jan 9 20:40:02 2015 -0500

    kill pin_put()

touched code near where it hung.  But I don't understand RCU enough to
tell for sure what is/isn't wrong there....

Found this in my syslog:

Jan 29 08:51:30 turing-police kernel: [36313.248179] INFO: task sendmail:32228 blocked for more than 120 seconds.
Jan 29 08:51:30 turing-police kernel: [36313.248192]       Tainted: G           OE   3.19.0-rc6-next-20150127 #42
Jan 29 08:51:30 turing-police kernel: [36313.248196] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 08:51:30 turing-police kernel: [36313.248200] sendmail        D ffff880098ddbd98 12880 32228   1380 0x00000080
Jan 29 08:51:30 turing-police kernel: [36313.248215]  ffff880098ddbd98 ffff880098ddbda8 ffff880098ddbfd8 ffff8801bd090c90
Jan 29 08:51:30 turing-police kernel: [36313.248226]  ffffffff9e0b34a1 0000000000014c80 ffff88022dd94c80 ffff88022cb2c350
Jan 29 08:51:30 turing-police kernel: [36313.248236]  ffff8801bd090c90 ffff880098ddbd88 ffff880222133e30 0000000000000200
Jan 29 08:51:30 turing-police kernel: [36313.248247] Call Trace:
Jan 29 08:51:30 turing-police kernel: [36313.248261]  [<ffffffff9e0b34a1>] ? acct_get+0x4f/0x76
Jan 29 08:51:30 turing-police kernel: [36313.248271]  [<ffffffff9e6c267f>] schedule+0x64/0x66
Jan 29 08:51:30 turing-police kernel: [36313.248279]  [<ffffffff9e6c29ad>] schedule_preempt_disabled+0x13/0x1f
Jan 29 08:51:30 turing-police kernel: [36313.248287]  [<ffffffff9e6c3db4>] mutex_lock_nested+0x274/0x58c
Jan 29 08:51:30 turing-police kernel: [36313.248293]  [<ffffffff9e0b34a1>] ? acct_get+0x4f/0x76
Jan 29 08:51:30 turing-police kernel: [36313.248300]  [<ffffffff9e0b3433>] ? rcu_read_unlock+0x3e/0x5d
Jan 29 08:51:30 turing-police kernel: [36313.248307]  [<ffffffff9e0b34a1>] acct_get+0x4f/0x76
Jan 29 08:51:30 turing-police kernel: [36313.248315]  [<ffffffff9e0b3e69>] acct_process+0x56/0x89
Jan 29 08:51:30 turing-police kernel: [36313.248324]  [<ffffffff9e042f68>] do_exit+0x55e/0xcf4
Jan 29 08:51:30 turing-police kernel: [36313.248332]  [<ffffffff9e0c8d68>] ? __audit_syscall_entry+0x10b/0x137
Jan 29 08:51:30 turing-police kernel: [36313.248341]  [<ffffffff9e00e35d>] ? do_audit_syscall_entry+0xb8/0xc7
Jan 29 08:51:30 turing-police kernel: [36313.248349]  [<ffffffff9e0448aa>] do_group_exit+0x63/0xe0
Jan 29 08:51:30 turing-police kernel: [36313.248356]  [<ffffffff9e044936>] SyS_exit_group+0xf/0xf
Jan 29 08:51:30 turing-police kernel: [36313.248363]  [<ffffffff9e6c8112>] system_call_fastpath+0x12/0x17

Jan 29 08:51:30 turing-police kernel: [36313.248369] INFO: lockdep is turned off.
Jan 29 08:51:30 turing-police kernel: [36313.248375] INFO: task formail:32242 blocked for more than 120 seconds.
Jan 29 08:51:30 turing-police kernel: [36313.248379]       Tainted: G           OE   3.19.0-rc6-next-20150127 #42
Jan 29 08:51:30 turing-police kernel: [36313.248383] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 29 08:51:30 turing-police kernel: [36313.248387] formail         D ffff8801882b7d98 14104 32242  32241 0x00000082
Jan 29 08:51:30 turing-police kernel: [36313.248399]  ffff8801882b7d98 ffff8801882b7da8 ffff8801882b7fd8 ffff8801c07e8cd0
Jan 29 08:51:30 turing-police kernel: [36313.248409]  ffffffff9e0b34a1 0000000000014c80 ffff88022dc94c80 ffff88022cb182d0
Jan 29 08:51:30 turing-police kernel: [36313.248419]  ffff8801c07e8cd0 ffff8801882b7d88 ffff880222133e30 0000000000000200
Jan 29 08:51:30 turing-police kernel: [36313.248429] Call Trace:
Jan 29 08:51:30 turing-police kernel: [36313.248436]  [<ffffffff9e0b34a1>] ? acct_get+0x4f/0x76
Jan 29 08:51:30 turing-police kernel: [36313.248444]  [<ffffffff9e6c267f>] schedule+0x64/0x66
Jan 29 08:51:30 turing-police kernel: [36313.248451]  [<ffffffff9e6c29ad>] schedule_preempt_disabled+0x13/0x1f
Jan 29 08:51:30 turing-police kernel: [36313.248459]  [<ffffffff9e6c3db4>] mutex_lock_nested+0x274/0x58c
Jan 29 08:51:30 turing-police kernel: [36313.248465]  [<ffffffff9e0b34a1>] ? acct_get+0x4f/0x76
Jan 29 08:51:30 turing-police kernel: [36313.248472]  [<ffffffff9e0b3433>] ? rcu_read_unlock+0x3e/0x5d
Jan 29 08:51:30 turing-police kernel: [36313.248479]  [<ffffffff9e0b34a1>] acct_get+0x4f/0x76
Jan 29 08:51:30 turing-police kernel: [36313.248485]  [<ffffffff9e0b3e69>] acct_process+0x56/0x89
Jan 29 08:51:30 turing-police kernel: [36313.248493]  [<ffffffff9e042f68>] do_exit+0x55e/0xcf4
Jan 29 08:51:30 turing-police kernel: [36313.248499]  [<ffffffff9e0c8d68>] ? __audit_syscall_entry+0x10b/0x137
Jan 29 08:51:30 turing-police kernel: [36313.248507]  [<ffffffff9e00e35d>] ? do_audit_syscall_entry+0xb8/0xc7
Jan 29 08:51:30 turing-police kernel: [36313.248514]  [<ffffffff9e0448aa>] do_group_exit+0x63/0xe0
Jan 29 08:51:30 turing-police kernel: [36313.248521]  [<ffffffff9e044936>] SyS_exit_group+0xf/0xf
Jan 29 08:51:30 turing-police kernel: [36313.248528]  [<ffffffff9e6c8112>] system_call_fastpath+0x12/0x17
Jan 29 08:51:30 turing-police kernel: [36313.248532] INFO: lockdep is turned off.
Jan 29 08:51:30 turing-police kernel: [36313.248537] INFO: task formail:32246 blocked for more than 120 seconds.
Jan 29 08:51:30 turing-police kernel: [36313.248541]       Tainted: G           OE   3.19.0-rc6-next-20150127 #42

(and another few identical traces)

--==_Exmh_1422544258_1909P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVMpNggdmEQWDXROgAQKCaA//URF/nAJZ0dAIMyC06yQPGIgWDLOqAUtI
qVwLxMzSQLvCbQADksfbVssmgh6RA+yGk8HQyTniBacPbOpQrvCeC25jqDT6yiIz
SqxVDyxGrKblcwOx/eco3RdrR56fL2i2OtKvpblJpzwGrUu3fNgObw1EWOUNDoVf
4sXE6gtsmP287lMkGMLNVQv4af/o8GPPaEEKKRBhM5h5qdN0yHBfgMLcdOtBCqNk
Vri8aa1TQdSlE4BPypSq070mrYYLVD9RBX0UiCgMy+HbmU6zWesy/NUWL7UW2jyF
k+oJPc3fMufFO12fQSEF5g/D9SEXTeo37jD4JOXsH5L+WPETR0r+Fa4psHx0M7LM
1wlFv9MY7GMLNNc2Zfunia78aCpX39bAU/0TceBVwu+28OkX5dOlhXFHWnXnZVLg
GEWRoS5o64VjhKdu/ZzGug0E6QcnzvhB7NT9tbkU19R/t9iDp4+IEG347ymo1Z4p
2CujFb2OWWWEgGlV9p6b2TPVOwLnwhoY21XR+waJSI87QM+iYA5E67CHbroKZUZZ
2a7wSwSoBxFzf/14GmRcGIrNM3VL66iHzXCkkDfVRlPf0pOM5O4MTSRElbW8FYGm
4A9eMOhFGm1qqPbwraZ6X+wRFDoOxH9kKx+1/MhpTgbHvapIBq7VV4ULuNubrB7t
XUCWKnvm2CU=
=Da9Y
-----END PGP SIGNATURE-----

--==_Exmh_1422544258_1909P--
