Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaKMPsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:48:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:47793 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaKMPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:48:46 -0500
Date: Thu, 13 Nov 2014 16:48:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@suse.de>
cc: B_B_Singh@DELL.com, stuart.w.hayes@gmail.com, hpa@zytor.com,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch
In-Reply-To: <20141113123045.GA14421@pd.tnic>
Message-ID: <alpine.DEB.2.11.1411131557190.3935@nanos>
References: <53B4B627.8060903@gmail.com> <53BC7210.1000305@gmail.com> <53BC72D8.4090705@zytor.com> <53BDE4BD.50605@gmail.com> <20140714172225.GE25120@pd.tnic> <8B2F6FFD0BD1E448853114367400A3730702007068@BLRX7MCDC203.AMER.DELL.COM>
 <20141113123045.GA14421@pd.tnic>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Borislav Petkov wrote:
> Revisit this patch how? I'm not sure I understand...

X86_64 starts with:

pteval_t __supported_pte_mask __read_mostly = ~0;

while i386 starts with:

pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL);

Now if the stupid BIOS disabled NX via setting bit 34 in
IA32_MISC_ENABLE, then X86_FEATURE_NX is off, but at the point where
we call x86_configure_nx() we already used the supported_pte_mask with
the NX bit set in the early remap code and accessed the mappings.

On 32bit we are safe because the early maps exclude NX at startup and
only enable it in x86_configure_nx().

That's one part of the issue. The other is that grub2 does not call in
via the trampoline, so we don't call verify_cpu. verify_cpu clears bit
34 in IA32_MISC_ENABLE depending on the cpu family/model, which is
true for 64bit machines.

So I think moving x86_configure_nx() to a point before we actually
create mappings is a sane thing to do in any case.

But of course we should also clear the stupid disable bit
unconditionally independent of the entry path for all cpus which
support it.

Thanks,

	tglx




