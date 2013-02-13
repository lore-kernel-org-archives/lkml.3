Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab3BMAbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:31:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50659 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759352Ab3BMAbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:31:33 -0500
Date: Wed, 13 Feb 2013 01:31:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, boris.ostrovsky@amd.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, AMD: Enable WC+ memory type on family 10
 processors
Message-ID: <20130213003126.GD15988@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org,
	linux-kernel@vger.kernel.org, boris.ostrovsky@amd.com,
	tglx@linutronix.de, hpa@linux.intel.com,
	linux-tip-commits@vger.kernel.org,
	Pekka Enberg <penberg@kernel.org>, kvm@vger.kernel.org
References: <1359495169-23278-1-git-send-email-ostr@amd64.org>
 <tip-f0322bd341fd63261527bf84afd3272bcc2e8dd3@git.kernel.org>
 <20130213001626.GA30512@pd.tnic>
 <511ADC79.6040007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <511ADC79.6040007@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 04:21:13PM -0800, H. Peter Anvin wrote:
> On 02/12/2013 04:16 PM, Borislav Petkov wrote:
> >
> >This family check is redundant, we're already in a 0x10 if-branch
> >above. Boris had sent a second version which doesn't have that check:
> >http://marc.info/?l=linux-kernel&m=135949774114910 but I don't know how this
> >other version has gotten in.
> >
> >@hpa: maybe replace - patch is still at the top of tip:x86/cpu?
> >
> 
> I'll check with Ingo if that is doable.
> 
> >>+			rdmsrl(MSR_AMD64_BU_CFG2, value);
> >>+			value &= ~(1ULL << 24);
> >>+			wrmsrl(MSR_AMD64_BU_CFG2, value);
> >>+		}
> >>  	}
> >>
> >>  	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
> >
> >However, the more serious issue is that that same kernel #GPs when
> >booted in kvm. It seems it cannot stomach that specific MSR, see the
> >second "<-- trapping instruction" below and that BU_CFG2 MSR landing in
> >%ecx in the line before that.
> >
> >Oh, and this happens only with the kvm executable (/usr/bin/kvm) in
> >debian testing. If I use qemu from git, it passes over init_amd just
> >fine.
> >
> >Hmmm..
> >
> 
> It #GPs on an MSR, which tends to be a bug in the VMM; RDMSR/WRMSR
> generally kick out to the VMM.  There isn't a huge lot of work we
> can do about that...

Yeah, kvm.ko which runs on the host says that it ignores this MSR:

[160716.170333] kvm [29093]: vcpu0 unhandled rdmsr: 0xc001102a

> I think Qemu defaults to ignoring unknown-to-it MSRs whereas maybe
> kvmtool croaks?  Pekka?

Actually that's the qemu kvm thing you get from http://www.linux-kvm.org
not the kvmtool.

Let me add the kvm ML to CC.

Guys, when I start the guest in kvm, it #GPs early when
it tries to RDMSR 0xc001102a. Here's the oops message:
http://marc.info/?l=linux-kernel&m=136071460803452

qemu-kvm is qemu-kvm (1.1.2+dfsg-5) from debian testing. Command line is:

kvm -snapshot -gdb tcp::1234 -cpu phenom -hda /home/boris/kvm/debian/sid-x86_64.img -name "Debian x86_64:1235" -boot menu=off,order=c -m 2048 -localtime -net nic -net user,hostfwd=tcp::1235-:22 -usbdevice tablet -kernel /w/kernel/linux-2.6/arch/x86/boot/bzImage -append "vga=0 root=/dev/sda1 debug ignore_loglevel console=ttyS0,115200 console=tty0" -serial file:/home/boris/kvm/test-x86_64.log

Any ideas?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
