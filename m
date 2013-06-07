Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3FGSfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:35:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59858 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3FGSfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:35:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: Re: [PATCH v8 9/9] vmcore: support mmap() on /proc/vmcore
Date: Fri, 7 Jun 2013 20:34:58 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
References: <20130523052421.13864.83978.stgit@localhost6.localdomain6> <10307835.fkACLi6FUD@wuerfel> <51B130F9.8070408@jp.fujitsu.com>
In-Reply-To: <51B130F9.8070408@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306072034.58817.arnd@arndb.de>
X-Provags-ID: V02:K0:t7XQZOlOdxVd3i/OFhdgdgLFbsySqV28jlWVwG4bU17
 I+TA/SrtTmKrJ0/A4Fs0z7cU5rDI3d5rkPOu+pR8DZCKikuON7
 KoH+4qk3af6W48Fj//aWPirtpuIIHIpta5hxXAhp/4MsNgC7Sb
 jq6VeBozWMYVFwgrdUosO9m7Snj0if0gEFUKT4rSV8GNhhx7G7
 sMs/AyyeO/fMAN2oRroA9oy5Th+v4nFMG/FRUiWx9cu8EnAuVt
 oU+k6JqXq9AQoAALr/GWaCSsz5YVqDtXDH0tVZLUUra2DilwZF
 u4LhB44/q8VSVAKiYYgcmpMViyGPn/MRJTq/obqwvE9UPSF0Kz
 8vvLDZPtV9xcNSp9ZjU4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013, HATAYAMA Daisuke wrote:
> Thanks for trying the build and your report!
> 
> OTOH, I don't have no-MMU architectures; x86 box only. I cannot reproduce this build error. 
> Could you give me your build log? I want to use it to detect what part depends on CONFIG_MMU.

What I get is a link-time error:

fs/built-in.o: In function `mmap_vmcore':
:(.text+0x4bc18): undefined reference to `remap_vmalloc_range_partial'
fs/built-in.o: In function `merge_note_headers_elf32.constprop.4':
:(.init.text+0x142c): undefined reference to `find_vm_area'

and I used this patch to temporarily work around the problem, effectively disabling all
of /proc/vmcore on non-MMU kernels.

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 37e4f8d..9a078ef 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -55,7 +55,7 @@ static inline int is_kdump_kernel(void)
 
 static inline int is_vmcore_usable(void)
 {
-	return is_kdump_kernel() && elfcorehdr_addr != ELFCORE_ADDR_ERR ? 1 : 0;
+	return IS_ENABLED(CONFIG_MMU) && is_kdump_kernel() && elfcorehdr_addr != ELFCORE_ADDR_ERR ? 1 : 0;
 }
 
 /* vmcore_unusable() marks the vmcore as unusable,


For testing, I used ARM at91x40_defconfig and manually turned on VMCORE support in
menuconfig, but it happened before using "randconfig". On most distros you can
these days install an arm cross compiler using yum or apt-get and build
the kernel yourself with 'make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-'

	Arnd
