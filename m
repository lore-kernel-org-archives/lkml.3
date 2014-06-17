Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaFQLJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:09:18 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60685 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752626AbaFQLJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:09:17 -0400
Date: Tue, 17 Jun 2014 12:09:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Rob Clark <robdclark@gmail.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v3] ARM: add get_user() support for 8 byte types
Message-ID: <20140617110908.GH23430@n2100.arm.linux.org.uk>
References: <1402587755-29245-1-git-send-email-daniel.thompson@linaro.org> <20140612155843.GK23430@n2100.arm.linux.org.uk> <53A015B3.2070809@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A015B3.2070809@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 11:17:23AM +0100, Daniel Thompson wrote:
> ... at this point there is a narrowing cast followed by an implicit
> widening. This results in compiler either ignoring r3 altogether or, if
> spilling to the stack, generating code to set r3 to zero before doing
> the store.

In actual fact, there's very little difference between the two
implementations in terms of generated code.

The difference between them is what happens on the 64-bit big endian
narrowing case, where we use __get_user_4 with your version.  This
adds one additional instruction.

The little endian case results in identical code except for register
usage - for example, with my test for a 32-bit being widened to 64-bit:

        str     lr, [sp, #-4]!
-       mov     r3, r0
+       mov     ip, r0
        mov     r0, r1
 #APP
 @ 280 "t-getuser.c" 1
        bl      __get_user_4
 @ 0 "" 2
-       str     r2, [r3, #0]
-       mov     r2, #0
-       str     r2, [r3, #4]
+       mov     r3, #0
+       str     r2, [ip, #0]
+       str     r3, [ip, #4]
        ldr     pc, [sp], #4

and 64-bit narrowed to 32-bit:

        str     lr, [sp, #-4]!
-       mov     ip, r0
+       mov     r3, r0
        mov     r0, r1
 #APP
 @ 275 "t-getuser.c" 1
-       bl      __get_user_8
+       bl      __get_user_4
 @ 0 "" 2
-       str     r2, [ip, #0]
+       str     r2, [r3, #0]
        ldr     pc, [sp], #4

In terms of type checking, both seem to get it correct (which is something
I'm concerned about by any implementation since this is just as important
as the generated code).

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
