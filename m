Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbaHEIJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:09:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:50519 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbaHEIJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:09:43 -0400
Date: Tue, 5 Aug 2014 12:08:53 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: <linux-kernel@vger.kernel.org>, <keescook@chromium.org>, <tj@kernel.org>,
        <akpm@linux-foundation.org>, <avagin@openvz.org>,
        <ebiederm@xmission.com>, <hpa@zytor.com>, <serge.hallyn@canonical.com>,
        <xemul@parallels.com>, <segoon@openwall.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <mtk.manpages@gmail.com>,
        <jln@google.com>
Subject: Re: [patch 4/4] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP
 operation, v3
Message-ID: <20140805080852.GA32222@paralelels.com>
References: <20140804172255.109539743@openvz.org>
 <20140804172610.965949916@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20140804172610.965949916@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 09:22:59PM +0400, Cyrill Gorcunov wrote:
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
> 	prctl(PR_SET_MM, PR_SET_MM_MAP, struct prctl_mm_map *, size)
> 
> 	struct prctl_mm_map {
> 		__u64	start_code;
> 		__u64	end_code;
> 		__u64	start_data;
> 		__u64	end_data;
> 		__u64	start_brk;
> 		__u64	brk;
> 		__u64	start_stack;
> 		__u64	arg_start;
> 		__u64	arg_end;
> 		__u64	env_start;
> 		__u64	env_end;
> 		__u64	*auxv;
> 		__u32	auxv_size;
> 		__u32	exe_fd;
> 	};
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
> is executed is to inspect running program memory). Still we require
> the caller to be at least user-namespace root user.
> 
> I believe the old interface should be deprecated and ripped off
> in a couple of kernel releases if no one against.
> 
> To test if new interface is implemented in the kernel one
> can pass PR_SET_MM_MAP_SIZE opcode and the kernel returns
> the size of currently supported struct prctl_mm_map.
> 
> v2:
>  - compact macros (by keescook@)
>  - wrap new code with CONFIG_ (by akpm@)
> 
> v3 (by jln@):
>  - use __prctl_check_order for brk and start_brk
>  - use may_adjust_brk helper
>  - make sure that only root can update @exe_fd link
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrew Vagin <avagin@openvz.org>

Acked-by: Andrew Vagin <avagin@openvz.org>

I have tested this patch with criu. Everything work as expected.

Thanks.

> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Julien Tinnes <jln@google.com>
