Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab3ICLb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:31:57 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58952 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab3ICLb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:31:56 -0400
X-Nat-Received: from [202.181.97.72]:53752 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378207865.10448
To: ak@linux.intel.com, viro@ZenIV.linux.org.uk, geert@linux-m68k.org,
        akpm@linux-foundation.org
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [linux-next-20130903] module: broken module versions?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201308262306.DHB48401.OHFSVQJOtLFOMF@I-love.SAKURA.ne.jp>
	<201308271923.FCG13057.QLVHOFFSMtJOFO@I-love.SAKURA.ne.jp>
In-Reply-To: <201308271923.FCG13057.QLVHOFFSMtJOFO@I-love.SAKURA.ne.jp>
Message-Id: <201309032031.BEH95862.VFSFMQLtOJFHOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 3 Sep 2013 20:31:04 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 03092013 #10972367, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This issue is not yet fixed as of linux-next-20130903. Without fixing this
issue, we would get 3.12-rc1 which cannot load several modules.

> I noticed that symbols which cause "disagrees about version of symbol" messages
> have crc == 0.

I tried further debugging but not yet successful.

---------- debug patch start ----------
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1192,6 +1192,9 @@ static int check_version(Elf_Shdr *sechdrs,
 		if (strcmp(versions[i].name, symname) != 0)
 			continue;
 
+		printk("Found %s checksum %lX vs module %lX\n",
+		       versions[i].name, maybe_relocated(*crc, crc_owner),
+		       versions[i].crc);
 		if (versions[i].crc == maybe_relocated(*crc, crc_owner))
 			return 1;
 		pr_debug("Found checksum %lX vs module %lX\n",
---------- debug patch end ----------

On x86_64, it shows

  Found sock_register checksum 0 vs module 0
  Found ns_capable checksum 0 vs module 0

and loading of ipv6.ko succeeds.

On x86_32, it shows

  Found sock_register checksum FF100000 vs module 0
  Found ns_capable checksum FF100000 vs module 0

and loading of ipv6.ko fails.

Thus, I came to assume that crc == 0 is the expected value but for some reason
crc == 0xFF100000 is recorded into kcrctab tables.



---------- debug patch start ----------
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -320,6 +320,11 @@ bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 #endif
 	};
 
+	static unsigned int i;
+	for (; i < __stop___ksymtab - __start___ksymtab; i++)
+		printk("%d crc(%s)=%lx\n", i, __start___ksymtab[i].name,
+		       __start___kcrctab[i]);
+
 	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
 		return true;
 
---------- debug patch end ----------

On x86_64, "grep =0" shows

  236 crc(__symbol_put)=0
  784 crc(current_fs_time)=0
  810 crc(d_tmpfile)=0
  955 crc(do_sync_read)=0
  1093 crc(filp_close)=0
  1107 crc(finish_open)=0
  1183 crc(generic_getxattr)=0
  1207 crc(generic_write_sync)=0
  1237 crc(get_unmapped_area)=0
  1335 crc(in_group_p)=0
  1407 crc(inode_add_bytes)=0
  1495 crc(iov_shorten)=0
  1548 crc(iterate_fd)=0
  1815 crc(mnt_set_expiry)=0
  2038 crc(ns_capable)=0
  2102 crc(path_is_under)=0
  2405 crc(register_exec_domain)=0
  2506 crc(schedule_timeout)=0
  2911 crc(sock_register)=0
  2922 crc(softirq_work_list)=0
  2996 crc(sys_close)=0
  3022 crc(task_nice)=0
  3243 crc(vfs_fsync_range)=0
  3270 crc(vm_brk)=0

On x86_32, "grep =ff100000" shows

  244 crc(__symbol_put)=ff100000
  784 crc(current_fs_time)=ff100000
  810 crc(d_tmpfile)=ff100000
  967 crc(do_sync_read)=ff100000
  1108 crc(filp_close)=ff100000
  1122 crc(finish_open)=ff100000
  1198 crc(generic_getxattr)=ff100000
  1222 crc(generic_write_sync)=ff100000
  1253 crc(get_unmapped_area)=ff100000
  1351 crc(in_group_p)=ff100000
  1423 crc(inode_add_bytes)=ff100000
  1510 crc(iov_shorten)=ff100000
  1567 crc(iterate_fd)=ff100000
  1840 crc(mnt_set_expiry)=ff100000
  2061 crc(ns_capable)=ff100000
  2126 crc(path_is_under)=ff100000
  2432 crc(register_exec_domain)=ff100000
  2535 crc(schedule_timeout)=ff100000
  2940 crc(sock_register)=ff100000
  2951 crc(softirq_work_list)=ff100000
  3013 crc(sys_close)=ff100000
  3039 crc(task_nice)=ff100000
  3261 crc(vfs_fsync_range)=ff100000
  3288 crc(vm_brk)=ff100000

Module.symvers says that these symbols have crc == 0x00000000 and
kcrctab on x86_64 says that these symbols have crc == 0x00000000 but
kcrctab on x86_32 says that these symbols have crc == 0xff100000.

Prior to commit 5c019369 "syscalls.h: use gcc alias instead of assembler
aliases for syscalls", only crc(softirq_work_list)=ff100000 line was shown.



I don't know where 0xff100000 comes from, but this value is kconfig dependent
and this value might be by error introduced.

I also tried older kernels. As far as I tested (I might be wrong as this value
is kconfig dependent), it seems that 3.9 and later kernels show
crc(softirq_work_list)=ff100000 line while 3.8 and earlier kernels show
crc(softirq_work_list)=0 line. I'll try to bisect between 3.8 and 3.9 if this
change is by error introduced.
