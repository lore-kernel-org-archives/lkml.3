Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaLOAym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 19:54:42 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:47335 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLOAyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 19:54:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAH2r5mucwo_FH4M=UUoLNDZNRFFcG9hd=Gxc7ma5jwkJQ2-qTg@mail.gmail.com>
References: <1415653764-22162-1-git-send-email-cernekee@gmail.com>
 <CAJiQ=7C9qV2acVLWjacwsRmGMbyKUqCT5VbnO5TzeLLX73xMaQ@mail.gmail.com>
 <CAH2r5mteTRPVNTgVxNLqjdzok87HXxhC+xo+tnR3L0DKntSe6g@mail.gmail.com>
 <CAJiQ=7APtRLarnAFFaDy1_KgnBN-wcK2=scOP5Ks0v5GH=AR3Q@mail.gmail.com> <CAH2r5mucwo_FH4M=UUoLNDZNRFFcG9hd=Gxc7ma5jwkJQ2-qTg@mail.gmail.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Sun, 14 Dec 2014 16:54:12 -0800
Message-ID: <CAJiQ=7B5L=ZrJYSCuUDkG+qtUOUHueAwsWut4KyBTsj0xE+q5w@mail.gmail.com>
Subject: Re: [PATCH 1/2] [CIFS] Fix signed/unsigned pointer warning
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 4:28 PM, Steve French <smfrench@gmail.com> wrote:
> On Sat, Dec 13, 2014 at 11:29 PM, Kevin Cernekee <cernekee@gmail.com> wrote:
>> On Sat, Dec 13, 2014 at 9:20 PM, Steve French <smfrench@gmail.com> wrote:
>>> Probably harmless patch - but I didn't notice the warning on x86
>>> kernel build (building on Fedora 21, gcc 4.9.2)
>>
>> Did you test x86 32-bit or 64-bit?  In the generic do_div()
>
> I built current mainline with 64 bit disabled. No warnings on this
> before or after the patch.

Ah, right, it only shows up on 32-bit architectures that use the
generic do_div implementation.  To see the warning on x86, you'd need
to do something like this:

$ git --no-pager diff
diff --git a/arch/x86/include/asm/div64.h b/arch/x86/include/asm/div64.h
index ced283a..f693002 100644
--- a/arch/x86/include/asm/div64.h
+++ b/arch/x86/include/asm/div64.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_DIV64_H
 #define _ASM_X86_DIV64_H

-#ifdef CONFIG_X86_32
+#if 0//def CONFIG_X86_32

 #include <linux/types.h>
 #include <linux/log2.h>
$ touch fs/cifs/netmisc.c
$ make ARCH=x86 vmlinux
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      fs/cifs/netmisc.o
fs/cifs/netmisc.c: In function ‘cifs_NTtimeToUnix’:
fs/cifs/netmisc.c:937:23: warning: comparison of distinct pointer
types lacks a cast [enabled by default]
fs/cifs/netmisc.c:941:22: warning: comparison of distinct pointer
types lacks a cast [enabled by default]
  LD      fs/cifs/cifs.o
  LD      fs/cifs/built-in.o
  LD      fs/built-in.o
  LINK    vmlinux
  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  KSYM    .tmp_kallsyms1.o
  KSYM    .tmp_kallsyms2.o
  LD      vmlinux
  SORTEX  vmlinux
  SYSMAP  System.map
$


> merged into cifs-2.6.git

Thanks!
