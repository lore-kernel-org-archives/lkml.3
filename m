Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaIWOhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:37:18 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60216 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaIWOhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:37:16 -0400
Date: Tue, 23 Sep 2014 15:37:12 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20140923143712.GI18635@console-pimps.org>
References: <20140919104021.GA11552@gmail.com>
 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
 <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
 <20140923055802.GA29052@gmail.com>
 <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
 <20140923131805.GH18635@console-pimps.org>
 <542182E0.6090101@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <542182E0.6090101@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep, at 04:25:36PM, Maarten Lankhorst wrote:
> It seems to boot for me with direct efi netboot. But when I'm doing a
> local boot through refind instead I also hit that setup_efi_pci()
> failed bug, it doesn't look like it's fixed by reverting all the efi
> stub patches though.  This might need more bisecting first...

Thanks for testing!

The "setup_efi_pci() failed!" message doesn't indicate a bug, it's
superfluous and I've queued up the below patch for v3.18.

But maybe we should merge it sooner since people are likely to interpret
it as indicating there's some boot bug (there isn't).

I know Josh was in favour of getting this message dropped and treating
this as a regression fix, but I was erring on the side of caution
because it's not critical.

tip folks, if I sent this patch to you in a pull request, would you
merge it?

---

>From c988616127c10d8c68dd1b9b946cddf51e4ca718 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Thu, 11 Sep 2014 09:04:25 +0100
Subject: [PATCH] x86/efi: Delete misleading efi_printk() error message
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A number of people are reporting seeing the "setup_efi_pci() failed!"
error message in what used to be a quiet boot,

  https://bugzilla.kernel.org/show_bug.cgi?id=81891

The message isn't all that helpful because setup_efi_pci() can return a
non-success error code for a variety of reasons, not all of them fatal.

Drop the efi_printk() now that we have more fine-grained, and more
specific, error messages throughout the *setup_efi_pci*() code paths.

Reported-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ulf Winkelvos <ulf@winkelvos.de>
Cc: Andre Müller <andre.muller@web.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ed8e06c59a4c..87398f9434f3 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1394,10 +1394,7 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	setup_graphics(boot_params);
 
-	status = setup_efi_pci(boot_params);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "setup_efi_pci() failed!\n");
-	}
+	setup_efi_pci(boot_params);
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				sizeof(*gdt), (void **)&gdt);
-- 
1.9.3

-- 
Matt Fleming, Intel Open Source Technology Center
