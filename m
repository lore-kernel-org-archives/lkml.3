Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbaACIOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 03:14:24 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45288 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaACIOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 03:14:23 -0500
Date: Fri, 3 Jan 2014 00:12:19 -0800
From: Olof Johansson <olof@lixom.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, chzigotzky@xenosoft.de
Subject: Re: [PATCH] powerpc: Fix alignment of secondary cpu spin vars
Message-ID: <20140103081219.GA10233@quad.lixom.net>
References: <1388264507-5100-1-git-send-email-olof@lixom.net>
 <CAOesGMhHw-G-T7ZfNsVU92ftOucCNe9shNJtA7SWzqX=dQBQng@mail.gmail.com>
 <CAOesGMgsY0R6KBXXH_ibTBYb1i_auWESwnoDkvi-esb58Pc+2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgsY0R6KBXXH_ibTBYb1i_auWESwnoDkvi-esb58Pc+2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 11:56:04PM -0800, Olof Johansson wrote:

> This makes things interesting though. The BE/LE trampoline code
> assumes at least 3 consecutive instructions. What was the reasoning
> behind entering the kernel LE instead of keeping the old boot protocol
> and just switching to LE once kernel is loaded? Is it actually used on
> some platforms or is this just a theoretical thing?

Actually, adding a little hack that zeroes out the memory once we're done
executing it will work just fine too. I know this is sort of icky, but maybe
it'll be good enough for now?

Of course, main worry is that this is just hiding some latent NULL deref in
the kernel now... :-/


-Olof

--- 8< --- 8< --- 8< --- 8< --- 8< --- 8< --- 8< --- 8< --- 8< --- 

>From 4d003186cae546900cefc9e51b0ed4e65f775be1 Mon Sep 17 00:00:00 2001
From: Olof Johansson <olof@lixom.net>
Date: Fri, 3 Jan 2014 00:09:28 -0800
Subject: [PATCH] powerpc: set some low memory contents to 0 early

The little-endian code adds some code path to __start, which essentially ends
up adding memory contents in low memory that didn't use to be there.

That seems to have triggered a latent bug, either in firmware or kernel, where
the 64-bit word located at physical address 8 needs to be 0.

The simple hack for this right now is to write it to 0 after we're done
executing it, which is what this patch does. Unfortunately I no longer
seem to have a working JTAG setup nor firmware sources, so debugging
this down to root cause might be more trouble than it's worth given the
relatively simple workaround.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 arch/powerpc/kernel/head_64.S |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 2ae41ab..437d8bd 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -69,6 +69,13 @@ _GLOBAL(__start)
 	/* NOP this out unconditionally */
 BEGIN_FTR_SECTION
 	FIXUP_ENDIAN
+	/* Hack for PWRficient platforms: Due to CFE(?) bug, the 64-bit
+	 * word at 0x8 needs to be set to 0. Patch it up here once we're
+	 * done executing it (we can be lazy and avoid invalidating
+	 * icache)
+	 */
+	li	r0,0
+	std	0,8(0)
 	b	.__start_initialization_multiplatform
 END_FTR_SECTION(0, 1)
 
-- 
1.7.10.4

