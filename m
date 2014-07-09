Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaGIOxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:53:13 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:58810 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaGIOxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:53:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140709141318.GM17860@moon.sw.swsoft.com>
References: <20140703143318.568554771@openvz.org>
	<20140703151102.842945837@openvz.org>
	<20140708190849.GC17860@moon.sw.swsoft.com>
	<20140708143830.ea078ef01e1d7d31276edbcd@linux-foundation.org>
	<20140708221336.GL17860@moon.sw.swsoft.com>
	<20140709141318.GM17860@moon.sw.swsoft.com>
Date: Wed, 9 Jul 2014 07:53:10 -0700
X-Google-Sender-Auth: eBtJp7YGLjpWV_WV_JDvfidCsHY
Message-ID: <CAGXu5jKmTSb0YmNFDtr-jymrhy_s_PXUuvj3WKYffSU98gwyqg@mail.gmail.com>
Subject: Re: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 7:13 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Jul 09, 2014 at 02:13:36AM +0400, Cyrill Gorcunov wrote:
>>
>> Still the good news about all this members we modify -- they are used
>> for statistics mostly except brk/stack related members but they
>> are checked very carefully to not exceed the limits (if the
>> limits are set).
>>
>> > struct prctl_mm_map could do with a nice comment explaining its role in
>> > the world.
>>
>> ok, i'll update
>>
>> > I'm not seeing a coherent description of the proposed userspace
>> > interface.  We'll eventually want to update the prctl manpage for this,
>> > so how about laying out all the needed details now, at patch review
>> > time so we can see what is proposed.
>>
>> Sure, I'll write more descriptive comment since original "It takes
>> a pointer of prctl_mm_map structure which carries all members to be
>> updated" is too short.
>
> Here is a way more descriptove changelog I hope. Please poke me if
> more details needed, or something should be improved/changed and
> etc.
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
>
> During development of c/r we've noticed that in case if we need to
> support user namespaces we face a problem with capabilities in
> prctl(PR_SET_MM, ...) call, in particular once new user namespace
> is created capable(CAP_SYS_RESOURCE) no longer passes.
>
> A approach is to eliminate CAP_SYS_RESOURCE check but pass all
> new values in one bundle, which would allow the kernel to make
> more intensive test for sanity of values and same time allow us to
> support checkpoint/restore of user namespaces.
>
> Thus a new command PR_SET_MM_MAP introduced. It takes a pointer of
> prctl_mm_map structure which carries all the members to be updated.
>
>         prctl(PR_SET_MM, PR_SET_MM_MAP, struct prctl_mm_map *, size)
>
>         struct prctl_mm_map {
>                 __u64   start_code;
>                 __u64   end_code;
>                 __u64   start_data;
>                 __u64   end_data;
>                 __u64   start_brk;
>                 __u64   brk;
>                 __u64   start_stack;
>                 __u64   arg_start;
>                 __u64   arg_end;
>                 __u64   env_start;
>                 __u64   env_end;
>                 __u64   *auxv;
>                 __u32   auxv_size;
>                 __u32   exe_fd;
>         };
>
> All members except @exe_fd correspond ones of struct mm_struct.
> To figure out which available values these members may take here
> are meanings of the members.
>
>  - start_code, end_code: represent bounds of executable code area
>  - start_data, end_data: represent bounds of data area
>  - start_brk, brk: used to calculate bounds for brk() syscall
>  - start_stack: used when accounting space needed for command
>    line arguments, environment and shmat() syscall
>  - arg_start, arg_end, env_start, env_end: represent memory area
>    supplied for command line arguments and environment variables
>  - auxv, auxv_size: carries auxiliary vector, Elf format specifics
>  - exe_fd: file descriptor number for executable link (/proc/self/exe)
>
> Thus we apply the following requirements to the values
>
> 1) Any member except @auxv, @auxv_size, @exe_fd is rather an address
>    in user space thus it must be laying inside [mmap_min_addr, mmap_max_addr)
>    interval.
>
> 2) While @[start|end]_code and @[start|end]_data may point to an nonexisting
>    VMAs (say a program maps own new .text and .data segments during execution)
>    the rest of members should belong to VMA which must exist.
>
> 3) Addresses must be ordered, ie @start_ member must not be greater or
>    equal to appropriate @end_ member.
>
> 4) As in regular Elf loading procedure we require that @start_brk and
>    @brk be greater than @end_data.
>
> 5) If RLIMIT_DATA rlimit is set to non-infinity new values should not
>    exceed existing limit. Same applies to RLIMIT_STACK.
>
> 6) Auxiliary vector size must not exceed existing one (which is
>    predefined as AT_VECTOR_SIZE and depends on architecture).
>
> 7) File descriptor passed in @exe_file should be pointing
>    to executable file (because we use existing prctl_set_mm_exe_file_locked
>    helper it ensures that the file we are going to use as exe link has all
>    required permission granted).
>
> Now about where these members are involved inside kernel code:
>
>  - @start_code and @end_code are used in /proc/$pid/[stat|statm] output;
>
>  - @start_data and @end_data are used in /proc/$pid/[stat|statm] output,
>    also they are considered if there enough space for brk() syscall
>    result if RLIMIT_DATA is set;
>
>  - @start_brk shown in /proc/$pid/stat output and accounted in brk()
>    syscall if RLIMIT_DATA is set; also this member is tested to
>    find a symbolic name of mmap event for perf system (we choose
>    if event is generated for "heap" area); one more aplication is
>    selinux -- we test if a process has PROCESS__EXECHEAP permission
>    if trying to make heap area being executable with mprotect() syscall;
>
>  - @brk is a current value for brk() syscall which lays inside heap
>    area, it's shown in /proc/$pid/stat. When syscall brk() succesfully
>    provides new memory area to a user space upon brk() completion the
>    mm::brk is updated to carry new value;
>
>    Both @start_brk and @brk are actively used in /proc/$pid/maps
>    and /proc/$pid/smaps output to find a symbolic name "heap" for
>    VMA being scanned;
>
>  - @start_stack is printed out in /proc/$pid/stat and used to
>    find a symbolic name "stack" for task and threads in
>    /proc/$pid/maps and /proc/$pid/smaps output, and as the same
>    as with @start_brk -- perf system uses it for event naming.
>    Also kernel treat this member as a start address of where
>    to map vDSO pages and to check if there is enough space
>    for shmat() syscall;
>
>  - @arg_start, @arg_end, @env_start and @env_end are printed out
>    in /proc/$pid/stat. Another access to the data these members
>    represent is to read /proc/$pid/environ or /proc/$pid/cmdline.
>    Any attempt to read these areas kernel tests with access_process_vm
>    helper so a user must have enough rights for this action;
>
>  - @auxv and @auxv_size may be read from /proc/$pid/auxv. Strictly
>    speaking kernel doesn't care much about which exactly data is
>    sitting there because it is solely for userspace;
>
>  - @exe_fd is referred from /proc/$pid/exe and when generating
>    coredump. We uses prctl_set_mm_exe_file_locked helper to update
>    this member, so exe-file link modification remains one-shot
>    action.
>
> Still note that updating exe-file link now doesn't require sys-resource
> capability anymore, after all there is no much profit in preventing setup
> own file link (there are a number of ways to execute own code -- ptrace,
> ld-preload, so that the only reliable way to find which exactly code
> is executed is to inspect running program memory).
>
> I believe the old interface should be deprecated and ripped off
> in a couple of kernel releases if no one against.
>
> To test if new interface is implemented in the kernel one
> can pass PR_SET_MM_MAP_SIZE opcode and the kernel returns
> the size of currently supported struct prctl_mm_map.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> ---
>  include/uapi/linux/prctl.h |   25 +++++
>  kernel/sys.c               |  192 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 216 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.git/include/uapi/linux/prctl.h
> ===================================================================
> --- linux-2.6.git.orig/include/uapi/linux/prctl.h
> +++ linux-2.6.git/include/uapi/linux/prctl.h
> @@ -119,6 +119,31 @@
>  # define PR_SET_MM_ENV_END             11
>  # define PR_SET_MM_AUXV                        12
>  # define PR_SET_MM_EXE_FILE            13
> +# define PR_SET_MM_MAP                 14
> +# define PR_SET_MM_MAP_SIZE            15
> +
> +/*
> + * This structure provides new memory descriptor
> + * map which mostly modifies /proc/pid/stat[m]
> + * output for a task. This mostly done in a
> + * sake of checkpoint/restore functionality.
> + */
> +struct prctl_mm_map {
> +       __u64   start_code;             /* code section bounds */
> +       __u64   end_code;
> +       __u64   start_data;             /* data section bounds */
> +       __u64   end_data;
> +       __u64   start_brk;              /* heap for brk() syscall */
> +       __u64   brk;
> +       __u64   start_stack;            /* stack starts at */
> +       __u64   arg_start;              /* command line arguments bounds */
> +       __u64   arg_end;
> +       __u64   env_start;              /* environment variables bounds */
> +       __u64   env_end;
> +       __u64   *auxv;                  /* auxiliary vector */
> +       __u32   auxv_size;              /* vector size */
> +       __u32   exe_fd;                 /* /proc/$pid/exe link file */
> +};
>
>  /*
>   * Set specific pid that is allowed to ptrace the current task.
> Index: linux-2.6.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/sys.c
> +++ linux-2.6.git/kernel/sys.c
> @@ -1687,6 +1687,189 @@ exit:
>         return err;
>  }
>
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +/*
> + * WARNING: we don't require any capability here so be very careful
> + * in what is allowed for modification from userspace.
> + */
> +static int validate_prctl_map_locked(struct prctl_mm_map *prctl_map)
> +{
> +       unsigned long mmap_max_addr = TASK_SIZE;
> +       struct mm_struct *mm = current->mm;
> +       struct vm_area_struct *stack_vma;
> +       unsigned long rlim;
> +       int error = 0;
> +
> +       /*
> +        * Make sure the members are not somewhere outside
> +        * of allowed address space.
> +        */
> +#define __prctl_check_addr_space(__map, __member)                              \
> +       ({                                                                      \
> +               int __rc;                                                       \
> +               if ((unsigned long)__map->__member < mmap_max_addr &&           \
> +                   (unsigned long)__map->__member >= mmap_min_addr)            \
> +                       __rc = 0;                                               \
> +               else                                                            \
> +                       __rc = -EINVAL;                                         \
> +               __rc;                                                           \
> +       })
> +
> +       error |= __prctl_check_addr_space(prctl_map, start_code);
> +       error |= __prctl_check_addr_space(prctl_map, end_code);
> +       error |= __prctl_check_addr_space(prctl_map, start_data);
> +       error |= __prctl_check_addr_space(prctl_map, end_data);
> +       error |= __prctl_check_addr_space(prctl_map, start_stack);
> +       error |= __prctl_check_addr_space(prctl_map, start_brk);
> +       error |= __prctl_check_addr_space(prctl_map, brk);
> +       error |= __prctl_check_addr_space(prctl_map, arg_start);
> +       error |= __prctl_check_addr_space(prctl_map, arg_end);
> +       error |= __prctl_check_addr_space(prctl_map, env_start);
> +       error |= __prctl_check_addr_space(prctl_map, env_end);
> +       if (error)
> +               goto out;
> +#undef __prctl_check_addr_space
> +
> +       /*
> +        * Stack, brk, command line arguments and environment must exist.
> +        */
> +       stack_vma = find_vma(mm, (unsigned long)prctl_map->start_stack);
> +       if (!stack_vma) {
> +               error = -EINVAL;
> +               goto out;
> +       }
> +#define __prctl_check_vma(mm, addr) find_vma(mm, (unsigned long)addr) ? 0 : -EINVAL
> +       error |= __prctl_check_vma(mm, prctl_map->start_brk);
> +       error |= __prctl_check_vma(mm, prctl_map->brk);
> +       error |= __prctl_check_vma(mm, prctl_map->arg_start);
> +       error |= __prctl_check_vma(mm, prctl_map->arg_end);
> +       error |= __prctl_check_vma(mm, prctl_map->env_start);
> +       error |= __prctl_check_vma(mm, prctl_map->env_end);
> +       if (error)
> +               goto out;
> +#undef __prctl_check_vma
> +
> +       /*
> +        * Make sure the pairs are ordered.
> +        */
> +#define __prctl_check_order(__map, __m1, __m2)                                 \
> +       (unsigned long)__map->__m2 <= (unsigned long)__map->__m1
> +       if (__prctl_check_order(prctl_map, start_code, end_code)        ||
> +           __prctl_check_order(prctl_map, start_data, end_data)        ||
> +           __prctl_check_order(prctl_map, arg_start, arg_end)          ||
> +           __prctl_check_order(prctl_map, env_start, env_end))
> +               goto out;
> +#undef __prctl_check_order

This approach seems like a good solution given the security concerns
with the earlier approach. I'm still pondering the implications, but
as a minor style note, these macros are locally defined, but also all
take at least a single identical argument in every usage. I would
think it might be easier to read if they just used what they needed to
directly.

#define __prctl_check_addr_space(__member)     \
      ((unsigned long)prctl_map->__member < mmap_max_addr &&           \
       (unsigned long)prctl_map->__member >= mmap_min_addr) ? 0 : -EINVAL

#define __prctl_check_vma(__member) \
           find_vma(mm, (unsigned long)prctl_map->__member) ? 0 : -EINVAL

Also, why change the symantics of the final macro? Seems like that one
can use the same "error |=" style:

#define __prctl_check_order(__m1, __m2)         \
      prctl_map->__m1 < prctl_map->__m2 ? 0 : -EINVAL

-Kees

-- 
Kees Cook
Chrome OS Security
