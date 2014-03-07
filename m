Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaCGSkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:40:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57927 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaCGSkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:40:09 -0500
Date: Fri, 7 Mar 2014 19:39:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 10/11] kexec: Support for loading ELF x86_64 images
Message-ID: <20140307183959.GE5255@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-11-git-send-email-vgoyal@redhat.com>
 <20140228145832.GF4326@pd.tnic>
 <20140228171142.GI28744@redhat.com>
 <20140307171233.GD5255@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140307171233.GD5255@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 06:12:33PM +0100, Borislav Petkov wrote:
> > > > +/* Fill in fields which are usually present in bzImage */
> > > > +static int init_linux_parameters(struct boot_params *params)
> > > > +{
> > > > +	/*
> > > > +	 * FIXME: It is odd that the information which comes from kernel
> > > > +	 * has to be faked by loading kernel. I guess it is limitation of
> > > > +	 * ELF format. Right now keeping it same as kexec-tools
> > > > +	 * implementation. But this most likely needs fixing.
> > > > +	 */
> > > > +	memcpy(&params->hdr.header, "HdrS", 4);
> > > > +	params->hdr.version = 0x0206;
> > > > +	params->hdr.initrd_addr_max = 0x37FFFFFF;
> > > > +	params->hdr.cmdline_size = 2048;
> > > > +	return 0;
> > > > +}

...

> Well, this is mandated by the boot protocol, no?
> 
> "If the "HdrS" (0x53726448) magic number is not found at offset 0x202,
> the boot protocol version is "old".  Loading an old kernel, the
> following parameters should be assumed:
> 
>         Image type = zImage
>         initrd not supported
>         Real-mode kernel must be located at 0x90000."
> 
> About version 0x0206:
> 
> Field name:     cmdline_size
> Type:           read
> Offset/size:    0x238/4
> Protocol:       2.06+
> 
>   The maximum size of the command line without the terminating
>   zero. This means that the command line can contain at most
>   cmdline_size characters. With protocol version 2.05 and earlier, the
>   maximum size was 255.
> 
> So according to the protocol, cmdline_size should be set by
> kexec_file_load and not hardcoded to 2K, if we're mandating protocol
> version 2.06.

Btw, all those fields above are of type "read", which means,

"For each field, some are information from the kernel to the bootloader
("read"),... "

Now, if we assume that the first kernel is the bootloader and it loads
the second kernel, then the first kernel shouldn't be setting all those
fields *at* *all* because it violates the boot protocol. And that's a
no-no.

Generally, how important is that use case for loading ELF images? If no
one is actually using it, why even bother?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
