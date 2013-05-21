Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3EUWyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:54:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46500 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3EUWyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:54:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec-list \(kexec\@lists.infradead.org\)" 
	<kexec@lists.infradead.org>,
        "cbouatmailru\@gmail.com" <cbouatmailru@gmail.com>,
        "keescook\@chromium.org" <keescook@chromium.org>,
        "Luck\, Tony \(tony.luck\@intel.com\)" <tony.luck@intel.com>,
        "kay\@vrfy.org" <kay@vrfy.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>,
        "dle-develop\@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFEF289@USINDEM103.corp.hds.com>
	<20130521154137.0db53981578ee206b21850f9@linux-foundation.org>
Date: Tue, 21 May 2013 15:53:53 -0700
In-Reply-To: <20130521154137.0db53981578ee206b21850f9@linux-foundation.org>
	(Andrew Morton's message of "Tue, 21 May 2013 15:41:37 -0700")
Message-ID: <87hahwj666.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX188C5/eeU/Gl4uCFoZjtAWiQq06W5FM/Yg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH]Add kmsg_dump() to kexec path
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> Guys, can we please get some review attention to this?

I think my original reply got lost.

The review was nack.

I don't see anything in this patch that makes this any more palatable
than any other time this idea has come up.

It is perfectly possible in the kexec on panic kernel to write the
information to the kmsg.

So all this appears to do is make us more dependent on a known broken
kernel and make things more fragile and less reliable, for no apparent
gain.  With the kexec on panic code path the focus should be on making
it simpler and more reliable.

Especially when we are going to be calling out to firmware this becomes
a completely impossible to debug code path.

It is simple enough to not load modules in the kexec on panic kernel to
avoid dealing with hardware that is silly and drivers that don't work,
and those problems can be debugged and fixed.

The justification for the patch below starts from an impossible
set of requirements "Always needing to detect the root cause of an OS
panic" and then says but we choose to use weird crazy configurations
that we know are problematic and instead of making those more robust
we choose to use an architecture that is less reliable.

The only problem with kdump here is the implementation in the initial
ram disk.  Fixing the initial ramdisk so it logs to kmsg before it
touches scarier hardware should be the solution.

Eric

> From: Seiji Aguchi <seiji.aguchi@hds.com>
> Subject: Add kmsg_dump() to kexec path
>
> Problem
> =======
>
> From our support service experience, we always need to detect root cause
> of OS panic.  And customers in enterprise area never forgive us if we
> can't detect the root cause of panic due to lack of materials for
> investigation.
>
> Kdump is a powerful troubleshooting feature, but it may accesses to
> multiple hardware, like HBA, FC-cable, to get to dump disk.
>
> This means kdump is not robust against hardware failure.
>
> Solution
> ========
>
> Logging kernel message to persistent device is an effective way to get
> materials for investigation in case of kdump failure.
>
> So this patch adds kmsg_dump() to a kexec path.  Also, it adds
> KMSG_DUMP_KEXEC to pstore_cannot_block_path() so that it can avoid
> deadlocking in kexec path.
>
> Please see the detail of pstore_cannot_block_path(). 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/pstore/platform.c?id=9f244e9cfd70c7c0f82d3c92ce772ab2a92d9f64
>
> Actually, there are some objections about kmsg_dump(KMSG_DUMP_KEXEC) and
> EFI below.  But I still think adding kmsg_dump() to a kexec path is
> useful.
>
> - http://marc.info/?l=linux-kernel&m=130698519720887&w=2
>
> (1) kdump already saves kernel messages inside /proc/vmcore
>
>   - https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/kernel/kexec.c?id=a3dd3323058d281abd584b15ad4c5b65064d7a61
>
>   It is correct, but the content of /proc/vmcore is stored a dump disk
>   as well.  So, if kdump fails due to hardware failures, the kernel
>   messages will be lost.
>
> (2) EFI firmware is buggy
>
>   - http://marc.info/?l=linux-kernel&m=130698519720887&w=2
>
>   I haven't seen actual firmware bugs which may cause kdump failure.  So
>   I don't think we need to care about it too much.  However, just to be
>   safe, I introduced pstore_cannot_block_path() avoid deadlocking to
>   pstore.
>
> Also, this patch doesn't affect almost all users because kmsg_dump() is
> kicked only when specifying both pstore.backend and
> printk.always_kmsg_dump parameters.  Even if a buggy firmware causes a
> kdump failure and someone blames kdump, we can ask them to reproduce the
> kdump failure by removing the parameters.
>
> In addition, I checked current coding of platform drivers.  There is no
> obvious problem as follows.
>
> - mtdoops/ramoops
>   They are designed to be kicked in panic and oops cases only.
>   So, they never run in a kexec path.
>
> - erst/efi/early_printk_mrst/nvram driver for powerpc
>   I don't see any bugs which may causes kdump failure because
>   deadlocking/dynamic memory allocation don't happen in their write callbacks.
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/pstore/platform.c      |    4 ++++
>  include/linux/kmsg_dump.h |    1 +
>  kernel/kexec.c            |    2 ++
>  3 files changed, 7 insertions(+)
>
> diff -puN fs/pstore/platform.c~add-kmsg_dump-to-kexec-path fs/pstore/platform.c
> --- a/fs/pstore/platform.c~add-kmsg_dump-to-kexec-path
> +++ a/fs/pstore/platform.c
> @@ -91,6 +91,8 @@ static const char *get_reason_str(enum k
>  		return "Halt";
>  	case KMSG_DUMP_POWEROFF:
>  		return "Poweroff";
> +	case KMSG_DUMP_KEXEC:
> +		return "Kexec";
>  	default:
>  		return "Unknown";
>  	}
> @@ -110,6 +112,8 @@ bool pstore_cannot_block_path(enum kmsg_
>  	case KMSG_DUMP_PANIC:
>  	/* Emergency restart shouldn't be blocked by spin lock. */
>  	case KMSG_DUMP_EMERG:
> +	/* In kexec path, pstore shouldn't be blocked to avoid kexec failure. */
> +	case KMSG_DUMP_KEXEC:
>  		return true;
>  	default:
>  		return false;
> diff -puN include/linux/kmsg_dump.h~add-kmsg_dump-to-kexec-path include/linux/kmsg_dump.h
> --- a/include/linux/kmsg_dump.h~add-kmsg_dump-to-kexec-path
> +++ a/include/linux/kmsg_dump.h
> @@ -28,6 +28,7 @@ enum kmsg_dump_reason {
>  	KMSG_DUMP_RESTART,
>  	KMSG_DUMP_HALT,
>  	KMSG_DUMP_POWEROFF,
> +	KMSG_DUMP_KEXEC,
>  };
>  
>  /**
> diff -puN kernel/kexec.c~add-kmsg_dump-to-kexec-path kernel/kexec.c
> --- a/kernel/kexec.c~add-kmsg_dump-to-kexec-path
> +++ a/kernel/kexec.c
> @@ -32,6 +32,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/swap.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/kmsg_dump.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> @@ -1089,6 +1090,7 @@ void crash_kexec(struct pt_regs *regs)
>  
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
> +			kmsg_dump(KMSG_DUMP_KEXEC);
>  			machine_crash_shutdown(&fixed_regs);
>  			machine_kexec(kexec_crash_image);
>  		}
> _
