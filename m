Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbbAQU7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 15:59:06 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:47128 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbbAQU7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 15:59:04 -0500
MIME-Version: 1.0
In-Reply-To: <54BAC21D.9040009@redhat.com>
References: <54BAC21D.9040009@redhat.com>
Date: Sat, 17 Jan 2015 20:59:02 +0000
Message-ID: <CAKv+Gu_kZ+b8CBbiWLW3KW5Nw7qewpN7+N6a910dFaiRcs1xKQ@mail.gmail.com>
Subject: Re: SMBIOS/DMI data under CONFIG_STRICT_DEVMEM
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Jon Masters <jcm@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 January 2015 at 20:12, Jon Masters <jcm@redhat.com> wrote:
> Hi Catalin, all,
>
> I would like to ensure that the SMBIOS data provided by firmware is
> always readable from userspace on AArch64, through /dev/mem.
>

This has been on our radar for a while

> When building a kernel with CONFIG_STRICT_DEVMEM, arm64 follows broadly
> x86 with the exception of an assumption surrounding the low range of
> memory (which doesn't apply on AArch64 platforms universally anyway).
> Thus on x86, they can directly read the SMBIOS table from dmidecode when
> it tries to map /dev/mem due to its location. I'm hacking something up
> for the moment, but I would like to solve this.
>

Check out my series here
http://article.gmane.org/gmane.linux.kernel.efi/5133

The general idea is to remove all UEFI runtime regions (including
config tables) from the linear mapping, and allow r/o access via
/dev/mem to such regions, using a mapping type which can support
unaligned access (which is required for SMBIOS). As for the iomem
resources, we need to reserve the regions we know are in use,
regardless of how that affects the existing logic around
devmem_is_allowed (and I am sure we can do better than what
page_is_ram currently does, which is matching the string 'System RAM'
against the iomem resource table)

-- 
Ard.


> Here are two questions:
>
> 1). Would you prefer to add e.g. a devmem_is_firmware_table() function
> that is called by devmem_is_allowed and carves out a couple exceptions
> based upon knowing .e.g dmi_base and other dynamic data during boot?
>
> 2). Would you prefer to reserve the DMI region is an iomem resource?
> That's a hack but it would seem to work since your check should then
> result in the kernel's resource management saying this is not RAM. The
> problem with this option is that you would then only be able to read the
> SMBIOS tables from userspace if the kernel also recognized them (i.e.
> option 1 above just checks the reported range from EFI, but this option
> would rely on the kernel DMI code also validating the tables, so if you
> were debugging or whatever you wouldn't be able to read them without
> building your kernel without CONFIG_STRICT_DEVMEM for e.g.).
>
> I'm also curious whether x86 is interested in changing the way that the
> SMBIOS tables are accounted or if there are other suggestions.
>
> Jon.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
