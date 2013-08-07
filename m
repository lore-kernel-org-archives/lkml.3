Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3HGRYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:24:01 -0400
Received: from crispin.apple.com ([17.151.62.50]:59008 "EHLO
	mail-out.apple.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3HGRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:23:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-AuditID: 11807158-b7f326d000001696-85-520282acf2a9
Subject: Re: [edk2] Corrupted EFI region
From: Andrew Fish <afish@apple.com>
In-reply-to: <20130807151935.GJ17920@pd.tnic>
Date: Wed, 07 Aug 2013 10:23:56 -0700
Cc: Laszlo Ersek <lersek@redhat.com>, linux-efi@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Message-id: <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
References: <51FFB660.4060400@redhat.com> <20130805144010.GE31845@pd.tnic>
 <51FFC19A.1020204@redhat.com> <20130805161247.GF31845@pd.tnic>
 <51FFD5B0.9080000@redhat.com> <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com> <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic> <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
To: edk2-devel@lists.sourceforge.net
X-Mailer: Apple Mail (2.1508)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsUieE6oQXdNE1OQwZkV6hYTV05mtvj75z+z
	xaoDHawWy47tYLFoe3iL0eLyrjlsDmwem1doeexe8JnJ4/2+q2wenzfJBbBEcdmkpOZklqUW
	6dslcGW0P/jDUvDIvuLttkaWBsZNJl2MnBwSAiYSC///YIOwxSQu3FsPZHNxCAksYpI42vGU
	ESTBLKAlcePfSyYQm1dAT2LpvzlgcWEBDYlFd74xg9hsAsoSK+Z/YAexOQV0Ja7MnsXaxcjB
	wSKgInG9TwJkJrPAZkaJxoenWSFmakssW/iaGWKmjcTba58ZIRY/Z5LYvHgP2AIRoOY3Rx4z
	gQySEJCV2Pk7aQIj/ywkJ81CctIsJGMXMDKvYhQoSs1JrDTVSywoyEnVS87P3cQICtaGwogd
	jP+XWR1iFOBgVOLhfRDEFCTEmlhWXJl7iFGCg1lJhPdiMVCINyWxsiq1KD++qDQntfgQozQH
	i5I4r1Xo70AhgfTEktTs1NSC1CKYLBMHp1QDo7D3IvllRvdXfzvH67s627drO8fk6MsHnWuv
	uqayMhj25tyoPFzx1qWjS+CbWWY5i5flwSkyV3k4t9pPZNUW3TtRb0qW3MGbKzgZucS/XO62
	6q07fC7+zAXm5Lt73u6oqZ/+qLl73sWvjOFRYe+nhDT2sbJO1r4nWjvz9L+phaVC7JyHemzO
	KLEUZyQaajEXFScCAChVgIFSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2013, at 8:19 AM, Borislav Petkov <bp@alien8.de> wrote:

> On Tue, Aug 06, 2013 at 05:31:29PM +0200, Laszlo Ersek wrote:
>> Can you capture the OVMF debug output? Do you see
>> 
>>  ConvertPages: Incompatible memory types
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
>  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x8010007F
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

OK so I think I need some Cliff Notes here to help me understand what is going on...

type 4 is EfiBootServicesData and attr 0x0f is cache attributes with no request for a runtime mapping. This is not runtime memory so to the OS loader it is just memory EFI has used that will get freed back to the OS after ExitBootServices(), along with EfiBootServicesCode, EfiLoaderCode, and EfiLoaderData. The EfiLoaderCode and EfiLoaderData also get freed back to the OS and they just exist for the convenience of the OS loader. 

So I can't figure out why this maters? Given:

typedef enum {        
        // Boot Services Memory
        EfiLoaderCode = 1,
        EfiLoaderData = 2,
        EfiBootServicesCode = 3,
        EfiBootServicesData = 4,
        EfiConventionalMemory = 7,

	// EFI Runtime Drivers
        EfiRuntimeServicesCode = 5,
        EfiRuntimeServicesData = 6,

	// Stuff that may get mapped into Runtime
        EfiReservedMemoryType = 0,
        EfiACPIReclaimMemory = 9,
        EfiACPIMemoryNVS = 10,
        EfiMemoryMappedIO = 11,
        EfiMemoryMappedIOPortSpace = 12,
        EfiPalCode = 13,
       
        EfiUnusableMemory = 8,
        EfiMaxMemoryType = 14
    } EFI_MEMORY_TYPE;

[    0.005012] efi: efi_enter_virtual_mode
**[    0.006004] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000009f000) (0MB)
*[    0.007004] efi: mem01: type=2, attr=0xf, range=[0x000000000009f000-0x00000000000a0000) (0MB)

**[    0.008004] efi: mem02: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000800000) (7MB)
*[    0.009004] efi: mem03: type=4, attr=0xf, range=[0x0000000000800000-0x0000000001000000) (8MB)
**[    0.010004] efi: mem04: type=7, attr=0xf, range=[0x0000000001000000-0x0000000002000000) (16MB)
*[    0.011004] efi: mem05: type=2, attr=0xf, range=[0x0000000002000000-0x00000000036e5000) (22MB)
**[    0.012004] efi: mem06: type=7, attr=0xf, range=[0x00000000036e5000-0x000000003fffc000) (969MB)
*[    0.013004] efi: mem07: type=2, attr=0xf, range=[0x000000003fffc000-0x0000000040000000) (0MB)
**[    0.014004] efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
*[    0.015004] efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
**[    0.016004] efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007dc59000) (28MB)
*[    0.017004] efi: mem11: type=4, attr=0xf, range=[0x000000007dc59000-0x000000007dc59000) (0MB)
*[    0.018004] efi: mem12: type=3, attr=0xf, range=[0x000000007e146000-0x000000007e1c2000) (0MB)
*[    0.019004] efi: mem13: type=4, attr=0xf, range=[0x000000007e1c2000-0x000000007e1ca000) (0MB)
*[    0.020004] efi: mem14: type=3, attr=0xf, range=[0x000000007e1ca000-0x000000007e1d4000) (0MB)
*[    0.021004] efi: mem15: type=4, attr=0xf, range=[0x000000007e1d4000-0x000000007e1d6000) (0MB)
*[    0.022004] efi: mem16: type=3, attr=0xf, range=[0x000000007e1d6000-0x000000007e368000) (1MB)

[    0.023004] efi: mem17: type=6, attr=0x800000000000000f, range=[0x000000007e368000-0x000000007e37d000) (0MB)

*[    0.024004] efi: mem18: type=4, attr=0xf, range=[0x000000007e37d000-0x000000007e8c8000) (5MB)

[    0.025004] efi: mem19: type=5, attr=0x800000000000000f, range=[0x000000007e8c8000-0x000000007e8cf000) (0MB)

*[    0.026004] efi: mem20: type=4, attr=0xf, range=[0x000000007e8cf000-0x000000007e923000) (0MB)

[    0.028010] efi: mem21: type=6, attr=0x800000000000000f, range=[0x000000007e923000-0x000000007e925000) (0MB)
[    0.029004] efi: mem22: type=5, attr=0x800000000000000f, range=[0x000000007e925000-0x000000007e934000) (0MB)

*[    0.031004] efi: mem23: type=4, attr=0xf, range=[0x000000007e934000-0x000000007f881000) (15MB)
*[    0.032004] efi: mem24: type=3, attr=0xf, range=[0x000000007f881000-0x000000007fa01000) (1MB)

[    0.033004] efi: mem25: type=5, attr=0x800000000000000f, range=[0x000000007fa01000-0x000000007fa31000) (0MB)
[    0.034003] efi: mem26: type=6, attr=0x800000000000000f, range=[0x000000007fa31000-0x000000007fa55000) (0MB)

[    0.035004] efi: mem27: type=0, attr=0xf, range=[0x000000007fa55000-0x000000007fa59000) (0MB)

[    0.036004] efi: mem28: type=9, attr=0xf, range=[0x000000007fa59000-0x000000007fa61000) (0MB)

[    0.038004] efi: mem29: type=10, attr=0xf, range=[0x000000007fa61000-0x000000007fa65000) (0MB)

*[    0.039004] efi: mem30: type=4, attr=0xf, range=[0x000000007fa65000-0x000000007ffe0000) (5MB)

[    0.040004] efi: mem31: type=6, attr=0x800000000000000f, range=[0x000000007ffe0000-0x0000000080000000) (0MB)

If I look at this list I EFI Free memory EfiConventionalMemory being tracked (** in the above printouts) and the various types of boot services memory are being tracked (as *). From an OS point of view this is all just system memory so why not make the map simpler? 


> And the interesting stuff in the OVMF output is right at the end:
> 
> ConvertRange: 7DC59000-7DC5AFFF to 4
> AddRange: 7DC59000-7DC5AFFF to 4
> AllocatePoolI: Type 4, Addr 7DC59018 (len 16F0) 26,735,072

This is the internal DXE Core call. It looks like a boot services memory allocation is being made. The converts usually are converting from free memory, EfiConventionalMemory, to the type requested. 

Thanks,

Andrew Fish

> Jumping to kernel
> 
> We get that same output no matter if I boot it with "-enable-kvm" or
> not.
> 
> If the order of the debug messages is the same as the calls actually
> happen, we AllocatePoolI to address 7DC59018 which we already have added
> as a range. But I'm not going to pretend I even know the code so I'll
> let you comment instead :).
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>    Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> <ovmf-dbg.tar.bz2>------------------------------------------------------------------------------
> Get 100% visibility into Java/.NET code with AppDynamics Lite!
> It's a free troubleshooting tool designed for production.
> Get down to code-level detail for bottlenecks, with <2% overhead. 
> Download for free and get started troubleshooting in minutes. 
> http://pubads.g.doubleclick.net/gampad/clk?id=48897031&iu=/4140/ostg.clktrk_______________________________________________
> edk2-devel mailing list
> edk2-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/edk2-devel

