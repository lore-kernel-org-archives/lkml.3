Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab3HGRro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab3HGRrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:47:42 -0400
Message-ID: <5202889C.2080608@redhat.com>
Date: Wed, 07 Aug 2013 19:49:16 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>,
        "Jordan Justen (Intel address)" <jordan.l.justen@intel.com>
Subject: Re: [edk2] Corrupted EFI region
References: <51FFB660.4060400@redhat.com> <20130805144010.GE31845@pd.tnic> <51FFC19A.1020204@redhat.com> <20130805161247.GF31845@pd.tnic> <51FFD5B0.9080000@redhat.com> <20130805164731.GG31845@pd.tnic> <52001896.1030509@redhat.com> <20130805220808.GC14067@pd.tnic> <20130806141036.GD14891@pd.tnic> <520116D1.2010000@redhat.com> <20130807151935.GJ17920@pd.tnic>
In-Reply-To: <20130807151935.GJ17920@pd.tnic>
Content-Type: multipart/mixed;
 boundary="------------070205040006040609090302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070205040006040609090302
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/07/13 17:19, Borislav Petkov wrote:
> On Tue, Aug 06, 2013 at 05:31:29PM +0200, Laszlo Ersek wrote:
>> Can you capture the OVMF debug output? Do you see
>>
>>   ConvertPages: Incompatible memory types
>>
>> there?
>>
>> Can you set the following bits too in the debug mask?
>>
>> #define DEBUG_POOL      0x00000010  // Alloc & Free's
>> #define DEBUG_PAGE      0x00000020  // Alloc & Free's
> 
> Ok, I got debug output; I have to be careful now of not missing
> anything. Ok, so here we go:
> 
> First of all, I changed debugging mask to:
> 
>   gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x8010007F
> 
> (I just set all three bits you requested).
> 
> Using the new OVMF.id changed the addresses, of course, so we're looking
> at 0x7dc59XXX ones now.
> 
> [    0.000000] memblock_reserve: [0x0000007dc59018-0x0000007dc59618] efi_memblock_x86_reserve_range+0x70/0x75
> 
> So, I've attached an archive of the debug logs. The initial observations
> I could do is that the region still gets "squashed" to:
> 
> [    0.014041] efi: mem11: type=4, attr=0xf, range=[0x000000007dc59000-0x000000007dc59000) (0MB)
> 
> from
> 
> [    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007dc59000-0x000000007e146000) (4MB)
> 
> And the interesting stuff in the OVMF output is right at the end:
> 
> ConvertRange: 7DC59000-7DC5AFFF to 4
> AddRange: 7DC59000-7DC5AFFF to 4
> AllocatePoolI: Type 4, Addr 7DC59018 (len 16F0) 26,735,072
> Jumping to kernel
> 
> We get that same output no matter if I boot it with "-enable-kvm" or
> not.
> 
> If the order of the debug messages is the same as the calls actually
> happen, we AllocatePoolI to address 7DC59018 which we already have added
> as a range. But I'm not going to pretend I even know the code so I'll
> let you comment instead :).

I think this allows us to solve the bug :)

First, forget everything I said :) I was completely lost.

Remember this?

01 efi_main()
02  exit_boot()
03    low_alloc()
04    GetMemoryMap()
05    ExitBootServices()
06
07 start_kernel()
08   setup_arch()
09    efi_memblock_x86_reserve_range()
10    efi_reserve_boot_services()
11  efi_enter_virtual_mode()
12    SetVirtualAddressMap()

Now, lines 01 to 05 *do not happen*.

More precisely, they don't happen in the kernel. They happen in the firmware. Specifically, "OvmfPkg/Library/LoadLinuxLib/Linux.c".

You're booting the kernel from the qemu command line. The kernel you run is also an "[o]ld kernel[] without EFI handover protocol". So what happens is, OVMF downloads the kernel image from qemu over fw_cfg, figures it's an old kernel...

PlatformBdsPolicyBehavior() [OvmfPkg/Library/PlatformBdsLib/BdsPlatform.c]
  // Process QEMU's -kernel command line option:
  TryRunningQemuKernel()    [OvmfPkg/Library/PlatformBdsLib/QemuKernel.c]
    LoadLinux()             [OvmfPkg/Library/LoadLinuxLib/Linux.c]
      // Old kernels without EFI handover protocol
      SetupLinuxBootParams()
        SetupLinuxMemmap()
          AllocatePool() <-------------- !!!
          gBS->GetMemoryMap()
          gBS->ExitBootServices()
      prints "Jumping to kernel"
      JumpToKernel()

Now pull up efi_memblock_x86_reserve_range(). It reserves "boot_params.efi_info->efi_memmap".

I assumed this field would come from the exit_boot() kernel function. It doesn't. It comes from SetupLinuxMemmap(). The former allocates the backing store as EFI_LOADER_DATA. The latter, alas, marked with !!! above, as boot services data. :)

So, what you're seeing in the OVMF debug log:

> ConvertRange: 7DC59000-7DC5AFFF to 4
> AddRange: 7DC59000-7DC5AFFF to 4
> AllocatePoolI: Type 4, Addr 7DC59018 (len 16F0) 26,735,072

This is self-consistent. It just documents that the AllocatePool() call marked with !!! needs to grab two full pages first (two first lines), carve them up into pool chunks, and then serve the request from them (third line).

The address displayed here shows up in the linux dmesg later on because the storage for the memory map itself is allocated, and populated, by OVMF, not the EFI stub in the kernel.

In one sentence, efi_memblock_x86_reserve_range() expects that "boot_params.efi_info->efi_memmap" has been allocated as "loader data" (by whomever), but SetupLinuxMemmap() violates this by allocating the storage as "boot services data".

This leads to double reservation attempts between efi_memblock_x86_reserve_range(), and efi_reserve_boot_services().

The attached edk2 patch should fix it. Please confirm.

Thanks,
Laszlo


--------------070205040006040609090302
Content-Type: text/plain; charset=ISO-8859-2;
 name="0001-OvmfPkg-allocate-the-EFI-memory-map-for-Linux-as-Loa.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-OvmfPkg-allocate-the-EFI-memory-map-for-Linux-as-Loa.pa";
 filename*1="tch"

RnJvbSA0YTllMWYxMGZhMmQwNjQ5NmYxOTgzYzI1YzQ3YzZhMTM3M2QyZjQyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBMYXN6bG8gRXJzZWsgPGxlcnNla0ByZWRoYXQuY29t
PgpEYXRlOiBXZWQsIDcgQXVnIDIwMTMgMTk6Mzk6MzAgKzAyMDAKU3ViamVjdDogW1BBVENI
XSBPdm1mUGtnOiBhbGxvY2F0ZSB0aGUgRUZJIG1lbW9yeSBtYXAgZm9yIExpbnV4IGFzIExv
YWRlciBEYXRhCgpJbiBMaW51eCwgZWZpX21lbWJsb2NrX3g4Nl9yZXNlcnZlX3JhbmdlKCkg
YW5kIGVmaV9yZXNlcnZlX2Jvb3Rfc2VydmljZXMoKQpleHBlY3QgdGhhdCB3aG9ldmVyIGFs
bG9jYXRlcyB0aGUgRUZJIG1lbW1hcCBhbGxvY2F0ZXMgaXQgaW4gTG9hZGVyIERhdGEKdHlw
ZSBtZW1vcnkuIExpbnV4J3Mgb3duIGV4aXRfYm9vdCgpLS0+bG93X2FsbG9jKCkgY29tcGxp
ZXMsIGJ1dApTZXR1cExpbnV4TWVtbWFwKCkgaW4gTG9hZExpbnV4TGliIGRvZXNuJ3QuCgpU
aGUgbWVtb3J5IHR5cGUgZGlzY3JlcGFuY3kgbGVhZHMgdG8gZWZpX21lbWJsb2NrX3g4Nl9y
ZXNlcnZlX3JhbmdlKCkgYW5kCmVmaV9yZXNlcnZlX2Jvb3Rfc2VydmljZXMoKSBib3RoIHRy
eWluZyB0byByZXNlcnZlIHRoZSByYW5nZSBiYWNraW5nIHRoZQptZW1tYXAsIHJlc3VsdGlu
ZyBpbiBtZW1tYXAgZW50cnkgdHJ1bmNhdGlvbiBpbgplZmlfcmVzZXJ2ZV9ib290X3NlcnZp
Y2VzKCkuCgpUaGlzIGZpeCBhbHNvIG1ha2VzIHRoaXMgYWxsb2NhdGlvbiBjb25zaXN0ZW50
IHdpdGggYWxsIG90aGVyIHBlcnNpc3RlbnQKYWxsb2NhdGlvbnMgaW4gICJPdm1mUGtnL0xp
YnJhcnkvTG9hZExpbnV4TGliL0xpbnV4LmMiLgoKQ29udHJpYnV0ZWQtdW5kZXI6IFRpYW5v
Q29yZSBDb250cmlidXRpb24gQWdyZWVtZW50IDEuMAoKU2lnbmVkLW9mZi1ieTogTGFzemxv
IEVyc2VrIDxsZXJzZWtAcmVkaGF0LmNvbT4KLS0tCiBPdm1mUGtnL0xpYnJhcnkvTG9hZExp
bnV4TGliL0xpbnV4LmMgfCAgICA4ICsrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9Pdm1mUGtnL0xpYnJh
cnkvTG9hZExpbnV4TGliL0xpbnV4LmMgYi9Pdm1mUGtnL0xpYnJhcnkvTG9hZExpbnV4TGli
L0xpbnV4LmMKaW5kZXggY2Q2NzNhYS4uNGEzZTJjMSAxMDA2NDQKLS0tIGEvT3ZtZlBrZy9M
aWJyYXJ5L0xvYWRMaW51eExpYi9MaW51eC5jCisrKyBiL092bWZQa2cvTGlicmFyeS9Mb2Fk
TGludXhMaWIvTGludXguYwpAQCAtMjgwLDggKzI4MCwxMiBAQCBTZXR1cExpbnV4TWVtbWFw
ICgKICAgLy8gRW5sYXJnZSBzcGFjZSBoZXJlLCBiZWNhdXNlIHdlIHdpbGwgYWxsb2NhdGUg
cG9vbCBub3cuDQogICAvLw0KICAgTWVtb3J5TWFwU2l6ZSArPSBFRklfUEFHRV9TSVpFOw0K
LSAgTWVtb3J5TWFwID0gQWxsb2NhdGVQb29sIChNZW1vcnlNYXBTaXplKTsNCi0gIEFTU0VS
VCAoTWVtb3J5TWFwICE9IE5VTEwpOw0KKyAgU3RhdHVzID0gZ0JTLT5BbGxvY2F0ZVBvb2wg
KA0KKyAgICAgICAgICAgICAgICAgIEVmaUxvYWRlckRhdGEsDQorICAgICAgICAgICAgICAg
ICAgTWVtb3J5TWFwU2l6ZSwNCisgICAgICAgICAgICAgICAgICAoVk9JRCAqKikgJk1lbW9y
eU1hcA0KKyAgICAgICAgICAgICAgICAgICk7DQorICBBU1NFUlRfRUZJX0VSUk9SIChTdGF0
dXMpOw0KIA0KICAgLy8NCiAgIC8vIEdldCBTeXN0ZW0gTWVtb3J5TWFwDQotLSAKMS43LjEK
Cg==
--------------070205040006040609090302--
