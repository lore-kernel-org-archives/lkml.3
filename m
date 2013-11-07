Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab3KGMZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:25:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45707 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3KGMZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:25:12 -0500
Date: Thu, 7 Nov 2013 13:27:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
Message-ID: <20131107122716.GC27116@x1.alien8.de>
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com>
 <20131106142025.GB16072@x1.alien8.de>
 <527A6B08.5020302@gmail.com>
 <20131106165437.GA21870@x1.alien8.de>
 <527A79B5.4070507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <527A79B5.4070507@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 11:17:41AM -0600, Rob Herring wrote:
> Using some interface which is arch specific and should not be used in a
> driver.

Well, sorry, but this is not something which justifies enabling building
of compilation units on arches for which they don't apply. Rather, this
should be caught during review.

I find it highly unfair to waste cycles building stuff on an arch for
which the drivers aren't meant for. And it doesn't make any sense anyway
- I'd like all*config to get finished at some point soonish and not
build the whole world.

And, btw, highbank triggers the following on AMD64:

  CC [M]  drivers/edac/edac_pci.o
  CC [M]  drivers/edac/highbank_mc_edac.o
  CC [M]  drivers/edac/highbank_l2_edac.o
drivers/edac/highbank_mc_edac.c: In function ‘highbank_mc_probe’:
drivers/edac/highbank_mc_edac.c:210:2: warning: large integer implicitly truncated to unsigned type [-Woverflow]
  dimm->nr_pages = (~0UL >> PAGE_SHIFT) + 1;
  ^

which is clearly a bug since ->nr_pages becomes 0.

BUT(!), this bug doesn't make any sense on x86 since highbank won't load
there and yours is a 32-bit arm. (it'll probably make some sense on
arm64 assuming the native long type is 8 bytes there).

And people would start reporting those bugs and we're going to start
asking on which arch are you compiling just to realize that a bug like
that doesn't make any sense on an N/A arch.

Oh, and then other edac drivers would simply fail building:

  CC [M]  drivers/edac/octeon_edac-pc.o
drivers/edac/octeon_edac-pc.c:21:29: fatal error: asm/octeon/cvmx.h: No such file or directory
 #include <asm/octeon/cvmx.h>
                             ^
compilation terminated.
make[1]: *** [drivers/edac/octeon_edac-pc.o] Error 1

simply because x86/include doesn't have that header.

So let's not waste any more time with this topic. I think there are a
numerous other ways for achieving build coverage which make *way* *more*
sense than this.

-- 
Regards/Gruss,
Boris.
