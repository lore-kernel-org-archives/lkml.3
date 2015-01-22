Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbbAVDIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:08:06 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54428 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbbAVDH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:07:59 -0500
MIME-Version: 1.0
In-Reply-To: <1421893039-426-2-git-send-email-mcgrof@do-not-panic.com>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com> <1421893039-426-2-git-send-email-mcgrof@do-not-panic.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 Jan 2015 19:07:36 -0800
Message-ID: <CALCETrXp7qWLQYEAq7zKTMeMg7mfXo+mL-qPfPN6hfJGQGSoPw@mail.gmail.com>
Subject: Re: [RFC v3 1/2] x86/xen: add xen_is_preemptible_hypercall()
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <JBeulich@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 6:17 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> On kernels with voluntary or no preemption we can run
> into situations where a hypercall issued through userspace
> will linger around as it addresses sub-operatiosn in kernel
> context (multicalls). Such operations can trigger soft lockup
> detection.
>
> We want to address a way to let the kernel voluntarily preempt
> such calls even on non preempt kernels, to address this we first
> need to distinguish which hypercalls fall under this category.
> This implements xen_is_preemptible_hypercall() which lets us do
> just that by adding a secondary hypercall page, calls made via
> the new page may be preempted.
>
> Andrew had originally submitted a version of this work [0].
>
> [0] http://lists.xen.org/archives/html/xen-devel/2014-02/msg01056.html
>
> Based on original work by: Andrew Cooper <andrew.cooper3@citrix.com>
>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Jan Beulich <JBeulich@suse.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  arch/x86/include/asm/xen/hypercall.h | 20 ++++++++++++++++++++
>  arch/x86/xen/enlighten.c             |  7 +++++++
>  arch/x86/xen/xen-head.S              | 18 +++++++++++++++++-
>  3 files changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
> index ca08a27..221008e 100644
> --- a/arch/x86/include/asm/xen/hypercall.h
> +++ b/arch/x86/include/asm/xen/hypercall.h
> @@ -84,6 +84,22 @@
>
>  extern struct { char _entry[32]; } hypercall_page[];
>
> +#ifndef CONFIG_PREEMPT
> +extern struct { char _entry[32]; } preemptible_hypercall_page[];

A comment somewhere explaining why only non-preemptible kernels have
preemptible hypercalls might be friendly to some future reader. :)

> +
> +static inline bool xen_is_preemptible_hypercall(struct pt_regs *regs)
> +{
> +       return !user_mode_vm(regs) &&
> +               regs->ip >= (unsigned long)preemptible_hypercall_page &&
> +               regs->ip < (unsigned long)preemptible_hypercall_page + PAGE_SIZE;
> +}

This makes it seem like the page is indeed one page long, but I don't
see what actually allocates a whole page for it.  What am I missing?

--Andy
