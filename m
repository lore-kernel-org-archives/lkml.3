Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaCGRMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:12:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53706 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaCGRMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:12:43 -0500
Date: Fri, 7 Mar 2014 18:12:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 10/11] kexec: Support for loading ELF x86_64 images
Message-ID: <20140307171233.GD5255@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-11-git-send-email-vgoyal@redhat.com>
 <20140228145832.GF4326@pd.tnic>
 <20140228171142.GI28744@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140228171142.GI28744@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:11:43PM -0500, Vivek Goyal wrote:
> I was rather thinking of arch/x86/kernel/kexec. But that's for some other
> day. Not part of this patchset. This is alredy too big and I don't want
> to make any changes which are nice to have and bloat the patch size.

Ok.

Btw, we were talking about the "kernel" part of the path. And, as Ingo
said, it is all kernel so arch/x86/kexec should be perfectly fine.

...

> > > +	for (i = 0; i < ehdr->e_phnum; i++) {
> > > +		if (phdrs[i].p_type != PT_LOAD)
> > > +			continue;
> > 
> > newline
> 
> What's that?

Ah, that's: "please add an empty line here" for better readability.

> > > +/* Fill in fields which are usually present in bzImage */
> > > +static int init_linux_parameters(struct boot_params *params)
> > > +{
> > > +	/*
> > > +	 * FIXME: It is odd that the information which comes from kernel
> > > +	 * has to be faked by loading kernel. I guess it is limitation of
> > > +	 * ELF format. Right now keeping it same as kexec-tools
> > > +	 * implementation. But this most likely needs fixing.
> > > +	 */
> > > +	memcpy(&params->hdr.header, "HdrS", 4);
> > > +	params->hdr.version = 0x0206;
> > > +	params->hdr.initrd_addr_max = 0x37FFFFFF;
> > > +	params->hdr.cmdline_size = 2048;
> > > +	return 0;
> > > +}
> > 
> > Why a separate function? Its body is small enough to be merged into
> > elf_x86_64_load.
> 
> Actually this logic shows the limitation of ELF format kernel image.
> This information should be exported by the image so that loader can
> do some verifications. But instead loader is hardcoding this info and
> faking things.
> 
> For example, it should be kernel which tells what's the maximum command
> line size it can handle and then loader can return error if user specified
> command line size is greater than what new kernel can handle.
> 
> Similarly, what's the max address initrd can be loaded at.
> 
> Actually I have copied this code from kexec-tools. And I am wondering
> if some of this is 
> 
> I am not sure why we set hdr.version and hdr.header. Are there any
> assumptions in booth path kernel is making. May be some other code
> down the line is parsing it or it is completely redundant. I think
> I will play with removing setting of hdr.version and hdr.header and
> see how does it go.

Well, this is mandated by the boot protocol, no?

"If the "HdrS" (0x53726448) magic number is not found at offset 0x202,
the boot protocol version is "old".  Loading an old kernel, the
following parameters should be assumed:

        Image type = zImage
        initrd not supported
        Real-mode kernel must be located at 0x90000."

About version 0x0206:

Field name:     cmdline_size
Type:           read
Offset/size:    0x238/4
Protocol:       2.06+

  The maximum size of the command line without the terminating
  zero. This means that the command line can contain at most
  cmdline_size characters. With protocol version 2.05 and earlier, the
  maximum size was 255.

So according to the protocol, cmdline_size should be set by
kexec_file_load and not hardcoded to 2K, if we're mandating protocol
version 2.06.

Maybe hpa can comment on all this.

> so I put it in a separate function because user space code had it that
> way. Also because I did not like this part of the code and this looks
> like a limitation of ELF format, I wanted to isolate it in a separate
> function so that it is easy to spot it.

Right.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
