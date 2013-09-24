Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3IXDoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 23:44:05 -0400
Received: from intranet.asianux.com ([58.214.24.6]:54043 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3IXDoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 23:44:02 -0400
X-Spam-Score: -100.7
Message-ID: <52410A40.1000304@asianux.com>
Date: Tue, 24 Sep 2013 11:42:56 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info'
 in all related extern functions
References: <5212DBFA.8030805@asianux.com> <20130923150625.GB14547@htj.dyndns.org>
In-Reply-To: <20130923150625.GB14547@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 11:06 PM, Tejun Heo wrote:
> Hello,
> 
> (I have no idea about this but Andrew tagged me, probably thinking it
> was related to cgroups, so here it goes ;)
> 

First, thank you for spending your time resource to discuss this patch.


> On Tue, Aug 20, 2013 at 11:01:14AM +0800, Chen Gang wrote:
>> groups_alloc() can return NULL for 'group_info', also group_search()
>> already considers about NULL for 'group_info', so can assume the caller
>> has right to use all related extern functions when 'group_info' is NULL.
>>
>> For groups_free(), need check NULL to match groups_alloc(), just like
>> kmalloc/free().
> 
> While it is somewhat customary to make free routines handle NULL
> inputs, the convention isn't a very strong one and given that the
> above change doesn't actually benefit any of the existing use cases,
> it seems gratuituous.
> 

Hmm... can user be permitted to call other system call (e.g. getgroups)
before call groups_alloc()? (may the user space already give check, but
for our kernel, we can not only depend on their checking).

According to group_alloc() and setgroups() usage in kernel source code,
'group_info' may be not set if kernel/process is running (although user
space may be sure "if kernel is running, 'group_info' must be set").

The below is the proof for "kernel itself can not be sure 'group_info'
must be set during kernel/process is running", please check, thanks.



The related usage of group_alloc() is below:

  arch/s390/kernel/compat_linux.c:257:	group_info = groups_alloc(gidsetsize);
  drivers/staging/lustre/lustre/include/linux/lustre_common.h:10:	ginfo = groups_alloc(0);
  drivers/staging/lustre/lustre/ptlrpc/service.c:2287:	ginfo = groups_alloc(0);
  fs/nfsd/auth.c:46:		gi = groups_alloc(0);
  fs/nfsd/auth.c:55:		gi = groups_alloc(rqgi->ngroups);
  kernel/uid16.c:184:	group_info = groups_alloc(gidsetsize);  /* called by setgroups16 */
  kernel/groups.c:241:	group_info = groups_alloc(gidsetsize);  /* called by setgroups */
  net/sunrpc/svcauth_unix.c:506:	ug.gi = groups_alloc(gids);
  net/sunrpc/svcauth_unix.c:752:	cred->cr_group_info = groups_alloc(0);
  net/sunrpc/svcauth_unix.c:823:	cred->cr_group_info = groups_alloc(slen);
  net/sunrpc/auth_gss/gss_rpc_xdr.c:218:	creds->cr_group_info = groups_alloc(N);
  net/sunrpc/auth_gss/svcauth_gss.c:467:		rsci.cred.cr_group_info = groups_alloc(N);

  except "kernel/*", others are all related with sub-systems or architectures, so we need search 'setgroups'.

The related usage of setgroups() is below:

  arch/ia64/include/uapi/asm/unistd.h:69:#define __NR_setgroups			1078
  arch/ia64/kernel/entry.S:1531:	data8 sys_setgroups
  arch/ia64/kernel/fsys.S:606:	data8 0				// setgroups
  arch/microblaze/include/uapi/asm/unistd.h:95:#define __NR_setgroups		81 /* ok */
  arch/microblaze/include/uapi/asm/unistd.h:222:#define __NR_setgroups32	206 /* ok - without 32 */
  arch/microblaze/kernel/syscall_table.S:84:	.long sys_setgroups
  arch/microblaze/kernel/syscall_table.S:209:	.long sys_setgroups
  arch/arm64/include/asm/unistd32.h:105:__SYSCALL(81,  sys_setgroups16)
  arch/arm64/include/asm/unistd32.h:230:__SYSCALL(206, sys_setgroups)
  arch/mn10300/include/uapi/asm/unistd.h:95:#define __NR_setgroups		 81
  arch/mn10300/include/uapi/asm/unistd.h:220:#define __NR_setgroups32	206
  arch/mn10300/kernel/entry.S:511:	.long sys_setgroups16
  arch/mn10300/kernel/entry.S:636:	.long sys_setgroups
  arch/m68k/include/uapi/asm/unistd.h:89:#define __NR_setgroups		 81
  arch/m68k/include/uapi/asm/unistd.h:214:#define __NR_setgroups32	206
  arch/m68k/kernel/syscalltable.S:104:	.long sys_setgroups16
  arch/m68k/kernel/syscalltable.S:229:	.long sys_setgroups
  arch/sparc/include/uapi/asm/unistd.h:120:#define __NR_setgroups           80 /* Common                                      */
  arch/sparc/include/uapi/asm/unistd.h:123:#define __NR_setgroups32         82 /* Linux sparc32, setpgrp under SunOS          */
  arch/sparc/kernel/systbls_64.S:37:/*80*/	.word sys_setgroups16, sys_getpgrp, sys_setgroups, compat_sys_setitimer, sys32_ftruncate64
  arch/sparc/kernel/systbls_64.S:115:/*80*/	.word sys_setgroups, sys_getpgrp, sys_nis_syscall, sys_setitimer, sys_nis_syscall
  arch/sparc/kernel/systbls_32.S:35:/*80*/	.long sys_setgroups16, sys_getpgrp, sys_setgroups, sys_setitimer, sys_ftruncate64
  arch/alpha/include/uapi/asm/unistd.h:84:#define __NR_setgroups		 80
  arch/alpha/kernel/systbls.S:94:	.quad sys_setgroups			/* 80 */
  arch/sh/include/uapi/asm/unistd_64.h:98:#define __NR_setgroups		 81
  arch/sh/include/uapi/asm/unistd_64.h:223:#define __NR_setgroups32	206
  arch/sh/include/uapi/asm/unistd_32.h:93:#define __NR_setgroups		 81
  arch/sh/include/uapi/asm/unistd_32.h:218:#define __NR_setgroups32	206
  arch/sh/kernel/syscalls_64.S:104:	.long sys_setgroups16
  arch/sh/kernel/syscalls_64.S:229:	.long sys_setgroups
  arch/sh/kernel/syscalls_32.S:100:	.long sys_setgroups16
  arch/sh/kernel/syscalls_32.S:225:	.long sys_setgroups
  arch/m32r/include/uapi/asm/unistd.h:214:#define __NR_setgroups32	206
  arch/m32r/include/asm/unistd.h:39:#define __IGNORE_setgroups
  arch/m32r/kernel/syscall_table.S:83:	.long sys_ni_syscall		/* setgroups16 syscall holder */
  arch/m32r/kernel/syscall_table.S:208:	.long sys_setgroups
  arch/xtensa/include/uapi/asm/unistd.h:431:#define __NR_setgroups 				197
  arch/xtensa/include/uapi/asm/unistd.h:432:__SYSCALL(197, sys_setgroups, 2)
  arch/mips/include/uapi/asm/unistd.h:104:#define __NR_setgroups			(__NR_Linux +  81)
  arch/mips/include/uapi/asm/unistd.h:503:#define __NR_setgroups			(__NR_Linux + 114)
  arch/mips/include/uapi/asm/unistd.h:829:#define __NR_setgroups			(__NR_Linux + 114)
  arch/mips/kernel/scall64-64.S:232:	PTR	sys_setgroups
  arch/mips/kernel/scall64-n32.S:221:	PTR	sys_setgroups
  arch/mips/kernel/scall32-o32.S:317:	sys	sys_setgroups		2
  arch/mips/kernel/scall64-o32.S:276:	PTR	sys_setgroups
  arch/frv/include/uapi/asm/unistd.h:89:#define __NR_setgroups		 81
  arch/frv/include/uapi/asm/unistd.h:215:#define __NR_setgroups32	206
  arch/frv/kernel/entry.S:1261:	.long sys_setgroups16
  arch/frv/kernel/entry.S:1386:	.long sys_setgroups
  arch/parisc/hpux/sys_hpux.c:561:	"setgroups",              /* 80 */
  arch/parisc/include/uapi/asm/unistd.h:91:#define __NR_HPUX_setgroups              80
  arch/parisc/include/uapi/asm/unistd.h:574:#define __NR_setgroups           (__NR_Linux + 81)
  arch/parisc/kernel/syscall_table.S:155:	ENTRY_SAME(setgroups)
  arch/s390/include/uapi/asm/unistd.h:305:#define __NR_setgroups		 81
  arch/s390/include/uapi/asm/unistd.h:332:#define __NR_setgroups32	206
  arch/s390/include/uapi/asm/unistd.h:360:#define __NR_setgroups  	206
  arch/s390/kernel/compat_linux.c:247:asmlinkage long sys32_setgroups16(int gidsetsize, u16 __user *grouplist)
  arch/s390/kernel/compat_wrapper.S:276:ENTRY(sys32_setgroups16_wrapper)
  arch/s390/kernel/compat_wrapper.S:279:	jg	sys32_setgroups16	# branch to system call
  arch/s390/kernel/compat_wrapper.S:696:ENTRY(sys32_setgroups_wrapper)
  arch/s390/kernel/compat_wrapper.S:699:	jg	sys_setgroups		# branch to system call
  arch/s390/kernel/syscalls.S:92:SYSCALL(sys_setgroups16,sys_ni_syscall,sys32_setgroups16_wrapper)	/* old setgroups16 syscall */
  arch/s390/kernel/syscalls.S:217:SYSCALL(sys_setgroups,sys_setgroups,sys32_setgroups_wrapper)
  arch/s390/kernel/compat_linux.h:92:long sys32_setgroups16(int gidsetsize, u16 __user *grouplist);
  arch/powerpc/include/uapi/asm/unistd.h:94:#define __NR_setgroups		 81
  arch/powerpc/include/asm/systbl.h:88:SYSCALL_SPU(setgroups)
  arch/arm/include/uapi/asm/unistd.h:109:#define __NR_setgroups			(__NR_SYSCALL_BASE+ 81)
  arch/arm/include/uapi/asm/unistd.h:234:#define __NR_setgroups32		(__NR_SYSCALL_BASE+206)
  arch/arm/kernel/calls.S:93:		CALL(sys_setgroups16)
  arch/arm/kernel/calls.S:218:		CALL(sys_setgroups)
  arch/cris/arch-v10/kernel/entry.S:687:	.long sys_setgroups16
  arch/cris/arch-v10/kernel/entry.S:812:	.long sys_setgroups
  arch/cris/include/uapi/asm/unistd.h:89:#define __NR_setgroups		 81
  arch/cris/include/uapi/asm/unistd.h:214:#define __NR_setgroups32	206
  arch/cris/arch-v32/kernel/entry.S:633:	.long sys_setgroups16
  arch/cris/arch-v32/kernel/entry.S:758:	.long sys_setgroups
  arch/avr32/include/uapi/asm/unistd.h:96:#define __NR_setgroups		 81
  arch/avr32/kernel/syscall_table.S:97:	.long	sys_setgroups
  arch/x86/syscalls/syscall_32.tbl:90:81	i386	setgroups		sys_setgroups16
  arch/x86/syscalls/syscall_32.tbl:215:206	i386	setgroups32		sys_setgroups
  arch/x86/syscalls/syscall_64.tbl:125:116	common	setgroups		sys_setgroups
  arch/blackfin/include/uapi/asm/unistd.h:93:#define __NR_setgroups		 81
  arch/blackfin/include/uapi/asm/unistd.h:218:#define __NR_setgroups32	206
  arch/blackfin/mach-common/entry.S:1395:	.long _sys_setgroups	/* setgroups16 */
  arch/blackfin/mach-common/entry.S:1520:	.long _sys_setgroups
  include/uapi/linux/capability.h:134:/* Allows setgroups(2) */
  include/uapi/asm-generic/unistd.h:456:#define __NR_setgroups 159
  include/uapi/asm-generic/unistd.h:457:__SYSCALL(__NR_setgroups, sys_setgroups)
  include/linux/syscalls.h:236:asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist);
  include/linux/syscalls.h:521:asmlinkage long sys_setgroups16(int gidsetsize, old_gid_t __user *grouplist);
  kernel/sys_ni.c:132:cond_syscall(sys_setgroups16);
  kernel/uid16.c:174:SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
  kernel/groups.c:231:SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)

  all of them are for definitions or declarations.

The related conclusion:

  during kernel startup or process creation, kernel does not intend to set 'group_info'.


>> For set_groups(), can allow the caller to set NULL parameter to new
>> 'cred'.
>>
>> For system call getgroups(), if 'cred->group_info' is NULL, need return
>> the related error code (no related data), also need change the related
>> man page ("man 2 getgroups") to complete the return value.
> 
> How can cred->group_info be NULL?  Can you please describe what issue
> this patch is trying to solve / improve?  The patch description
> explains what's being changed but doesn't really offer why such
> changes are being made.  Can you please explain why this change is
> beneficial?
> 

In extern function groups_search (which also called by export function
in_group_p and in_egroup_p), it checks "if 'cred->group_info' is NULL".

So "kernel/groups.c" have 9 extern/export/system-call functions, and
4/9 notice about "if 'cred->group_info' is NULL" (e.g. groups_alloc,
groups_search, in_group_p, in_egroup_p).

So for API self-consistency, all of extern/export/system-call functions
need notice about it.

> Thanks.
> 

Thanks
-- 
Chen Gang
