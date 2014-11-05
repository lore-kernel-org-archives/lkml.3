Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaKEO4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:56:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57076 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbaKEO4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:56:13 -0500
Date: Wed, 5 Nov 2014 15:56:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: Build module on x86-32
Message-ID: <20141105145603.GE5245@pd.tnic>
References: <20141102102212.GA7034@polanet.pl>
 <20141102103300.GB5229@pd.tnic>
 <20141102121139.GA7000@polanet.pl>
 <20141102123538.GE5229@pd.tnic>
 <20141102140839.GA27342@polanet.pl>
 <20141103105508.GB27384@pd.tnic>
 <20141105120324.GB3467@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141105120324.GB3467@polanet.pl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 01:03:24PM +0100, Tomasz Pala wrote:
> This system was backed-up by some Intel one without 64-bit support and
> it needed to be fully binary-compatible (including databases storage).
> 
> Over the time, as older hardware is disposed, it might eventually be
> upgraded to 64-bit kernel running 32-bit userland in compat mode (full
> transition is not going to happen soon as costs of such operation, i.e.
> dumping and restoring all the data, application tests etc. greatly
> overweight any benefits), but even the kernel change is not trivial due
> to many quirks that happened every time before (and it was really hard
> to find some stable configuration). Thus, until there is some bigger
> maintaince undergoing or the hardware reaches it's lifetime, noone is
> going to "pay" (allocate time, people at night shifts etc.) for such
> change.

Ok, understood.

> There's not much of if related (system is running 3.14.4):

CONFIG_EDAC_DEBUG gives additional debugging output and this is without
it but it doesn't matter - I see you have a K8 box.

> That is decent solution IMHO. There is a warning visible in logs (not
> only in sources or during configuration), so everyone interested would
> be informed in the first place they should start reading after any
> possible error happens.

I hope :)

> Mostly because "If it ain't broke, don't fix it" rule. These are systems
> with a few hundreds days uptime (e.g. 3 weeks ago some malfunction
> caused 1,5 half year uptime machine to reboot, 500-900 days are not so
> uncommon, I remember my pain rebooting machines over 1200 days online).
> Restarting them usually causes some minor troubles (not saved changes),
> changing software leads to compat troubles (that might be tested before
> going to production), but changing kernel makes uncertainty about entire
> platform, so it is avoided until necessary (and these running are
> polished as much as possible, with backported bugfixes etc.) So
> replacing rock-solid kernel with some other is a no-go, even preserving
> the current sources (there might always be some 64-bit related bugs).

I see.

Just FYI though, one serious advantage of 64-bit is that gets orders of
magnitude more testing than 32-bit so if you still are contemplating a
64-bit switch someday, remember that fact. :)

> > The driver supports everything from K8 on which can do ECC. Family 11h
> > doesn't support ECC so no need for an EDAC driver. I hope this answers
> 
> I mean your '[PATCH] amd64_edac: Document why it is 64-bit only':
> 
> -         the AMD64 families of memory controllers (K8 and F10h)
> +         the AMD64 families of memory controllers, everything >= K8.
> 
> "everything >= K8" mislead me.

Ok, it is supposed to say, on everything K8 and later. K8 is what you
have. What would make it more understandable?

So here's an updated version of your patch:

---
From: Tomasz Pala <gotar@polanet.pl>
Subject: [PATCH] amd64_edac: Build module on x86-32

By popular demand, enable amd64_edac on 32-bit too.

Boris:
 - update Kconfig text.
 - add a warning on load which states that 32-bit configurations are unsupported.

Signed-off-by: Tomasz Pala <gotar@polanet.pl>
Link: http://lkml.kernel.org/r/20141102102212.GA7034@polanet.pl
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/Kconfig      | 6 +++---
 drivers/edac/amd64_edac.c | 5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 7072c2892d63..4316c9e955b3 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -105,11 +105,11 @@ config EDAC_GHES
 	  In doubt, say 'Y'.
 
 config EDAC_AMD64
-	tristate "AMD64 (Opteron, Athlon64) K8, F10h"
-	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && EDAC_DECODE_MCE
+	tristate "AMD64 (Opteron, Athlon64)"
+	depends on EDAC_MM_EDAC && AMD_NB && EDAC_DECODE_MCE
 	help
 	  Support for error detection and correction of DRAM ECC errors on
-	  the AMD64 families of memory controllers (K8 and F10h)
+	  the AMD64 families (>= K8) of memory controllers.
 
 config EDAC_AMD64_ERROR_INJECTION
 	bool "Sysfs HW Error injection facilities"
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 1a1d7c43a20f..17638d7cf5c2 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3035,6 +3035,11 @@ static int __init amd64_edac_init(void)
 		goto err_no_instances;
 
 	setup_pci_device();
+
+#ifdef CONFIG_X86_32
+	amd64_err("%s on 32-bit is unsupported. USE AT YOUR OWN RISK!\n", EDAC_MOD_STR);
+#endif
+
 	return 0;
 
 err_no_instances:
-- 
2.0.0


Thanks.



-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
