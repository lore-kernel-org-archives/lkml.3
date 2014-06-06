Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaFFTvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 15:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaFFTvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 15:51:48 -0400
Date: Fri, 6 Jun 2014 15:51:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 09/13] purgatory: Core purgatory functionality
Message-ID: <20140606195104.GM1526@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-10-git-send-email-vgoyal@redhat.com>
 <20140605200523.GB26110@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605200523.GB26110@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 10:05:23PM +0200, Borislav Petkov wrote:

[..]
> > @@ -249,6 +254,7 @@ archclean:
> >  	$(Q)rm -rf $(objtree)/arch/x86_64
> >  	$(Q)$(MAKE) $(clean)=$(boot)
> >  	$(Q)$(MAKE) $(clean)=arch/x86/tools
> 
> ifeq ($(CONFIG_KEXEC),y)
> 	$(Q)$(MAKE) $(clean)=arch/x86/purgatory
> endif

Hmm.., is it strictly required? I am wondering what happens if I build
a kernel with CONFIG_KEXEC=y, then set CONFIG_KEXEC=n and do "make clean".
I think I will still like any files in arch/x86/purgatory to be cleaned
despite the fact that CONFIG_KEXEC=n. Isn't it?

[..]
> > +ifeq ($(CONFIG_X86_64),y)
> > +KBUILD_CFLAGS	:= -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -mcmodel=large -Os -fno-builtin -ffreestanding -c -MD
> > +else
> > +KBUILD_CFLAGS	:= -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -Os -fno-builtin -ffreestanding -c -MD -m32
> > +endif
> 
> Those variable assignments have a lot of duplication, let's simplify
> (diff ontop):

Thanks. This looks cleaner and also highlights the difference between
x86_64 and x86. Will change.

[..]
> > +	.section ".rodata"
> > +	.balign 4
> > +entry64_regs:
> > +rax:	.quad 0x00000000
> 
> Simply 0x0? Or am I missing something?

I think .quad 0x0 should work. Will use it.

[..]
> > +	sha256_final(&sctx, digest);
> > +
> > +	if (memcmp(digest, sha256_digest, sizeof(digest)) != 0)
> 
> 	if (memcmp(...))
> 		return 1;
> 
> should be a bit cleaner.
> 

Ok. Will do.

[..]
> > +void purgatory(void)
> > +{
> > +	int ret;
> > +
> > +	ret = verify_sha256_digest();
> > +	if (ret) {
> > +		/* loop forever */
> > +		for (;;);
> 
> checkpatch bitches about this:
> 
> ERROR: trailing statements should be on next line
> #303: FILE: arch/x86/purgatory/purgatory.c:68:
> +               for (;;);

Ok, will move semicolon to next line.

Thanks
Vivek
