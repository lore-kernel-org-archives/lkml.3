Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbaDLVlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 17:41:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:42891 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230AbaDLVlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 17:41:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,849,1389772800"; 
   d="scan'208";a="519795917"
Date: Sun, 13 Apr 2014 00:41:45 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: New Defects reported by Coverity Scan for Linux
Message-ID: <20140412214145.GL18465@intel.com>
References: <5348ea4572e7_5d4d7ac86c27677@209.249.196.67.mail>
 <CAErSpo6r3Xw8fZ7eaW=8Mg9EabtPUAOQU8ExGt4aYL--+OnLgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo6r3Xw8fZ7eaW=8Mg9EabtPUAOQU8ExGt4aYL--+OnLgA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 07:29:29AM -0600, Bjorn Helgaas wrote:
> FYI, looks like these were added by a4dff76924fe ("x86/gpu: Add Intel
> graphics stolen memory quirk for gen2 platforms").

Some of the affected gen2 platforms do support up to 2GB of RAM which
means that if the sign extension were to happen they could hit this.
However I believe all gen2 platforms are 32bit which AFAIK makes size_t 
32 bits. So looks like we can't hit this in practice..

But if someone were to change the return type to 64bits we'd
be in real danger, so I guess it would be better to fix the bug
anyway.

-#define KB(x)  ((x) * 1024)
+#define KB(x)  ((x) * 1024U)
should be sufficient to eliminate the problem. If someone wants me to
put that into a real patch and send it out let me know.

> 
> 
> ---------- Forwarded message ----------
> From:  <scan-admin@coverity.com>
> Date: Sat, Apr 12, 2014 at 1:24 AM
> Subject: New Defects reported by Coverity Scan for Linux
> To:
> 
> ...
> 
> ** CID 1201423:  Unintended sign extension  (SIGN_EXTENSION)
> /arch/x86/kernel/early-quirks.c: 290 in i830_mem_size()
> 
> ** CID 1201424:  Unintended sign extension  (SIGN_EXTENSION)
> /arch/x86/kernel/early-quirks.c: 295 in i85x_mem_size()
> 
> ...
> ________________________________________________________________________________________________________
> *** CID 1201423:  Unintended sign extension  (SIGN_EXTENSION)
> /arch/x86/kernel/early-quirks.c: 290 in i830_mem_size()
> 284
> 285             return MB(1);
> 286     }
> 287
> 288     static size_t __init i830_mem_size(void)
> 289     {
> >>>     CID 1201423:  Unintended sign extension  (SIGN_EXTENSION)
> >>>     Suspicious implicit sign extension: "read_pci_config_byte(0, 0, 0, 99)" with type "unsigned char" (8 bits, unsigned) is promoted in "read_pci_config_byte(0, 0, 0, 99) * 33554432" to type "int" (32 bits, signed), then sign-extended to type "unsigned long" (64 bits, unsigned).  If "read_pci_config_byte(0, 0, 0, 99) * 33554432" is greater than 0x7FFFFFFF, the upper bits of the result will all be 1.
> 290             return read_pci_config_byte(0, 0, 0, I830_DRB3) * MB(32);
> 291     }
> 292
> 293     static size_t __init i85x_mem_size(void)
> 294     {
> 295             return read_pci_config_byte(0, 0, 1, I85X_DRB3) * MB(32);
> 
> ________________________________________________________________________________________________________
> *** CID 1201424:  Unintended sign extension  (SIGN_EXTENSION)
> /arch/x86/kernel/early-quirks.c: 295 in i85x_mem_size()
> 289     {
> 290             return read_pci_config_byte(0, 0, 0, I830_DRB3) * MB(32);
> 291     }
> 292
> 293     static size_t __init i85x_mem_size(void)
> 294     {
> >>>     CID 1201424:  Unintended sign extension  (SIGN_EXTENSION)
> >>>     Suspicious implicit sign extension: "read_pci_config_byte(0, 0, 1, 67)" with type "unsigned char" (8 bits, unsigned) is promoted in "read_pci_config_byte(0, 0, 1, 67) * 33554432" to type "int" (32 bits, signed), then sign-extended to type "unsigned long" (64 bits, unsigned).  If "read_pci_config_byte(0, 0, 1, 67) * 33554432" is greater than 0x7FFFFFFF, the upper bits of the result will all be 1.
> 295             return read_pci_config_byte(0, 0, 1, I85X_DRB3) * MB(32);
> 296     }
> 297
> 298     /*
> 299      * On 830/845/85x the stolen memory base isn't available in any
> 300      * register. We need to calculate it as TOM-TSEG_SIZE-stolen_size.

-- 
Ville Syrjälä
Intel OTC
