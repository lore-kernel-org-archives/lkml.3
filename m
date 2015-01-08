Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbbAHK1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:27:37 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45519 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbbAHK1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:27:34 -0500
Message-ID: <54AE5B8A.4080607@gmail.com>
Date: Thu, 08 Jan 2015 11:27:22 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>
Subject: Re: [PATCH] prctl.2: Add description of Intel MPX calls
References: <1418683928-28894-1-git-send-email-dave.hansen@intel.com>
In-Reply-To: <1418683928-28894-1-git-send-email-dave.hansen@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC += Qiaowei Ren, in case they might comment]

Hello Dave,

Thanks for the patch. Quite a number of queries below. Could you
address those and resubmit?

On 12/15/2014 11:52 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@intel.com>
> 
> (apologies if this is a duplicate mail, I didn't see my first one
>  hit either of the lists, so I assume Intel's mail relays ate it)

(Actually, both mails did arrive.)

> The 3.19 kernel will have support for Intel MPX, including a pair
> of new prctl() calls for enabling and disabling the kernel's
> management of the "bounds tables".  Add some descriptions of the
> interface.
> 
> The kernel patches were written by myself and another Intel
> developer.

(Thanks -- getting that piece of info is always helpful when
I consider how carefully I need to review a patch.)

> Signed-off-by: Dave Hansen <dave.hansen@intel.com>
> Cc: linux-man@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  man2/prctl.2 | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index 4efabcf..6555d7a 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -47,6 +47,7 @@
>  .\"                             PR_GET_TIMERSLACK
>  .\" 2013-01-10 Kees Cook, document PR_SET_PTRACER
>  .\" 2012-02-04 Michael kerrisk, document PR_{SET,GET}_CHILD_SUBREAPER
> +.\" 2014-11-10 Dave Hansen, Document PR_MPX_{EN,DIS}ABLE_MANAGEMENT
>  .\"
>  .\"
>  .TH PRCTL 2 2014-04-14 "Linux" "Linux Programmer's Manual"
> @@ -737,6 +738,21 @@ value.

It looks like this patch is misplaced in the source. Probably best to
place the new text just above the RETURN VALUE section.

>  The requirements for the address are the same as for the
>  .BR PR_SET_MM_START_BRK
>  option.
> +.TP
> +.BR PR_MPX_ENABLE_MANAGEMENT / PR_MPX_DISABLE_MANAGEMENT

Make this:

.BR PR_MPX_ENABLE_MANAGEMENT / PR_MPX_DISABLE_MANAGEMENT " (since Linux 3.19)"

And then just after please add the following source comments
(for handy reference on future page edits):

.\" commit fe3d197f84319d3bce379a9c0dc17b1f48ad358c
.\" See also http://lwn.net/Articles/582712/
.\" See also https://gcc.gnu.org/wiki/Intel%20MPX%20support%20in%20the%20GCC%20compiler

> +
> +Control the kernel's management of Intel Memory Protection eXtensions

s/Memory Protection eXtensions/Memory Protection eXtensions (MPX)/

> +tables.  When management is enabled, the kernel will take over allocation
> +and freeing of MPX bounds tables.

In between or after the two preceding sentences, I think it would be good 
to some text explaining why MPX is useful. Something along the lines of 
this text from Jon Corbet's article at http://lwn.net/Articles/582712/,
though you may want to cut down, update, or improve the text.

[[
MPX is a hardware-assisted mechanism for performing bounds checking 
on pointer accesses. The hardware, following direction from software, 
maintains a table of pointers in use and the range of accessible 
memory (the "bounds") associated with each. Whenever a pointer is 
dereferenced, special instructions can be used to ensure that the 
program is accessing memory within the range specified for that 
particular pointer.

When a bounds violation is detected, the processor will trap into 
the kernel. The kernel, in turn, will turn the trap into a SIGSEGV 
signal to be delivered to the application, similar to other types 
of memory access errors. Applications that look at the siginfo 
structure passed to the signal handler from the kernel will be able 
to recognize a bounds error by checking the si_code field for the new 
SEGV_BNDERR value. The offending address will be stored in si_addr, 
while the bounds in effect at the time of the trap will be stored 
in si_lower and si_upper.  
]]

> +
> +The application must have allocated virtual space for the bounds
> +directory and placed its location in bndcfgu before enabling management.

s/bndcfgu/the bndcfgu register/

So, let me make sure I understood the previous sentence correctly.
Is this a good formulation:

    Before enabling MPX management using PR_MPX_ENABLE_MANAGEMENT, 
    the application must first have allocated a user-space buffer for
    the bounds directory and placed the location of that directory in
    the bndcfgu register.
?

If so, I think the patch could be reworded closer to that text, since
it makes things a little clearer.

By the way, what size should allocated for the buffer? And what can
wrong if the allocated buffer is too small?

> +Once management is enabled, the bounds directory may not be moved.

A few things are not so clear to me, even after reading Jon's article
and Documentation/x86/intel_mpx.txt. In particular, who has responsibility
for populating the bounds directory, and what is its format? Is this 
all invisible to the application? (Because I'm not quite clear on these
points, I'm not sure if anything should be said in the man page.)

> +
> +These calls will fail if MPX support is not present in the CPU or the

I suggest:
s/if MPX support is not present in the CPU/if the CPU does not support MPX/

> +kernel does not had support for MPX enabled.

s/had/have/

And add the following:

Kernel support for MPX is enabled via the
.BR CONFIG_X86_INTEL_MPX
configuration option.
You can check whether the CPU supports MPX using the following command:

    cat /proc/cpuinfo | grep ' mpx '

> +
> +All threads in a process are affected by these calls.

Please add here:

For further information on Intel MPX, see the kernel source file
.IR Documentation/x86/intel_mpx.txt .

>  .P
>  The following options are available since Linux 3.5.
>  .\" commit fe8c7f5cbf91124987106faa3bdf0c8b955c4cf7

Could you add some text to the patch to explain the ENXIO error?

What are the semantics of the MPX state with respect to the
child of a fork(2)? (Probably, the man page needs to detail this.)

What happens to the MPX state during an execve(2)? (Probably, 
the man page needs to detail this.)

Is there a way to discover the current state (enabled/disabled)
of MPX management? (It appears not, but I would like to confirm.)

I see that the prctl() operations fail to check that unused arguments
are zero. See my patch sent in a separate mail to LKML et al.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
