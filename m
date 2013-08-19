Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab3HSJIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:08:55 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:52723 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3HSJIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:08:54 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "noamc@ezchip.com" <noamc@ezchip.com>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARC: gdbserver breakage in Big-Endian configuration
 #1
Thread-Topic: [PATCH 1/2] ARC: gdbserver breakage in Big-Endian
 configuration #1
Thread-Index: AQHOlD6fLQ6ePSLyhkCzpBPskZqXrA==
Date: Mon, 19 Aug 2013 09:08:49 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307513FD98@IN01WEMBXA.internal.synopsys.com>
References: <1375969958-16454-1-git-send-email-vgupta@synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I'd posted these patches for stable backport. Do I need to do anything more to get them included.

https://patchwork.kernel.org/patch/2841153/  [1/2] ARC: gdbserver breakage in Big-Endian configuration #1<https://patchwork.kernel.org/patch/2841153/>]
https://patchwork.kernel.org/patch/2841158/  [2/2] ARC: gdbserver breakage in Big-Endian configuration #2<https://patchwork.kernel.org/patch/2841158/>

Thx,
-Vineet


On 08/08/2013 07:23 PM, Vineet Gupta wrote:

Exception handling keeps additional state (whether exception was Trap
and if it was due to a breakpoint) in pt_regs->event, a bitfield member

        unsigned long orig_r8:16, event:16;

A bitfield esentially has an "offset" and a "length". What I wasn't
aware of was that, bitfields in a union loose the "offset" attribute
and all of them are laid out at offset 0.

This obviously means that both @event and @orig_r8 will be incorrectly
referenced to at same "0" offset by "C" generated code which is
certainly wrong, not because both members are accessed, but because asm
code updates it at different address.

In Little Endian config, @event is at offset 0 and @orig_r8 (not
actively used at all) clashing with it is OK. However in Big Endian
config,

        ST 0xNNNN_EEEE, [addr]

writes 0xEEEE to @event (offset 2 in memory) while "C" code references
it from 0.

Needless to say, this causes ptrace machinery to not detect the breakpoint
scenario (and incorrect stop_pc returned to gdbserver).

------>8---------------
Thi issue is already fixed in mainline 3.11 kernel as part of commit:
502a0c775c7f0a "ARC: pt_regs update #5"

However that patch has lot more changes than I would like backporting,
hence this seperate change.
------>8---------------

Reported-by: Noam Camus <noamc@ezchip.com><mailto:noamc@ezchip.com>
Cc: <stable@vger.kernel.org><mailto:stable@vger.kernel.org> # [3.9 and 3.10 only]
Tested-by: Anton Kolesov <akolesov@synopsys.com><mailto:akolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com><mailto:vgupta@synopsys.com>
---
 arch/arc/include/asm/ptrace.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index 6179de7..2046a89 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -52,12 +52,14 @@ struct pt_regs {

        /*to distinguish bet excp, syscall, irq */
        union {
+               struct {
 #ifdef CONFIG_CPU_BIG_ENDIAN
                /* so that assembly code is same for LE/BE */
                unsigned long orig_r8:16, event:16;
 #else
                unsigned long event:16, orig_r8:16;
 #endif
+               };
                long orig_r8_word;
        };
 };


