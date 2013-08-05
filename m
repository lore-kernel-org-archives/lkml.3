Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3HELZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 07:25:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab3HELZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:25:50 -0400
Message-ID: <51FF8C14.2070405@redhat.com>
Date: Mon, 05 Aug 2013 13:27:16 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
References: <20130731205431.GG4724@pd.tnic> <1375307727.22084.103.camel@shinybook.infradead.org> <20130801164927.GA7445@pd.tnic>
In-Reply-To: <20130801164927.GA7445@pd.tnic>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/13 18:49, Borislav Petkov wrote:
> On Wed, Jul 31, 2013 at 10:55:27PM +0100, David Woodhouse wrote:
>> On Wed, 2013-07-31 at 22:54 +0200, Borislav Petkov wrote:
>>> so I'm seeing this funny thing where an EFI region changes when we enter
>>> efi_enter_virtual_mode when booting with edk2 on kvm. Here's the diff:
>>
>> Perhaps the edk2-devel@lists.sourceforge.net list should be in Cc?
> 
> Good idea and message repeated below.
> 
> One more thing: I'm using a self-built OVMF with top commit from March:
> 
> ------------------------------------------------------------------------
> r14165 | sfu5 | 2013-03-06 02:42:04 +0100 (Wed, 06 Mar 2013) | 4 lines
> 
> Fix a bug that IsSignatureFoundInDatabase() incorrectly computes CertCount.
> 
> ---
> 
> Hi guys,
> 
> so I'm seeing this funny thing where an EFI region changes when we enter
> efi_enter_virtual_mode when booting with edk2 on kvm. Here's the diff:
> 
> --- before      2013-07-31 22:20:52.316039492 +0200
> +++ after       2013-07-31 22:21:30.960731706 +0200
> @@ -9,7 +9,7 @@ efi: mem07: type=2, attr=0xf, range=[0x0
>  efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
>  efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
>  efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
> -efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
> +efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0ad000) (0MB)

(type 4 is EfiBootServicesData)

>  efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
>  efi: mem13: type=4, attr=0xf, range=[0x000000007e0cd000-0x000000007e55d000) (4MB)
>  efi: mem14: type=3, attr=0xf, range=[0x000000007e55d000-0x000000007e59c000) (0MB)
> 
> That second boundary of region mem11 suddenly changes *before* we merge
> the regions. edk2 bug?

I take it you mean this change (ie. appearance of the zero-sized range)
occurs when you enable KVM acceleration in qemu?

If so, please locate "gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel"
in OvmfPkg/OvmfPkgX64.dsc, and set the following bit in its value:

  # DEBUG_GCD      0x00100000 Global Coherency Database changes

Then please rebuild OVMF, and capture the debug port output of qemu
("-debugcon file:debug.log -global isa-debugcon.iobase=0x402") both with
and without KVM.

DEBUG_GCD should produce messages related to CoreAllocateSpace(), and
might help us find the spot the difference is introduced.

BTW does this have anything to do with the NX bit report of yours, or
have you noticed this independently?

(I'm not subscribed to lkml so apologies if this email doesn't end up in
those archives / doesn't reach everyone.)

Thanks
Laszlo
