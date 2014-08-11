Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaHKUYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:24:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaHKUYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:24:22 -0400
Date: Mon, 11 Aug 2014 16:23:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/15] purgatory: Core purgatory functionality
Message-ID: <20140811202335.GA30740@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-12-git-send-email-vgoyal@redhat.com>
 <20140811174017.GD12610@digium.com>
 <53E9028E.2070709@zytor.com>
 <20140811180213.GC1863@redhat.com>
 <53E906B0.5040105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E906B0.5040105@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 11:08:48AM -0700, H. Peter Anvin wrote:
> On 08/11/2014 11:02 AM, Vivek Goyal wrote:
> > 
> > Hi hpa,
> > 
> > I took it because kexec-tools uses it and in one of the committs Eric
> > gave following reasoning.
> > 
> >     On x86_64 use -mcmodel=large so that the code is built without
> >     any 32bit assumptions.  -mcmodel=medium and -mcmodel=small
> >     result int code that has 32bit relocations against variables
> >     that can live anywhere in the address space
> > 
> > We do want to load purgatory anywhere in the address space. 
> > 
> > But if there are other ways to achieve the same thing, I will do that
> > change.
> > 
> > So when you say "small PIC", I need to use -mcmodel=small and -fPIC?
> > 
> 
> Actually -fPIE is probably better than -fPIC.
> 
> -mcmodel=large is incompatible with all other code out there, which
> means that even though it is supposed to work it will be poorly tested
> at best.  So even despite the gcc version issue, using the small PIC
> model would be better.

Hi hpa,

I have not introduced a new config option for new system call. It compiles
under existing config option CONFIG_KEXEC and I think that's the reason
Shaun is running into this issue.

I passed -mcmodel=small and -fPIE for purgaotry build.

KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes
-fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -MD -Os
-mcmodel=small -fPIE

On the surface I see new reclocation types. 

000000000022  003000000004 R_X86_64_PLT32    00000000000000d8 sha256_init - 4
000000000034  003f00000004 R_X86_64_PLT32    000000000000011a sha256_update - 4
000000000049  004100000004 R_X86_64_PLT32    0000000000001d4d sha256_final - 4

Current code does not take care of these. I am hoping these can be
managed.

I also see undefined symbol.

    64: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND _GLOBAL_OFFSET_TABLE_

And current purgatory relocation code does not expect any undefined
symbols and errors out. IIUC, undefined symbols expect to be resolved
externally by linking against somehing else. But in case of purgatory
this is suppoed to be stand alone and does not link against anything
else. So I am not sure how to take care of this.

I doubt that I can get this code working with -fPIE in short
amount of time (Given my lack of knowledge in this area). So while we
continue to explore it, will it make sense that I also work on a patch to
hide all the new functionality behind a new config option
(say CONFIG_KEXEC_FILE). That way existing users will not be impacted and
only users of the new syscall will be expected to have newer gcc with
-mcmodel=large.

And then I can continue to look into how to get rid of -mcmodel=large
requirement.

Thanks
Vivek
