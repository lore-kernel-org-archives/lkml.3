Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaHRRQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaHRRQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:16:18 -0400
Date: Mon, 18 Aug 2014 13:15:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH 2/2] asm-generic: add memfd_create system call to unistd.h
Message-ID: <20140818171540.GE4745@redhat.com>
References: <1407764228-7904-1-git-send-email-will.deacon@arm.com>
 <CANq1E4Q0gDaJ5XGnkoCQsG8xLh1Q-EBErtEVPpeeZgGj+Nr8dQ@mail.gmail.com>
 <20140811171511.GF8828@arm.com>
 <201408112057.01177.arnd@arndb.de>
 <CAMuHMdWZ30ZKO2ddh8whmw5ThrKZC0wsU+rhgoc8fRZni0Zduw@mail.gmail.com>
 <20140812102734.GG29013@arm.com>
 <20140812111030.GK29013@arm.com>
 <20140812123736.GA16961@redhat.com>
 <20140815135520.GT27466@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815135520.GT27466@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 02:55:20PM +0100, Will Deacon wrote:
> On Tue, Aug 12, 2014 at 01:37:36PM +0100, Vivek Goyal wrote:
> > On Tue, Aug 12, 2014 at 12:10:30PM +0100, Will Deacon wrote:
> > > Hmm, so whilst I can easily wire-up the new syscall, it's pretty useless for
> > > anybody other than x86 at the moment. There are a bunch of arch helpers:
> > > 
> > >  arch_kexec_kernel_image_probe
> > >  arch_kexec_kernel_verify_sig
> > >  arch_kexec_kernel_image_load
> > >  arch_kimage_file_post_load_cleanup
> > > 
> > > which are only implemented for x86 (arch/x86/kernel/machine_kexec_64.c),
> > > even though I don't really see what makes them arch-specific as opposed to
> > > file format specific.
> > 
> > Yes, at this point of time, this system call will work only on x86. Agreed
> > that primarily it is file format details which are primarily in arch
> > specific section.
> > 
> > I think that some of the code will become arch independent as other
> > arches start implementing this syscall. 
> > 
> > > 
> > > So this syscall will always fail with -ENOEXEC at the moment. Is it still
> > > worth wiring it up?
> > 
> > I thought that for other arches I have not even defined the syscall. So
> > it probably will fail with -ENOSYS.
> 
> What I meant was, if I wire it into asm-generic/unistd.h then it will return
> -ENOEXEC for architectures using that file (e.g. arm64).
> 
> Patch below, but I don't think it's very useful.
> 

Hi Will,

I have not even defined a syscall number for other arches. IIUC, this
patch will forcibly introduce a syscall number for the new syscall for
arches which use asm-generic/unistd.h.

So question I have is that why should we do it now. One can do it once
somebody enables kexec_file_load() on arm64.

Right now I see that kexec_file_load() gets compiled if CONFIG_KEXEC=y. So
even on arm64 it must be getting compiled in. But it is not being hooked
up using system call table. So there should not be any way to invoke
syscalll definition. So my understand is that in current form, one can
not invoke kexec_file_load() on arm64. Is that right.

Now I have put one more patch to make compilation of kexec_file_load()
conditional on config option CONFIG_KEXEC_FILE. And this option can
be enabled only on x86_64. That means kexec_file_load() will not even
be compiled in on arm64 (once the patch gets merged). Right now patch
is sitting in andrew's tree.

http://ozlabs.org/~akpm/mmotm/broken-out/kexec-create-a-new-config-option-config_kexec_file-for-new-syscall.patch

Can you please help me understand that why do we need this patch if at
this point of time we are not even fixing a system call number for
kexec_file_load() for arches except x86_64.

Thanks
Vivek
