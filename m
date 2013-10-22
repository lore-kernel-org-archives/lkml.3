Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3JVNnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:43:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35610 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3JVNnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:43:14 -0400
Date: Tue, 22 Oct 2013 09:42:52 -0400
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
Message-ID: <20131022134252.GA27302@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526668A502000078000FCA7B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 10:59:33AM +0100, Jan Beulich wrote:
> >>> On 22.10.13 at 11:45, Ian Campbell <ian.campbell@citrix.com> wrote:
> > On Tue, 2013-10-22 at 10:31 +0100, Jan Beulich wrote:
> >> >>> On 22.10.13 at 11:26, Ian Campbell <ian.campbell@citrix.com> wrote:
> >> > AIUI "efilinux" is somewhat badly named and does not use the Linux Boot
> >> > Protocol (i.e. the (b)zImage stuff with real mode entry point) either.
> >> > It actually loads and executes the kernel binary as a PE/COFF executable
> >> > (the native UEFI binary executable format). xen.efi is a PE/COFF binary
> >> > too and could equally well be launched by linuxefi in this way.
> >> 
> >> Except that unless I'm mistaken "linuxefi" still expects to find certain
> >> Linux-specific internal data structures inside the PE image, which I
> >> don't see us wanting to be emulating. That's the main difference to
> >> "chainloader" afaict.
> > 
> > Ah, I'd been led to believe it was just the lack of a call to
> > ExitBootServices, but I didn't check. What you say sounds completely
> > plausible.
> > 
> > Do you know what sort of Linux specific data structures are we talking
> > about?
> 
> The setup header I would assume (i.e. the bits surrounding the
> "HdrS" signature). But I'm only guessing anyway.

This is a bit lengthy email, so please get your coffee/tea ready.

Peter Jones was kind enough to educate me on IRC what it does. The
GRUB2 module calls the PE/COFF executable (so using the Microsoft ABI
for passing parameters) using this typedef:

typedef void(*handover_func)(void *, grub_efi_system_table_t *, struct linux_kernel_params *);

" and grub_cmd_linux (i.e. "linuxefi") does:

   if (!lh.handover_offset) { blah } ... handover_offset = lh.handover_offset

 and then allocates the linux_kernel_params using EFI's AllocatePool() as EFI_LOADER_DATA, and then just:

   hf = (handover_func)((char *)kernel_mem + handover_offset + offset);
   asm volatile ("cli");
   hf (grub_efi_image_handle, grub_efi_system_table, params);
" (from conversation with Peter Jones).

Looking at the Fedora GRUB2 source, the 'struct linux_kernel_header' is defined
in the linux/Documentation/x86/boot.txt and hpa is pretty strict
about making it backwards compatible. It also seems to support Xen!

(Interestingly enough we do have this structure in the code: see
setup_header in arch/x86/bzimage.c)

GRUB expects the image to have the 0xAA55 at a specific offset (0x01FE)
otherwise it will stop the load.

Then there is also the need to have at 0x202 the 'HdrS' string and
and version id at (0x206). There is also at offset 0x264 the handover_offset
which is what gets called (this I presume is the same as with PE/COFF
images and it is expected that a native PE/COFF image would have the
same location). Interestingly enough the Linux payload has both headers
built-in - this boot one and also the Microsoft PE/COFF header. Meaning
it can be launched as a normal PE/COFF binary or a boot loader can
parse it and find the Linux x86 boot protocol. Pretty nifty.

Anyhow, the handover function is called with three parameters. The
third one is the extra 'struct linux_kernel_params' :


/* Boot parameters for Linux based on 2.6.12. This is used by the setup
   sectors of Linux, and must be simulated by GRUB on EFI, because
   the setup sectors depend on BIOS.  */
struct linux_kernel_params
{
  grub_uint8_t video_cursor_x;		/* 0 */
  grub_uint8_t video_cursor_y;

  grub_uint16_t ext_mem;		/* 2 */

  grub_uint16_t video_page;		/* 4 */
  grub_uint8_t video_mode;		/* 6 */
  grub_uint8_t video_width;		/* 7 */

  grub_uint8_t padding1[0xa - 0x8];

  grub_uint16_t video_ega_bx;		/* a */

  grub_uint8_t padding2[0xe - 0xc];

  grub_uint8_t video_height;		/* e */
  grub_uint8_t have_vga;		/* f */
  grub_uint16_t font_size;		/* 10 */

  grub_uint16_t lfb_width;		/* 12 */
  grub_uint16_t lfb_height;		/* 14 */
  grub_uint16_t lfb_depth;		/* 16 */
  grub_uint32_t lfb_base;		/* 18 */
  grub_uint32_t lfb_size;		/* 1c */

  grub_uint16_t cl_magic;		/* 20 */
  grub_uint16_t cl_offset;

  grub_uint16_t lfb_line_len;		/* 24 */
  grub_uint8_t red_mask_size;		/* 26 */
  grub_uint8_t red_field_pos;
  grub_uint8_t green_mask_size;
  grub_uint8_t green_field_pos;
  grub_uint8_t blue_mask_size;
  grub_uint8_t blue_field_pos;
  grub_uint8_t reserved_mask_size;
  grub_uint8_t reserved_field_pos;
  grub_uint16_t vesapm_segment;		/* 2e */
  grub_uint16_t vesapm_offset;		/* 30 */
  grub_uint16_t lfb_pages;		/* 32 */
  grub_uint16_t vesa_attrib;		/* 34 */
  grub_uint32_t capabilities;		/* 36 */

  grub_uint8_t padding3[0x40 - 0x3a];

  grub_uint16_t apm_version;		/* 40 */
  grub_uint16_t apm_code_segment;	/* 42 */
  grub_uint32_t apm_entry;		/* 44 */
  grub_uint16_t apm_16bit_code_segment;	/* 48 */
  grub_uint16_t apm_data_segment;	/* 4a */
  grub_uint16_t apm_flags;		/* 4c */
  grub_uint32_t apm_code_len;		/* 4e */
  grub_uint16_t apm_data_len;		/* 52 */

  grub_uint8_t padding4[0x60 - 0x54];

  grub_uint32_t ist_signature;		/* 60 */
  grub_uint32_t ist_command;		/* 64 */
  grub_uint32_t ist_event;		/* 68 */
  grub_uint32_t ist_perf_level;		/* 6c */

  grub_uint8_t padding5[0x80 - 0x70];

  grub_uint8_t hd0_drive_info[0x10];	/* 80 */
  grub_uint8_t hd1_drive_info[0x10];	/* 90 */
  grub_uint16_t rom_config_len;		/* a0 */

  grub_uint8_t padding6[0xb0 - 0xa2];

  grub_uint32_t ofw_signature;		/* b0 */
  grub_uint32_t ofw_num_items;		/* b4 */
  grub_uint32_t ofw_cif_handler;	/* b8 */
  grub_uint32_t ofw_idt;		/* bc */

  grub_uint8_t padding7[0x1b8 - 0xc0];

  union
    {
      struct
        {
          grub_uint32_t efi_system_table;	/* 1b8 */
          grub_uint32_t padding7_1;		/* 1bc */
          grub_uint32_t efi_signature;		/* 1c0 */
          grub_uint32_t efi_mem_desc_size;	/* 1c4 */
          grub_uint32_t efi_mem_desc_version;	/* 1c8 */
          grub_uint32_t efi_mmap_size;		/* 1cc */
          grub_uint32_t efi_mmap;		/* 1d0 */
        } v0204;
      struct
        {
          grub_uint32_t padding7_1;		/* 1b8 */
          grub_uint32_t padding7_2;		/* 1bc */
          grub_uint32_t efi_signature;		/* 1c0 */
          grub_uint32_t efi_system_table;	/* 1c4 */
          grub_uint32_t efi_mem_desc_size;	/* 1c8 */
          grub_uint32_t efi_mem_desc_version;	/* 1cc */
          grub_uint32_t efi_mmap;		/* 1d0 */
          grub_uint32_t efi_mmap_size;		/* 1d4 */
	} v0206;
      struct
        {
          grub_uint32_t padding7_1;		/* 1b8 */
          grub_uint32_t padding7_2;		/* 1bc */
          grub_uint32_t efi_signature;		/* 1c0 */
          grub_uint32_t efi_system_table;	/* 1c4 */
          grub_uint32_t efi_mem_desc_size;	/* 1c8 */
          grub_uint32_t efi_mem_desc_version;	/* 1cc */
          grub_uint32_t efi_mmap;		/* 1d0 */
          grub_uint32_t efi_mmap_size;		/* 1d4 */
          grub_uint32_t efi_system_table_hi;	/* 1d8 */
          grub_uint32_t efi_mmap_hi;		/* 1dc */
        } v0208;
    };

  grub_uint32_t alt_mem;		/* 1e0 */

  grub_uint8_t padding8[0x1e8 - 0x1e4];

  grub_uint8_t mmap_size;		/* 1e8 */

  grub_uint8_t padding9[0x1f1 - 0x1e9];

  grub_uint8_t setup_sects;		/* The size of the setup in sectors */
  grub_uint16_t root_flags;		/* If the root is mounted readonly */
  grub_uint16_t syssize;		/* obsolete */
  grub_uint16_t swap_dev;		/* obsolete */
  grub_uint16_t ram_size;		/* obsolete */
  grub_uint16_t vid_mode;		/* Video mode control */
  grub_uint16_t root_dev;		/* Default root device number */

  grub_uint8_t padding10;		/* 1fe */
  grub_uint8_t ps_mouse;		/* 1ff */

  grub_uint16_t jump;			/* Jump instruction */
  grub_uint32_t header;			/* Magic signature "HdrS" */
  grub_uint16_t version;		/* Boot protocol version supported */
  grub_uint32_t realmode_swtch;		/* Boot loader hook */
  grub_uint16_t start_sys;		/* The load-low segment (obsolete) */
  grub_uint16_t kernel_version;		/* Points to kernel version string */
  grub_uint8_t type_of_loader;		/* Boot loader identifier */
  grub_uint8_t loadflags;		/* Boot protocol option flags */
  grub_uint16_t setup_move_size;	/* Move to high memory size */
  grub_uint32_t code32_start;		/* Boot loader hook */
  grub_uint32_t ramdisk_image;		/* initrd load address */
  grub_uint32_t ramdisk_size;		/* initrd size */
  grub_uint32_t bootsect_kludge;	/* obsolete */
  grub_uint16_t heap_end_ptr;		/* Free memory after setup end */
  grub_uint8_t ext_loader_ver;		/* Extended loader version */
  grub_uint8_t ext_loader_type;		/* Extended loader type */  
  grub_uint32_t cmd_line_ptr;		/* Points to the kernel command line */
  grub_uint32_t initrd_addr_max;	/* Maximum initrd address */
  grub_uint32_t kernel_alignment;	/* Alignment of the kernel */
  grub_uint8_t relocatable_kernel;	/* Is the kernel relocatable */
  grub_uint8_t pad1[3];
  grub_uint32_t cmdline_size;		/* Size of the kernel command line */
  grub_uint32_t hardware_subarch;
  grub_uint64_t hardware_subarch_data;
  grub_uint32_t payload_offset;
  grub_uint32_t payload_length;
  grub_uint64_t setup_data;
  grub_uint8_t pad2[120];		/* 258 */
  struct grub_e820_mmap e820_map[(0x400 - 0x2d0) / 20];	/* 2d0 */

} __attribute__ ((packed));

Which in the GRUB2 is being constructed by parsing the EFI
data structures. But Linux concentrates on the EFI parts and mostly
ignores the rest. So this is more about passing those EFI values
downstream.

With this (and please correct me), my understanding is that with GRUB2
(Fedora's version) right now (without any patches) we can boot the Xen EFI
image. It will executute it as normal PE/COFF image. I don't know what
GRUB2 stanze arguments need to look like - and we don't support any
parameter parsing (either the Linux x86/boot protocol or the UEFI
standard - if there is any). But I believe GRUB2 still calls
ExitBootServices so not everything is peachy.

If we want to use the linuxefi module and its wealth of options we
would need to build the Xen EFI blob with the linux/x86 boot protocol
embedded in it. It looks like it can co-exist with PE/COFF. We would
have to handle the linux_kernel_parameters structure.

Lastly, we can also support the multiboot2 protocol extension that
Sun folks have come up. This means we don't have to build the binary
as PE/COFF and can get away with making it a gz image. Still need
to support the new format in Xen. There was talk of ARM using mutliboot2
but I don't know if that is still the case.

There is also the backwards compatible way of booting Xen with the
'fakebios' GRUB module. This will construct a fake BIOS payload so
that Xen will use that to get everything it needs. It even looks
to create an ACPI, SMBIOS, etc structures so anything that can't do
pure EFI can still boot.

We can also support all three: PE/COFF by itself launched from GRUB2
(ExitBootServices called, not too good), multiboot2 support, and
linuxefi, I think?

The disadvantage of multiboot2 is that it is not upstream. But the patches
do exist and it looks like they could be put in GRUB2 upstream. The neat
about them is that it also supports Solaris and can support any other
multboot payload type kernels (ie, non-Linux centric).

The advantage of linuxefi is that it is supported by all Linux distros right
now - so we would fit right away. We still have to fiddle with the
linux_kernel_parameters to get everything we want from it - which
is probably just the EFI stuff and we can ditch the rest.

