Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3JVOnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:43:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44027 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3JVOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:43:31 -0400
Date: Tue, 22 Oct 2013 10:43:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ian Campbell <ian.campbell@citrix.com>, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, grub-devel@gnu.org,
        david.woodhouse@intel.com, richard.l.maliszewski@intel.com,
        xen-devel@lists.xen.org, boris.ostrovsky@oracle.com,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Peter Jones <pjones@redhat.com>, linux-kernel@vger.kernel.org,
        keir@xen.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022144309.GA18547@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022134252.GA27302@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 09:42:52AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Oct 22, 2013 at 10:59:33AM +0100, Jan Beulich wrote:
> > >>> On 22.10.13 at 11:45, Ian Campbell <ian.campbell@citrix.com> wrote:
> > > On Tue, 2013-10-22 at 10:31 +0100, Jan Beulich wrote:
> > >> >>> On 22.10.13 at 11:26, Ian Campbell <ian.campbell@citrix.com> wrote:
> > >> > AIUI "efilinux" is somewhat badly named and does not use the Linux Boot
> > >> > Protocol (i.e. the (b)zImage stuff with real mode entry point) either.
> > >> > It actually loads and executes the kernel binary as a PE/COFF executable
> > >> > (the native UEFI binary executable format). xen.efi is a PE/COFF binary
> > >> > too and could equally well be launched by linuxefi in this way.
> > >> 
> > >> Except that unless I'm mistaken "linuxefi" still expects to find certain
> > >> Linux-specific internal data structures inside the PE image, which I
> > >> don't see us wanting to be emulating. That's the main difference to
> > >> "chainloader" afaict.
> > > 
> > > Ah, I'd been led to believe it was just the lack of a call to
> > > ExitBootServices, but I didn't check. What you say sounds completely
> > > plausible.
> > > 
> > > Do you know what sort of Linux specific data structures are we talking
> > > about?
> > 
> > The setup header I would assume (i.e. the bits surrounding the
> > "HdrS" signature). But I'm only guessing anyway.
> 
> This is a bit lengthy email, so please get your coffee/tea ready.
> 
> Peter Jones was kind enough to educate me on IRC what it does. The
> GRUB2 module calls the PE/COFF executable (so using the Microsoft ABI
> for passing parameters) using this typedef:
> 
> typedef void(*handover_func)(void *, grub_efi_system_table_t *, struct linux_kernel_params *);
> 
> " and grub_cmd_linux (i.e. "linuxefi") does:
> 
>    if (!lh.handover_offset) { blah } ... handover_offset = lh.handover_offset
> 
>  and then allocates the linux_kernel_params using EFI's AllocatePool() as EFI_LOADER_DATA, and then just:
> 
>    hf = (handover_func)((char *)kernel_mem + handover_offset + offset);
>    asm volatile ("cli");
>    hf (grub_efi_image_handle, grub_efi_system_table, params);
> " (from conversation with Peter Jones).
> 
> Looking at the Fedora GRUB2 source, the 'struct linux_kernel_header' is defined
> in the linux/Documentation/x86/boot.txt and hpa is pretty strict
> about making it backwards compatible. It also seems to support Xen!
> 
> (Interestingly enough we do have this structure in the code: see
> setup_header in arch/x86/bzimage.c)
> 
> GRUB expects the image to have the 0xAA55 at a specific offset (0x01FE)
> otherwise it will stop the load.
> 
> Then there is also the need to have at 0x202 the 'HdrS' string and
> and version id at (0x206). There is also at offset 0x264 the handover_offset
> which is what gets called (this I presume is the same as with PE/COFF
> images and it is expected that a native PE/COFF image would have the
> same location). Interestingly enough the Linux payload has both headers
> built-in - this boot one and also the Microsoft PE/COFF header. Meaning
> it can be launched as a normal PE/COFF binary or a boot loader can
> parse it and find the Linux x86 boot protocol. Pretty nifty.
> 
> Anyhow, the handover function is called with three parameters. The
> third one is the extra 'struct linux_kernel_params' :

And looking at bit deeper in the x86/linux boot spec:

**** EFI HANDOVER PROTOCOL                                                      
                                                                                
This protocol allows boot loaders to defer initialisation to the EFI            
boot stub. The boot loader is required to load the kernel/initrd(s)             
from the boot media and jump to the EFI handover protocol entry point           
which is hdr->handover_offset bytes from the beginning of                       
startup_{32,64}.                                                                
                                                                                
The function prototype for the handover entry point looks like this,            
                                                                                
    efi_main(void *handle, efi_system_table_t *table, struct boot_params *bp)   
                                                                                
'handle' is the EFI image handle passed to the boot loader by the EFI           
firmware, 'table' is the EFI system table - these are the first two             
arguments of the "handoff state" as described in section 2.3 of the             
UEFI specification. 'bp' is the boot loader-allocated boot params.              
                                                                                
The boot loader *must* fill out the following fields in bp,                     
                                                                                
    o hdr.code32_start                                                          
    o hdr.cmd_line_ptr                                                          
    o hdr.cmdline_size                                                          
    o hdr.ramdisk_image (if applicable)                                         
    o hdr.ramdisk_size  (if applicable)                                         
                                                                                
All other fields should be zero.                           



So not much in the third parameter.

And digging in the code (arch/x86/boot/compressed/head_64.S)
the handover_offset ends up pointing to efi_stub_entry which
calls this:

struct boot_params *efi_main(void *handle, efi_system_table_t *_table,          
                             struct boot_params *boot_params) 

If it Linux code is called as a normal PE/COFF image, then it ends
up calling efi_pe_entry, which generates a 'boot_params' structure
(see make_boot_params) based on the EFI.

