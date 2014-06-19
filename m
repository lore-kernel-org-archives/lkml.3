Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbaFSUcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:32:19 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:35142 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaFSUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:32:15 -0400
Date: Thu, 19 Jun 2014 16:32:12 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
cc: Stephen Boyd <sboyd@codeaurora.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Olof Johansson <olof@lixom.net>,
        Linaro Networking <linaro-networking@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: zImage: ensure header in LE format for BE8
 kernels
In-Reply-To: <7hk38cycuh.fsf@paris.lan>
Message-ID: <alpine.LFD.2.11.1406191630260.16842@knanqh.ubzr>
References: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org> <CAGa+x85P-M3qUD6L=kezkiQ1NJymEZ9P=u2ANUZJu2b3F+o5LA@mail.gmail.com> <53A1D701.8060404@codeaurora.org> <CAGa+x86DfDjQG8gN2-x7Kapt2ipsYt879R4OK6JWGoaT93VVig@mail.gmail.com>
 <53A1D8FE.6030404@codeaurora.org> <CAGa+x87rnQntQpTkR6dZr29NvEQ4x8SOAyo+z9xuYHEdxdG1xg@mail.gmail.com> <alpine.LFD.2.11.1406181720130.16842@knanqh.ubzr> <7hk38cycuh.fsf@paris.lan>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Kevin Hilman wrote:

> I think this should probably be officialized since we've taken away the
> ability for magic-number checking tools (like 'file') to distinguish
> between big- and little-endian zImages.
> 
> For now, I've updated my tools to check for 'setend be' in ARM and
> Thumb2 mode, but if this does get officialized, I'll gladly move over to
> it.

Would you ACK this patch?

----- >8
ARM: zImage: identify kernel endianness

With patch #8067/1 applied, it is no longer possible to determine the
endianness of a compiled kernel image.  This normally shouldn't matter
to the boot environment, except for those cases where the selection of
a ramdisk or root filesystem with a matching endianness has to be
automated.

Let's add a flag to the zImage header indicating the actual endianness.
Four bytes from offset 0x30 can be interpreted as follows:

	04 03 02 01	big endian kernel

	01 02 03 04	little endian kernel

Anything else should be interpreted as "unknown", in which case it is
most likely that patch #8067/1 was not applied either and the zImage
magic number at offset 0x24 could be used instead to determine
endianness. No zImage before this patch ever produced 0x01020304 nor
0x04030201 at offset 0x30 so there is no confusion possible.

Signed-off-by: Nicolas Pitre <nico@linaro.org>


diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index c95feab6ce..413fd94b53 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -128,6 +128,7 @@ start:
 		.word	_magic_sig	@ Magic numbers to help the loader
 		.word	_magic_start	@ absolute load/run zImage address
 		.word	_magic_end	@ zImage end address
+		.word	0x04030201	@ endianness flag
 
  THUMB(		.thumb			)
 1:
