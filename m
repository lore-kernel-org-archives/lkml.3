Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaEAUUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:20:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:43484 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaEAUUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:20:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,966,1389772800"; 
   d="scan'208";a="532151419"
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 03/16] kgr: initial code
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
	<1398868249-26169-4-git-send-email-jslaby@suse.cz>
Date: Thu, 01 May 2014 13:20:06 -0700
In-Reply-To: <1398868249-26169-4-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Wed, 30 Apr 2014 16:30:36 +0200")
Message-ID: <87tx99ckuh.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:
>  	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 1e96c3628bf2..a03b1e9d2de3 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -615,6 +615,7 @@ GLOBAL(system_call_after_swapgs)
>  	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
>  	movq  %rcx,RIP-ARGOFFSET(%rsp)
>  	CFI_REL_OFFSET rip,RIP-ARGOFFSET
> +	movw $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)

Better use 4 bytes. This has the potential to cause an expensive
Length Changing Prefixes Stall on Intel CPUs.
> +
> +static int kgr_init_ftrace_ops(const struct kgr_patch_fun *patch_fun)
> +{
> +	struct kgr_loc_caches *caches;
> +	unsigned long fentry_loc;
> +
> +	/*
> +	 * Initialize the ftrace_ops->private with pointers to the fentry
> +	 * sites of both old and new functions. This is used as a
> +	 * redirection target in the per-arch stubs.
> +	 *
> +	 * Beware! -- freeing (once unloading will be implemented)
> +	 * will require synchronize_sched() etc.
> +	 */
> +
> +	caches = kmalloc(sizeof(*caches), GFP_KERNEL);
> +	if (!caches) {
> +		kgr_debug("kgr: unable to allocate fentry caches\n");
> +		return -ENOMEM;
> +	}

All the error paths in this function leak memory.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
