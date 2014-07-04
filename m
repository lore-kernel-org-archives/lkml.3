Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981AbaGDHxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:53:30 -0400
Received: from relay.parallels.com ([195.214.232.42]:51332 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaGDHxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:53:24 -0400
Date: Fri, 4 Jul 2014 11:52:56 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
Message-ID: <20140704075256.GA5105@paralelels.com>
References: <20140703143318.568554771@openvz.org>
 <20140703151102.842945837@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20140703151102.842945837@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.24.36.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 06:33:20PM +0400, Cyrill Gorcunov wrote:
> During development of c/r we've noticed that in case if we need to
> support user namespaces we face a problem with capabilities in
> prctl(PR_SET_MM, ...) call.
> 
> Current PR_SET_MM code forbids to modify fields if no CAP_SYS_RESOURCE
> granted, but rather relies on one who use this interface is passing
> more-less sane values (though the values must pass the basic validation
> procedure).
> 
> It seems a better approach is to eliminate CAP_SYS_RESOURCE check but
> provide all new values in one bundle, which would allow the kernel to make
> more intensive test for sanity of values and same time allow us to
> support checkpoint/restore of user namespaces.
> 
> Thus a new command (PR_SET_MM_MAP) introduced. It takes a pointer of
> prctl_mm_map structure which carries all members to be updated.
> 
> Most intensive work is done in validate_prctl_map_locked helper,
> because we need to make sure the values are valid. Thus we do
> 
>  - check the values are laying inside available user address space
>  - stack, brk, command line arguments and evnironment variables
>    must point to already existing VMA
>  - values must be ordered (start < end)
>  - if RLIMITs are defined don't allow to exceed it with new values
> 
> Since it uses prctl_set_mm_exe_file_locked helper, updating the
> exe-file link is one-shot action for security reason.
> 
> I believe the old interface should be deprecated and ripped off
> in a couple of kernel releases if noone against.
> 
> To test if new interface is implemented in the kernel one
> can pass PR_SET_MM_MAP_SIZE opcode and the kernel returns
> the size of currently supported struct prctl_mm_map.

I like the idea of this patch. See a few comments inline

> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> ---
>  include/uapi/linux/prctl.h |   19 ++++
>  kernel/sys.c               |  188 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 206 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.git/include/uapi/linux/prctl.h
> ===================================================================
> --- linux-2.6.git.orig/include/uapi/linux/prctl.h
> +++ linux-2.6.git/include/uapi/linux/prctl.h
> @@ -119,6 +119,25 @@
>  # define PR_SET_MM_ENV_END		11
>  # define PR_SET_MM_AUXV			12
>  # define PR_SET_MM_EXE_FILE		13
> +# define PR_SET_MM_MAP			14
> +# define PR_SET_MM_MAP_SIZE		15
> +
> +struct prctl_mm_map {
> +	unsigned long	start_code;

"unsigned long" has different sizes on x86_64 and x86, so a compat
is required for x32 processes on x64 kernel.

> +	unsigned long	end_code;
> +	unsigned long	start_data;
> +	unsigned long	end_data;
> +	unsigned long	start_brk;
> +	unsigned long	brk;

...

> +
> +	error |= __prctl_check_addr_space(prctl_map, start_code);
> +	error |= __prctl_check_addr_space(prctl_map, end_code);
> +	error |= __prctl_check_addr_space(prctl_map, start_data);
> +	error |= __prctl_check_addr_space(prctl_map, end_data);
> +	error |= __prctl_check_addr_space(prctl_map, start_stack);
> +	error |= __prctl_check_addr_space(prctl_map, start_brk);
> +	error |= __prctl_check_addr_space(prctl_map, brk);
> +	error |= __prctl_check_addr_space(prctl_map, arg_start);
> +	error |= __prctl_check_addr_space(prctl_map, arg_end);
> +	error |= __prctl_check_addr_space(prctl_map, env_start);
> +	error |= __prctl_check_addr_space(prctl_map, env_end);
> +	if (error)
> +		goto out;
> +#undef __prctl_check_addr_space
> +
> +	/*
> +	 * Stack, brk, command line arguments and environment must exist.
> +	 */
> +	stack_vma = find_vma(mm, prctl_map->start_stack);

Why do we not use __prctl_check_vma here?

> +	if (!stack_vma) {
> +		error = -EINVAL;
> +		goto out;
> +	}
> +#define __prctl_check_vma(mm, addr) find_vma(mm, addr) ? 0 : -EINVAL
> +	error |= __prctl_check_vma(mm, prctl_map->start_brk);
> +	error |= __prctl_check_vma(mm, prctl_map->brk);
> +	error |= __prctl_check_vma(mm, prctl_map->arg_start);
> +	error |= __prctl_check_vma(mm, prctl_map->arg_end);
> +	error |= __prctl_check_vma(mm, prctl_map->env_start);
> +	error |= __prctl_check_vma(mm, prctl_map->env_end);
> +	if (error)
> +		goto out;
> +#undef __prctl_check_vma
> 
