Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaAMODp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:03:45 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:50542 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbaAMODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:03:43 -0500
Date: Mon, 13 Jan 2014 14:03:34 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Joe Perches <joe@perches.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] efi: Fix krealloc defect
Message-ID: <20140113140334.GB3256@console-pimps.org>
References: <cover.1388793978.git.joe@perches.com>
 <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Jan, at 04:08:47PM, Joe Perches wrote:
> krealloc should use a temporary pointer for allocations
> and check the temporary pointer returned against NULL too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  arch/x86/platform/efi/efi.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Thanks Joe, but I've already got the following commit queued up from
Borislav that addresses this,

---

>From ee41143027706d9f342dfe05487a00b20887fde7 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Thu, 31 Oct 2013 17:25:09 +0100
Subject: [PATCH] x86/efi: Check krealloc return value

Check it just in case. We might just as well panic there because runtime
won't be functioning anyway.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b453069236fd..3fac4dee492f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -860,6 +860,9 @@ void __init efi_enter_virtual_mode(void)
 		new_memmap = krealloc(new_memmap,
 				      (count + 1) * memmap.desc_size,
 				      GFP_KERNEL);
+		if (!new_memmap)
+			goto err_out;
+
 		memcpy(new_memmap + (count * memmap.desc_size), md,
 		       memmap.desc_size);
 		count++;
@@ -914,6 +917,11 @@ void __init efi_enter_virtual_mode(void)
 			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
 			 EFI_VARIABLE_RUNTIME_ACCESS,
 			 0, NULL);
+
+	return;
+
+ err_out:
+	pr_err("Error reallocating memory, EFI runtime non-functional!\n");
 }
 
 /*
-- 
1.8.3.1

-- 
Matt Fleming, Intel Open Source Technology Center
