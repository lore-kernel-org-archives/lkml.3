Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaICGGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:06:55 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:42825 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaICGGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:06:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140902192941.GB3001@console-pimps.org>
References: <5405E186.2080406@canonical.com>
	<20140902192941.GB3001@console-pimps.org>
Date: Wed, 3 Sep 2014 08:06:53 +0200
Message-ID: <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 September 2014 21:29, Matt Fleming <matt@console-pimps.org> wrote:
> On Tue, 02 Sep, at 05:25:58PM, Maarten Lankhorst wrote:
>> Hey,
>>
>> My macbook pro 8.2 fails to do a efi stub boot with these patches.
>>
>> Commit f23cf8bd5c1f49 "efi/x86: efistub: Move shared dependencies to <asm/efi.h>"
>> causes the first break, but this can be averted by changing
>>
>> struct efi_config *efi_early;
>>
>> to
>>
>> struct efi_config *efi_early __attribute__((visibility("hidden")));
>
> Weird. That sounds like a bug in the Apple EFI PE loader. Does any other
> visibility result in a working kernel?
>
>> I also need to revert commit f4f75ad5741fe "efi: efistub: Convert into static library"
>> to get boot working.
>
> I'll take a look at the symbol changes between these commits and try and
> guess what's going on.
>
>> I'm not an early boot expert, so I have no idea what's going on here.
>> Only console output I see when the boot fails is "setup_efi_pci() failed!" after
>> the commit that adds this message.
>
> Yeah, that should be unrelated.
>
> Thanks for the report.
>

If x86 is anything like ARM in this respect, this is likely caused by
the way PIC references to globals are emitted.
When using default visibility, a reference to a global is emitted by a
reference to the GOT, and an offset into the GOT, and the two are
added and dereferenced at runtime. For this to work, the GOT needs to
contain the correct absolute address for the global in question. This,
in turn, relies on absolute relocations to be resolved at load time,
which we don't do with the EFI stub. Could it be that the link address
and load address are usually the same on x86 EFI but not on the Mac?

With hidden visibility, the PIC reference is emitted using a relative
relocation, to which the value of the program counter is added at
runtime, and no GOT is involved, and all relocations can be resolved
at build time.

I think it makes sense to add a #pragma GCC visibility push(hidden) to
efistub.h (if pragmas are in fashion these days), making sure that no
global references (not even externs) will generate GOT entries.

-- 
Ard.
