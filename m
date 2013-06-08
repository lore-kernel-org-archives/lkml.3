Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3FHKmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 06:42:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63529 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3FHKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 06:42:23 -0400
MIME-Version: 1.0
In-Reply-To: <201306072034.58817.arnd@arndb.de>
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6>
	<10307835.fkACLi6FUD@wuerfel>
	<51B130F9.8070408@jp.fujitsu.com>
	<201306072034.58817.arnd@arndb.de>
Date: Sat, 8 Jun 2013 19:42:22 +0900
Message-ID: <CABOkKT1=b26khQue0jPa12km-AVOWhcgAgB8b9gaJ0FAvogjiQ@mail.gmail.com>
Subject: Re: [PATCH v8 9/9] vmcore: support mmap() on /proc/vmcore
From: HATAYAMA Daisuke <d.hatayama@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/8 Arnd Bergmann <arnd@arndb.de>:
> On Friday 07 June 2013, HATAYAMA Daisuke wrote:
>> Thanks for trying the build and your report!
>>
>> OTOH, I don't have no-MMU architectures; x86 box only. I cannot reproduce this build error.
>> Could you give me your build log? I want to use it to detect what part depends on CONFIG_MMU.
>
> What I get is a link-time error:
>
> fs/built-in.o: In function `mmap_vmcore':
> :(.text+0x4bc18): undefined reference to `remap_vmalloc_range_partial'
> fs/built-in.o: In function `merge_note_headers_elf32.constprop.4':
> :(.init.text+0x142c): undefined reference to `find_vm_area'
>
> and I used this patch to temporarily work around the problem, effectively disabling all
> of /proc/vmcore on non-MMU kernels.
>
> diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
> index 37e4f8d..9a078ef 100644
> --- a/include/linux/crash_dump.h
> +++ b/include/linux/crash_dump.h
> @@ -55,7 +55,7 @@ static inline int is_kdump_kernel(void)
>
>  static inline int is_vmcore_usable(void)
>  {
> -       return is_kdump_kernel() && elfcorehdr_addr != ELFCORE_ADDR_ERR ? 1 : 0;
> +       return IS_ENABLED(CONFIG_MMU) && is_kdump_kernel() && elfcorehdr_addr != ELFCORE_ADDR_ERR ? 1 : 0;
>  }
>
>  /* vmcore_unusable() marks the vmcore as unusable,
>
>
> For testing, I used ARM at91x40_defconfig and manually turned on VMCORE support in
> menuconfig, but it happened before using "randconfig". On most distros you can
> these days install an arm cross compiler using yum or apt-get and build
> the kernel yourself with 'make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'
>

Thanks for the detailed explanation. To be honest, I had totally
forgotten existence of cross-compiler and need of build check on
multiple architectures before posting patch set... I tried installing
cross compiler for arm and I've successfully got arm compiler using
yum. I feel it much easier than I tried building them on console some
years.

I successfully reproduce the build error you see and I found I
overlooked no MMU system. This build error is caused by my mmap patch
set I made that maps physically non-contiguous objects into virtually
contiguous user-space as ELF layout. For this, MMU is essential.

I'll post a patch to disable mmap on /proc/vmcore on no MMU system
next week. I cannot use  compony email address now.

Thanks.
HATAYAMA, Daisuke
