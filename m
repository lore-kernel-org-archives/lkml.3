Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaIXTjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:39:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:57652 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIXTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:39:46 -0400
Date: Wed, 24 Sep 2014 21:39:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paolo Bonzini <pbonzini@redhat.com>
cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chris@arachsys.com,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86: kvm: use alternatives for VMCALL vs. VMMCALL if
 kernel text is read-only
In-Reply-To: <1411384668-11135-1-git-send-email-pbonzini@redhat.com>
Message-ID: <alpine.DEB.2.10.1409242136170.4604@nanos>
References: <1411384668-11135-1-git-send-email-pbonzini@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Paolo Bonzini wrote:

> On x86_64, kernel text mappings are mapped read-only with CONFIG_DEBUG_RODATA.
> In that case, KVM will fail to patch VMCALL instructions to VMMCALL
> as required on AMD processors.
>
> The failure mode is currently a divide-by-zero exception, which obviously
> is a KVM bug that has to be fixed.  However, picking the right instruction
> between VMCALL and VMMCALL will be faster and will help if you cannot upgrade
> the hypervisor.
>
> -/* This instruction is vmcall.  On non-VT architectures, it will generate a
> - * trap that we will then rewrite to the appropriate instruction.
> +#ifdef CONFIG_DEBUG_RODATA
> +#define KVM_HYPERCALL \
> +        ALTERNATIVE(".byte 0x0f,0x01,0xc1", ".byte 0x0f,0x01,0xd9", X86_FEATURE_VMMCALL)

If we can do it via a feature bit and alternatives, then why do you
want to patch it manually if CONFIG_DEBUG_RODATA=n?

Just because more #ifdeffery makes the code more readable?

Thanks,

	tglx
