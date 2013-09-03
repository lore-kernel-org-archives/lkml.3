Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab3ICMq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:46:56 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:61255 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab3ICMqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:46:54 -0400
Message-ID: <5225DA21.3000102@gmail.com>
Date: Tue, 03 Sep 2013 07:46:25 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (arm
 tree related)
References: <20130903181824.796e74465274b23387d3e715@canb.auug.org.au> <20130903090414.GA25658@flint.arm.linux.org.uk>
In-Reply-To: <20130903090414.GA25658@flint.arm.linux.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 04:04 AM, Russell King wrote:
> On Tue, Sep 03, 2013 at 06:18:24PM +1000, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the final tree, today's linux-next build (arm defconfig)
>> failed like this:
>>
>> arch/arm/kernel/built-in.o: In function `setup_arch':
>> io.c:(.init.text+0x594): undefined reference to `erratum_a15_798181_init'
>>
>> Presumably caused by commit 34905a33184a ("ARM: 7804/2: Add check for
>> Cortex-A15 errata 798181 ECO").  This build does not have CONFIG_SMP set.
>>
>> I have reverted that commit for today.
> 
> Yep, and I think I'm going to do the same, rather than try and fix it.
> 

Ah crap, I guess I should have left the ifdefs instead of trying to use
IS_ENABLED.

Here's a fix if you want it. Otherwise I can fold this in and resubmit it
rebased on top of Will's barriers series.

Rob

8<--------------------------------------------
From: Rob Herring <rob.herring@calxeda.com>
Date: Tue, 3 Sep 2013 07:35:41 -0500
Subject: [PATCH] ARM: fix undefined reference to erratum_a15_798181_init on
 !SMP

Fix build error on !SMP builds introduced by commit 34905a33184a ("ARM:
804/2: Add check for Cortex-A15 errata 798181 ECO"):

arch/arm/kernel/built-in.o: In function `setup_arch':
io.c:(.init.text+0x594): undefined reference to `erratum_a15_798181_init'

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/include/asm/tlbflush.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/tlbflush.h b/arch/arm/include/asm/tlbflush.h
index decff8d..e6217a1 100644
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -443,7 +443,11 @@ static inline void local_flush_bp_all(void)
 		isb();
 }
 
+#ifdef CONFIG_ARM_ERRATA_798181
 extern void erratum_a15_798181_init(void);
+#else
+static inline void erratum_a15_798181_init(void) {}
+#endif
 extern bool (*erratum_a15_798181_handler)(void);
 
 static inline bool erratum_a15_798181(void)
-- 
1.8.1.2

