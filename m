Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3ALRGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:06:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51906 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab3ALRGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:06:50 -0500
Date: Sat, 12 Jan 2013 18:06:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, David.Woodhouse@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86: Default to ARCH= x86 to avoid overriding
 CONFIG_64BIT
Message-ID: <20130112170647.GA10659@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	David Woodhouse <dwmw2@infradead.org>, mingo@kernel.org,
	hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
	hpa@linux.intel.com, David.Woodhouse@intel.com,
	linux-tip-commits@vger.kernel.org
References: <1356040315.3198.51.camel@shinybook.infradead.org>
 <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 06:07:46PM -0800, tip-bot for David Woodhouse wrote:
> Commit-ID:  ffee0de411fd4f74f3b788892eeb075abbf26c52
> Gitweb:     http://git.kernel.org/tip/ffee0de411fd4f74f3b788892eeb075abbf26c52
> Author:     David Woodhouse <dwmw2@infradead.org>
> AuthorDate: Thu, 20 Dec 2012 21:51:55 +0000
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 20 Dec 2012 14:37:18 -0800
> 
> x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT
> 
> It is easy to waste a bunch of time when one takes a 32-bit .config
> from a test machine and try to build it on a faster 64-bit system, and
> its existing setting of CONFIG_64BIT=n gets *changed* to match the
> build host.  Similarly, if one has an existing build tree it is easy
> to trash an entire build tree that way.
> 
> This is because the default setting for $ARCH when discovered from
> 'uname' is one of the legacy pre-x86-merge values (i386 or x86_64),
> which effectively force the setting of CONFIG_64BIT to match. We should
> default to ARCH=x86 instead, finally completing the merge that we
> started so long ago.

Ok, I don't know whether this was on purpose or not but setting ARCH=x86
has the side effect of putting the config 64BIT prompt into the toplevel
menuconfig:

	[*] 64-bit kernel
	    General setup  --->
	[*] Enable loadable module support  --->
	[*] Enable the block layer  --->
	    Processor type and features  --->

Now, IMHO, maybe the more fitting place for this should be "Processor
type and features" where all the arch-specific stuff goes but looking at
arch/x86/Kconfig, it would need some restructuring due to dependencies.

So how about we simply hide it by still preserving the functionality:

--
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50b1b1bf442b..e8d7e9250853 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,6 +1,7 @@
 # Select 32 or 64 bit
 config 64BIT
-	bool "64-bit kernel" if ARCH = "x86"
+	bool
+	default y if ARCH = "x86"
 	default ARCH != "i386"
 	---help---
 	  Say yes to build a 64-bit kernel - formerly known as x86_64

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
