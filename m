Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab3DFKKr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 06:10:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55126 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab3DFKKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 06:10:44 -0400
Date: Sat, 6 Apr 2013 12:10:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kees Cook <keescook@chromium.org>
Cc: Julien Tinnes <jln@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
Message-ID: <20130406101037.GA3612@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@google.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
	Matthew Garrett <mjg@redhat.com>,
	Matt Fleming <matt.fleming@intel.com>,
	Eric Northup <digitaleric@google.com>,
	Dan Rosenberg <drosenberg@vsecurity.com>,
	Will Drewry <wad@chromium.org>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
 <20130405144954.GC29290@pd.tnic>
 <CAKyRK=iEXpq9KnG_VJMYW-tpBxU_2TGaO_hZRkNY=J+7SNoQkA@mail.gmail.com>
 <20130405204306.GA14092@pd.tnic>
 <CAGXu5jJtBgUXwMm6D=JnUvP3kv6YN2MwaF81-2GC-d+pJJFy6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jJtBgUXwMm6D=JnUvP3kv6YN2MwaF81-2GC-d+pJJFy6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 04:18:49PM -0700, Kees Cook wrote:
> There is already a hook in the patch that prints the offset:
> 
> +dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
> +{
> +       pr_emerg("Kernel Offset: 0x%lx\n",
> +                (unsigned long)&_text - __START_KERNEL);
> ...
> +       atomic_notifier_chain_register(&panic_notifier_list,
> +                                       &kernel_offset_notifier);
> 
> But of course, this can get improved.

Yeah, this should probably be added to dump_trace(), i.e. something
which walks stack frames and dumps addresses. Because, in the panic
notifier, you're missing all those WARN* callsites, for example.

Also, I wonder whether it wouldn't be too hard to go even a step further
and compute the original, linker vmlinux addresses from the offsets
and dump a stack trace which looks exactly the same as if KASLR is
off. It'll probably need something to say KASLR was on when the trace
happened, though:

[  790.253365] Call Trace (KASLR):
[  790.254121]  [<ffffffff8110bc90>] ? __smpboot_create_thread+0x180/0x180
[  790.255428]  [<ffffffff810ff1df>] kthread+0xef/0x100
...

so that people who stare at this, know.

Because, in that case, you don't need both the panic notifier or the
userspace script massaging stack trace output anymore.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
