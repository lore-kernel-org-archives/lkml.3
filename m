Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaHTM46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbaHTM44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:56:56 -0400
Date: Wed, 20 Aug 2014 08:56:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Thomas Glanzmann <thomas@glanzmann.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Baoquan He <bhe@redhat.com>,
        Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Greg Kroah-Hartman <greg@kroah.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        WANG Chao <chaowang@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        ubuntu@iam.tj
Subject: Re: REGRESSION: 8fc5b4d: Unable to compile x86_64 kernel with x86_32
 userland
Message-ID: <20140820125630.GA12786@redhat.com>
References: <20140820060423.GA14660@glanzmann.de>
 <20140820062408.GB14660@glanzmann.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820062408.GB14660@glanzmann.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 08:24:08AM +0200, Thomas Glanzmann wrote:
> Hello Vivek,
> commit 8fc5b4d introduces a regression that no longer allows to compile
> x86_64 kernel under x86_32 userland. TJ on freenode/#kernel did analyze
> it:
> 
> > (mini) [~/work/linux-2.6] make
> > scripts/kconfig/conf --silentoldconfig Kconfig
> >   CHK     include/config/kernel.release
> >   UPD     include/config/kernel.release
> >   CHK     include/generated/uapi/linux/version.h
> >   CHK     include/generated/utsrelease.h
> >   UPD     include/generated/utsrelease.h
> >   CC      arch/x86/purgatory/purgatory.o
> > arch/x86/purgatory/purgatory.c:1:0: error: code model 'large' not supported in the 32 bit mode
> > make[1]: *** [arch/x86/purgatory/purgatory.o] Error 1
> > make: *** [archprepare] Error 2
> 
> 08:10 < TJ-> Glanzmann: The purgatory code from kexec is specifying ".code64"
> 08:11 < TJ-> Glanzmann: so when your local 32-bit linker tries to deal with that ... it errors
> 08:14 < TJ-> Glanzmann: there's only one introducing the purgatory stuff
> 08:14 < TJ-> 8fc5b4d Fri Aug 8 15:57:32 2014 -0700 Vivek Goyal purgatory: core purgatory functionality

Hi Thomas,

Thanks for the report. I think this is also happening because purgatory is
right now being compiled with compiler option -mcmodel=large. There was
another report where older version of gcc did not support -mcmodel=large.

A patch is sitting in akpm's tree. That patch puts the new code under
a new config option CONFIG_KEXEC_FILE. So as long as you don't enable
CONFIG_KEXEC_FILE=y, you should be fine. This should not impact any of
the existing functionality. Just that you will not get the benefit of
new system call.

http://ozlabs.org/~akpm/mmotm/broken-out/kexec-create-a-new-config-option-config_kexec_file-for-new-syscall.patch

I hope this patch gets merged soon.

In the mean time I am trying to figure out how can I move away from
using -mcmodel=large for purgatory.

Thanks
Vivek
