Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab3APE4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 23:56:07 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45991 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab3APE4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 23:56:04 -0500
Message-ID: <1358312159.4593.37.camel@falcor1>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com
Date: Tue, 15 Jan 2013 23:55:59 -0500
In-Reply-To: <871udloiku.fsf@xmission.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <871udloiku.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011604-5406-0000-0000-000004406181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 20:30 -0800, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > If a binary is signed, verify its signature. If signature is not valid, do
> > not allow execution. If binary is not signed, execution is allowed
> > unconditionally.
> >
> > CONFIG_BINFMT_ELF_SIGNATURE controls whether elf binary signature support
> > is compiled in or not.
> >
> > Signature are expected to be present in elf section ".section". This code
> > is written along the lines of module signature verification code. Just
> > that I have removed the magic string. It is not needed as signature is
> > expected to be present in a specific section.
> >
> > I put the signature into a section, instead of appending it so that
> > strip operation works fine.
> >
> > One signs and verifies  all the areas mapped by PT_LOAD segments of elf
> > binary. Typically Elf header is mapped in first PT_LOAD segment. As adding
> > .signature section can change three elf header fields (e_shoff, e_shnum
> > and e_shstrndx), these fields are excluded from digest calculation
> 
> My gut feel says that a signature that we verify should reside in an ELF
> segment.  Sections are for the linker not the kernel.
> 
> I don't totally know what the signature should cover but my gut feels
> says the signature should come after ever non-signature segment and
> cover all of the prior segments (PT_LOAD or not).  Because presumably
> the loader needs to look at everything in a segment.  We can
> restrict ourselves to only processing signed binaries on executables
> with only PT_LOAD segments and signatures for now.

Please remind me why you can't use IMA-appraisal, which was upstreamed
in Linux 3.7?  Why another method is needed?

With IMA-appraisal, there are a couple of issues that would still need
to be addressed:
- missing the ability to specify the validation method required.
- modify the ima_appraise_tcb policy policy to require elf executables
to be digitally signed.
- security_bprm_check() is called before the binary handler is known.

The first issue is addressed by a set of patches queued to be upstreamed
in linux-integrity/next-ima-appraise-status.

To address the last issue would either require moving the existing
bprm_check or defining a new hook after the binary handler is known.

thanks,

Mimi

