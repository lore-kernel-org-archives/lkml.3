Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbbAUAFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:05:05 -0500
Received: from smtp102.biz.mail.bf1.yahoo.com ([98.139.221.61]:26820 "EHLO
	smtp102.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbbAUAFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:05:04 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pVvtP6kVM1ksOZgrKHcBHlStdV8vHs3LCXQfyPGB1CSDEFS
 n1P2SrWD8Q.qdq3_mDjJbTDYJEXLTvP9RrDjkR.POLApGiW6nKBFUoTM2Mio
 ShnT5VH0bC5V6WuO5kxYJlWWUkIr2MFa1Q_TgSgjvSI6WydnA99zCD9BqKhg
 l.5xU78RVgcJ6XHbYfNnXrFM.IfzIi2JyKXuqOMkkmAnMCwd6V8zwGgpry3s
 EFz5zusYMXJemSfWA5xxau2cA4yB4zn04yjJO1RGy3ygrTV78oE7guiOykBI
 jf79Kmns1muliEteuQofkAgQWFQEFGXO3npVlX3CDuFHc07uWDjDqx5lS1aQ
 R5Jb_J3MOymFSoyRfTEChrfozlCqJUIHiHcWxNIxpeqCJOxQ8sdCcrX0.cIj
 A9eyq6udUnYmTIA2dNRkrGxPpFaAYYNq6pF8.WET0ffkKvygokQnT0hueUjV
 eto2YIk6QukV7F_BdMEF0xdQxFGR4SQ3loA_HscwjSVFsNzbMfWpmE8k3Fbv
 z8HU7bk3vriat2yrBqZNgD9qkIw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54BEED2C.2000000@schaufler-ca.com>
Date: Tue, 20 Jan 2015 16:05:00 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Iulia Manda <iulia.manda21@gmail.com>, serge.hallyn@canonical.com
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, peterz@infradead.org, mhocko@suse.cz
Subject: Re: [PATCH] kernel: Conditionally support non-root users, groups
 and capabilities
References: <20150120233308.GA6256@winterfell>
In-Reply-To: <20150120233308.GA6256@winterfell>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/2015 3:33 PM, Iulia Manda wrote:
> There are a lot of embedded systems that run most or all of their functionality
> in init, running as root:root. For these systems, supporting multiple users is
> not necessary.
>
> This patch adds a new symbol, CONFIG_NON_ROOT, that makes support for non-root
> users, non-root groups, and capabilities optional.
>
> When this symbol is not defined, UID and GID are zero in any possible case
> and processes always have all capabilities.
>
> Also, the following syscalls are compiled out: setuid, setregid, setgid,
> setreuid, setresuid, getresuid, setresgid, getresgid, setgroups, getgroups,
> setfsuid, setfsgid, capget, capset.
>
> This change saves about 25 KB on a defconfig build.
>
> Bloat-o-meter output:
> add/remove: 7/66 grow/shrink: 21/421 up/down: 1701/-27172 (-25471)
>
> Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Authoritative LSM hooks were loudly rejected in or about 1999.
One of the primary reasons they were rejected was because you could
use them do exactly what this patch does, which is to remove the basic
Linux security policy. If attitudes have changed sufficiently that
removing the "classic" security behavior is now deemed acceptable,
I propose that we reintroduce the option of authoritative LSM hooks
instead. That would give you all this saving, and probably more.


> ---
>  include/linux/capability.h |   12 ++++++++++++
>  include/linux/uidgid.h     |   12 ++++++++++++
>  init/Kconfig               |   19 ++++++++++++++++++-
>  kernel/capability.c        |    6 ++++++
>  kernel/groups.c            |    4 ++++
>  kernel/sys.c               |    2 ++
>  kernel/sys_ni.c            |   14 ++++++++++++++
>  7 files changed, 68 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index aa93e5e..d8791d2 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -211,8 +211,20 @@ extern bool has_ns_capability(struct task_struct *t,
>  extern bool has_capability_noaudit(struct task_struct *t, int cap);
>  extern bool has_ns_capability_noaudit(struct task_struct *t,
>  				      struct user_namespace *ns, int cap);
> +#ifdef CONFIG_NON_ROOT
>  extern bool capable(int cap);
>  extern bool ns_capable(struct user_namespace *ns, int cap);
> +#else
> +static inline bool capable(int cap)
> +{
> +	return true;
> +}
> +
> +static inline bool ns_capable(struct user_namespace *ns, int cap)
> +{
> +	return true;
> +}
> +#endif /* CONFIG_NON_ROOT */
>  extern bool capable_wrt_inode_uidgid(const struct inode *inode, int cap);
>  extern bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap);
>  
> diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
> index 2d1f9b6..22bd1fa 100644
> --- a/include/linux/uidgid.h
> +++ b/include/linux/uidgid.h
> @@ -29,6 +29,7 @@ typedef struct {
>  #define KUIDT_INIT(value) (kuid_t){ value }
>  #define KGIDT_INIT(value) (kgid_t){ value }
>  
> +#ifdef CONFIG_NON_ROOT
>  static inline uid_t __kuid_val(kuid_t uid)
>  {
>  	return uid.val;
> @@ -38,6 +39,17 @@ static inline gid_t __kgid_val(kgid_t gid)
>  {
>  	return gid.val;
>  }
> +#else
> +static inline uid_t __kuid_val(kuid_t uid)
> +{
> +	return 0;
> +}
> +
> +static inline gid_t __kgid_val(kgid_t gid)
> +{
> +	return 0;
> +}
> +#endif
>  
>  #define GLOBAL_ROOT_UID KUIDT_INIT(0)
>  #define GLOBAL_ROOT_GID KGIDT_INIT(0)
> diff --git a/init/Kconfig b/init/Kconfig
> index 9afb971..dc5bfd4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -394,6 +394,7 @@ endchoice
>  
>  config BSD_PROCESS_ACCT
>  	bool "BSD Process Accounting"
> +	select NON_ROOT
>  	help
>  	  If you say Y here, a user level program will be able to instruct the
>  	  kernel (via a special system call) to write process accounting
> @@ -420,6 +421,7 @@ config BSD_PROCESS_ACCT_V3
>  config TASKSTATS
>  	bool "Export task/process statistics through netlink"
>  	depends on NET
> +	select NON_ROOT
>  	default n
>  	help
>  	  Export selected statistics for tasks/processes through the
> @@ -1140,6 +1142,7 @@ config CHECKPOINT_RESTORE
>  
>  menuconfig NAMESPACES
>  	bool "Namespaces support" if EXPERT
> +	depends on NON_ROOT
>  	default !EXPERT
>  	help
>  	  Provides the way to make tasks work with different objects using
> @@ -1352,11 +1355,25 @@ menuconfig EXPERT
>  
>  config UID16
>  	bool "Enable 16-bit UID system calls" if EXPERT
> -	depends on HAVE_UID16
> +	depends on HAVE_UID16 && NON_ROOT
>  	default y
>  	help
>  	  This enables the legacy 16-bit UID syscall wrappers.
>  
> +config NON_ROOT
> +	bool "Multiple users, groups and capabilities support" if EXPERT
> +	default y
> +	help
> +	  This option enables support for non-root users, groups and
> +	  capabilities.
> +
> +	  If you say N here, all processes will run with UID 0, GID 0, and all
> +	  possible capabilities.  Saying N here also compiles out support for
> +	  system calls related to UIDs, GIDs, and capabilities, such as setuid,
> +	  setgid, and capset.
> +
> +	  If unsure, say Y here.
> +
>  config SGETMASK_SYSCALL
>  	bool "sgetmask/ssetmask syscalls support" if EXPERT
>  	def_bool PARISC || MN10300 || BLACKFIN || M68K || PPC || MIPS || X86 || SPARC || CRIS || MICROBLAZE || SUPERH
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 989f5bf..bead84a 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -35,6 +35,7 @@ static int __init file_caps_disable(char *str)
>  }
>  __setup("no_file_caps", file_caps_disable);
>  
> +#ifdef CONFIG_NON_ROOT
>  /*
>   * More recent versions of libcap are available from:
>   *
> @@ -279,6 +280,7 @@ error:
>  	abort_creds(new);
>  	return ret;
>  }
> +#endif
>  
>  /**
>   * has_ns_capability - Does a task have a capability in a specific user ns
> @@ -360,6 +362,7 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
>  	return has_ns_capability_noaudit(t, &init_user_ns, cap);
>  }
>  
> +#ifdef CONFIG_NON_ROOT
>  /**
>   * ns_capable - Determine if the current task has a superior capability in effect
>   * @ns:  The usernamespace we want the capability in
> @@ -385,6 +388,7 @@ bool ns_capable(struct user_namespace *ns, int cap)
>  	return false;
>  }
>  EXPORT_SYMBOL(ns_capable);
> +#endif
>  
>  /**
>   * file_ns_capable - Determine if the file's opener had a capability in effect
> @@ -411,6 +415,7 @@ bool file_ns_capable(const struct file *file, struct user_namespace *ns,
>  }
>  EXPORT_SYMBOL(file_ns_capable);
>  
> +#ifdef CONFIG_NON_ROOT
>  /**
>   * capable - Determine if the current task has a superior capability in effect
>   * @cap: The capability to be tested for
> @@ -426,6 +431,7 @@ bool capable(int cap)
>  	return ns_capable(&init_user_ns, cap);
>  }
>  EXPORT_SYMBOL(capable);
> +#endif
>  
>  /**
>   * capable_wrt_inode_uidgid - Check nsown_capable and uid and gid mapped
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 664411f..94f2c89 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -190,6 +190,7 @@ int set_current_groups(struct group_info *group_info)
>  
>  EXPORT_SYMBOL(set_current_groups);
>  
> +#ifdef CONFIG_NON_ROOT
>  SYSCALL_DEFINE2(getgroups, int, gidsetsize, gid_t __user *, grouplist)
>  {
>  	const struct cred *cred = current_cred();
> @@ -213,6 +214,7 @@ SYSCALL_DEFINE2(getgroups, int, gidsetsize, gid_t __user *, grouplist)
>  out:
>  	return i;
>  }
> +#endif
>  
>  bool may_setgroups(void)
>  {
> @@ -227,6 +229,7 @@ bool may_setgroups(void)
>   *	without another task interfering.
>   */
>  
> +#ifdef CONFIG_NON_ROOT
>  SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
>  {
>  	struct group_info *group_info;
> @@ -251,6 +254,7 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
>  
>  	return retval;
>  }
> +#endif
>  
>  /*
>   * Check whether we're fsgid/egid or in the supplemental group..
> diff --git a/kernel/sys.c b/kernel/sys.c
> index a8c9f5a..bfe532b 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -319,6 +319,7 @@ out_unlock:
>   * SMP: There are not races, the GIDs are checked only by filesystem
>   *      operations (as far as semantic preservation is concerned).
>   */
> +#ifdef CONFIG_NON_ROOT
>  SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)
>  {
>  	struct user_namespace *ns = current_user_ns();
> @@ -809,6 +810,7 @@ change_okay:
>  	commit_creds(new);
>  	return old_fsgid;
>  }
> +#endif /* CONFIG_NON_ROOT */
>  
>  /**
>   * sys_getpid - return the thread group id of the current process
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index 5adcb0a..7995ef5 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -159,6 +159,20 @@ cond_syscall(sys_uselib);
>  cond_syscall(sys_fadvise64);
>  cond_syscall(sys_fadvise64_64);
>  cond_syscall(sys_madvise);
> +cond_syscall(sys_setuid);
> +cond_syscall(sys_setregid);
> +cond_syscall(sys_setgid);
> +cond_syscall(sys_setreuid);
> +cond_syscall(sys_setresuid);
> +cond_syscall(sys_getresuid);
> +cond_syscall(sys_setresgid);
> +cond_syscall(sys_getresgid);
> +cond_syscall(sys_setgroups);
> +cond_syscall(sys_getgroups);
> +cond_syscall(sys_setfsuid);
> +cond_syscall(sys_setfsgid);
> +cond_syscall(sys_capget);
> +cond_syscall(sys_capset);
>  
>  /* arch-specific weak syscall entries */
>  cond_syscall(sys_pciconfig_read);

