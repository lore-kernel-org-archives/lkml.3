Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbbAJOSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 09:18:32 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65027 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbbAJOSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:18:31 -0500
Message-ID: <54B134AE.1070202@gmail.com>
Date: Sat, 10 Jan 2015 15:18:22 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: mtk.manpages@gmail.com, Qiaowei Ren <qiaowei.ren@intel.com>,
        linux-man@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] prctl.2: Add description of Intel MPX calls
References: <1420828573-21527-1-git-send-email-dave.hansen@intel.com>
In-Reply-To: <1420828573-21527-1-git-send-email-dave.hansen@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 07:36 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@intel.com>
> 
> The 3.19 kernel will have support for Intel MPX, including a pair
> of new prctl() calls for enabling and disabling the kernel's
> management of the "bounds tables".  Add some descriptions of the
> interface.
> 
> The kernel patches were written by myself and another Intel
> developer.

Thanks for the revision, Dave.

Applied (with a few light edits).

Cheers,

Michael


> Signed-off-by: Dave Hansen <dave.hansen@intel.com>
> Cc: Qiaowei Ren <qiaowei.ren@intel.com>
> Cc: linux-man@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  man2/prctl.2 | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index 4efabcf..dd0448e 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -47,6 +47,7 @@
>  .\"                             PR_GET_TIMERSLACK
>  .\" 2013-01-10 Kees Cook, document PR_SET_PTRACER
>  .\" 2012-02-04 Michael kerrisk, document PR_{SET,GET}_CHILD_SUBREAPER
> +.\" 2014-11-10 Dave Hansen, document PR_MPX_{EN,DIS}ABLE_MANAGEMENT
>  .\"
>  .\"
>  .TH PRCTL 2 2014-04-14 "Linux" "Linux Programmer's Manual"
> @@ -799,6 +800,59 @@ in a process life time.
>  Any further attempts will be rejected.
>  This should help system administrators monitor unusual
>  symbolic-link transitions over all processes running on a system.
> +.TP
> +.BR PR_MPX_ENABLE_MANAGEMENT / PR_MPX_DISABLE_MANAGEMENT " (since Linux 3.19) "
> +.\" commit fe3d197f84319d3bce379a9c0dc17b1f48ad358c
> +.\" See also http://lwn.net/Articles/582712/
> +.\" See also https://gcc.gnu.org/wiki/Intel%20MPX%20support%20in%20the%20GCC%20compiler
> +
> +Control the kernel's management of Memory Protection eXtensions (MPX)
> +bounds tables.
> +
> +MPX is a hardware-assisted mechanism for performing bounds checking on
> +pointers.  It consists of a set of registers storing bounds information
> +and a set of special instruction prefixes that tell the CPU on which
> +instructions it should do bounds enforcement.   There is a limited
> +number of these registers and when there are more pointers than
> +registers, their contents must be "spilled" in to a set of tables.
> +These tables are called "bounds tables" and these prctl()s control
> +whether the kernel manages their allocation and freeing.
> +
> +When management is enabled, the kernel will take over allocation
> +and freeing of the bounds tables.  It does this by trapping the #BR
> +exceptions that result at first use of missing bounds tables and
> +instead of delivering the exception to userspace, it allocates the
> +table and populates the bounds directory with the location of the
> +new table.  For freeing, the kernel checks to see if bounds tables are
> +present for memory which is not allocated, and frees them if so.
> +
> +Before enabling MPX management using PR_MPX_ENABLE_MANAGEMENT,
> +the application must first have allocated a user-space buffer for
> +the bounds directory and placed the location of that directory in
> +the bndcfgu register.
> +
> +These calls will fail if the CPU or kernel does not support MPX.
> +Kernel support for MPX is enabled via the
> +.BR CONFIG_X86_INTEL_MPX
> +configuration option.
> +You can check whether the CPU supports MPX by looking for the 'mpx'
> +CPUID bit, like with the following command:
> +
> +	cat /proc/cpuinfo | grep ' mpx '
> +
> +A thread may not switch in or out of long (64-bit) mode while MPX is
> +enabled.
> +
> +All threads in a process are affected by these calls.
> +
> +The child of a fork(2) will inherit the state of MPX management.
> +
> +During an execve(2) call, MPX management will be reset to a state
> +as if PR_MPX_DISABLE_MANAGEMENT had been called.
> +
> +For further information on Intel MPX, see the kernel source file
> +.IR Documentation/x86/intel_mpx.txt .
> +
>  .RE
>  .\"
>  .SH RETURN VALUE
> @@ -1062,6 +1116,15 @@ is not valid.
>  .\" is
>  .\" .BR PR_SET_SECCOMP ,
>  .\" and secure computing mode is already 1.
> +.TP
> +.B ENXIO
> +.I option
> +is PR_MPX_ENABLE_MANAGEMENT and the kernel was unable to enable
> +management.  Ensure the kernel and processor have MPX support.
> +.TP
> +.B ENXIO
> +.I option
> +is PR_MPX_DISABLE_MANAGEMENT and the kernel or CPU does not support MPX.
>  .SH VERSIONS
>  The
>  .BR prctl ()
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
