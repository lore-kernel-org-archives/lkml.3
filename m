Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274Ab3LTOTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:19:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197Ab3LTOTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:19:49 -0500
Date: Fri, 20 Dec 2013 09:19:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Torsten Duwe <duwe@lst.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        Peter Jones <pjones@redhat.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131220141917.GB27063@redhat.com>
References: <20131121190350.GC17070@kroah.com>
 <20131121190620.GA25951@srcf.ucam.org>
 <20131121191305.GK16208@redhat.com>
 <20131121191907.GA26366@srcf.ucam.org>
 <20131122185706.GK4046@redhat.com>
 <87vbzju6ql.fsf@xmission.com>
 <20131125163920.GC23094@redhat.com>
 <87fvqj2vxz.fsf@xmission.com>
 <20131126142759.GA5473@redhat.com>
 <20131219125439.GA6379@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219125439.GA6379@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 01:54:39PM +0100, Torsten Duwe wrote:
> On Tue, Nov 26, 2013 at 09:27:59AM -0500, Vivek Goyal wrote:
> > On Tue, Nov 26, 2013 at 04:23:36AM -0800, Eric W. Biederman wrote:
> > > Vivek Goyal <vgoyal@redhat.com> writes:
> > > 
> > > > On Fri, Nov 22, 2013 at 07:39:14PM -0800, Eric W. Biederman wrote:
> > > >
> > > 
> > > The init_size should be reflected in the .bss of the ELF segments.  If
> > > not it is a bug when generating the kernel ELF headers and should be
> > > fixed.
> > > 
> > > For use by kexec I don't see any issues with just signing the embedded
> > > ELF image.
> > 
> > Being able to write kernel to a file and then load it feels little odd to
> > me. Though this should be allowed but this should not be mandatory.
> > 
> > I think if we allow passing detached signature in kexec system call, then
> > it makes it much more flexible. We should be able to do what you are
> > suggesting at the same time it will also keep the possibility open for what
> > chromeOS developers are looking for.
> > 
> Support for detached signatures would be a big plus for kexec_file_load.
> 
> First I thought, some vendors are already shipping signed bzImages, why not
> verify these? But as it turns out, parsing MS-DOS, PE/COFF headers just to
> find the gaps is a lot of bloat for this little functionality. And David Howells
> got flamed quite badly when he suggested to add pkcs#7 to the kernel.

Yep, that's the reason I am not proposing parsing and verifying PE/COFF
signatures.

> IMO it's up to user land to search lists of certificates, and present
> only the final chain of trust to the kernel for checking.
> 
> ELF is the preferred format for most sane OSes and firmware, and a detached
> signature would probably be simplest to check. If we have the choice,
> without restrictions from braindead boot loaders, ELF should be first.
> And if the pesigning isn't usable and another sig is needed anyway,
> why not apply that to vmlinux(.gz) ?

I have yet to look deeper into it that if we can sign elf images and
just use elf loader. And can use space extract the elf image out of 
a bzImage and pass it to kernel.

Even if it is doable, one disadvantage seemed to be that extracted 
elf images will have to be written to a file so thta it's file descriptor
can be passed to kernel. And that assumed writable root and we chrome
folks seems to have setups where root is not writable.

> 
> Another remaining issue is the root of trust. Should the kernel solely depend
> on UeFI to check certificates? I'd rather vote for a compile-time fallback key.

I was thinking of signing kernel along the lines of modules. That is it is
RSA PKCS1 signatures. It does not contain certifiate chain. Signing key
should be in kernel and that key either can come from UEFI db, or user
might have added it in MOK during boot or we can embed one during kernel
build etc. Verification code will not care how did key show up in kernel.
There could be multiple ways.

Thanks
Vivek
