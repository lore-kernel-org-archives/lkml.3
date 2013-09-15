Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3IOALM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 20:11:12 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62656 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab3IOALK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 20:11:10 -0400
X-Nat-Received: from [202.181.97.72]:62170 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379203854.22072
To: oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] argv_split: Return NULL if argument contains nonon-whitespace.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309141632.GHD86439.VLOOOFQFJtSMFH@I-love.SAKURA.ne.jp>
	<20130914154144.GA7884@redhat.com>
In-Reply-To: <20130914154144.GA7884@redhat.com>
Message-Id: <201309150910.CCE73459.VMOFtJFLSHOQFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 15 Sep 2013 09:10:53 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14092013 #11055784, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> > upon core dump because helper_argv[0] == NULL at
> >
> >   helper_argv = argv_split(GFP_KERNEL, cn.corename, NULL);
> >   call_usermodehelper_setup(helper_argv[0], ...);
> 
> Are you sure? See above.
> 

Yes, I'm sure. execve(NULL) from user space is safe, but
do_execve(NULL) from kernel space is not safe.

---------- patch start ----------
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -763,6 +763,9 @@ struct file *open_exec(const char *name)
 		.lookup_flags = LOOKUP_FOLLOW,
 	};
 
+	if (WARN_ON(!name))
+		return ERR_PTR(-EINVAL);
+
 	file = do_filp_open(AT_FDCWD, &tmp, &open_exec_flags);
 	if (IS_ERR(file))
 		goto out;
---------- patch end ----------

---------- dmesg start ----------
die[3924]: segfault at 0 ip 0804839c sp bf9d3c78 error 4 in die[8048000+1000]
------------[ cut here ]------------
WARNING: CPU: 1 PID: 3925 at fs/exec.c:766 open_exec+0xfd/0x110()
Modules linked in: ipv6 binfmt_misc
CPU: 1 PID: 3925 Comm: kworker/u4:0 Not tainted 3.11.0-10050-g3711d86-dirty #111
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/15/2008
 00000000 c0557e9e c068909b c0139756 c067af64 00000001 00000f55 c068909b
 000002fe c01da24d c01da24d 00000000 de754a80 df120b50 00000000 c013979b
 00000009 00000000 c01da24d de6626c0 c0158c68 df120b50 00000000 00000000
Call Trace:
 [<c0557e9e>] ? dump_stack+0x3e/0x50
 [<c0139756>] ? warn_slowpath_common+0x86/0xb0
 [<c01da24d>] ? open_exec+0xfd/0x110
 [<c01da24d>] ? open_exec+0xfd/0x110
 [<c013979b>] ? warn_slowpath_null+0x1b/0x20
 [<c01da24d>] ? open_exec+0xfd/0x110
 [<c0158c68>] ? prepare_creds+0x88/0xb0
 [<c01da98c>] ? do_execve+0x18c/0x560
 [<c014aa2c>] ? ____call_usermodehelper+0xbc/0xe0
 [<c05605f7>] ? ret_from_kernel_thread+0x1b/0x28
 [<c014aa50>] ? ____call_usermodehelper+0xe0/0xe0
---[ end trace 63bb92bc8d58b0c2 ]---
Core dump to | pipe failed
---------- dmesg end ----------

> Perhaps
> 
> 	--- x/kernel/kmod.c
> 	+++ x/kernel/kmod.c
> 	@@ -571,6 +571,9 @@ int call_usermodehelper_exec(struct subp
> 		DECLARE_COMPLETION_ONSTACK(done);
> 		int retval = 0;
> 	 
> 	+	if (!sub_info->path)
> 	+		return -EXXX;
> 	+
> 		helper_lock();
> 		if (!khelper_wq || usermodehelper_disabled) {
> 			retval = -EBUSY;
> 
> ?
> 

I'm OK with that.
