Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3C1VEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:04:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47466 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3C1VE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:04:29 -0400
Date: Thu, 28 Mar 2013 21:04:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dove: fix Dove cpu type from V7 to PJ4
Message-ID: <20130328210412.GG3368@n2100.arm.linux.org.uk>
References: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130328170654.GX13280@titan.lakedaemon.net> <20130328181425.GE3368@n2100.arm.linux.org.uk> <5154A5B5.7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5154A5B5.7@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 09:19:01PM +0100, Sebastian Hesselbarth wrote:
> On 03/28/2013 07:14 PM, Russell King - ARM Linux wrote:
>> On Thu, Mar 28, 2013 at 01:06:54PM -0400, Jason Cooper wrote:
>>> On Sat, Mar 23, 2013 at 04:06:51PM +0100, Sebastian Hesselbarth wrote:
>>>> The CPU used in Marvell Dove SoCs is a PJ4 Sheeva core. Using
>>>> CONFIG_CPU_PJ4 instead of CONFIG_CPU_V7 will also allow to enable
>>>> iWMMXt extensions on Dove.
>>>>
>>>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>>>> ---
>>>> Cc: Russell King<linux@arm.linux.org.uk>
>>>> Cc: Jason Cooper<jason@lakedaemon.net>
>>>> Cc: Andrew Lunn<andrew@lunn.ch>
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> ---
>>>>   arch/arm/Kconfig |    2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> Hmmm, I'm getting (with dove_defconfig):
>>>
>>> arch/arm/kernel/built-in.o: In function `iwmmxt_do':
>>> /.../arch/arm/kernel/pj4-cp0.c:36: undefined reference to `iwmmxt_task_release'
>>> /.../arch/arm/kernel/pj4-cp0.c:40: undefined reference to `iwmmxt_task_switch'
>>> make: *** [vmlinux] Error 1
>>
>> Looks to me like PJ4 IWMMXT support wasn't properly tested out when it
>> was submitted - it's possible to end up with pj4-cp0.c built without
>> the IWMMXT code that it depends on being built...
>
> Russel, Jason,
>
> do we force iWMMXt on CPU_PJ4 or should there be some #ifdef'ery if  
> IWMMXT is not selected?

>From what I could see, there's not much point to pj4-cp0.c without
iwmmxt.S also being built.  So, what I'd suggest is this, which will
ensure IWMMXT is enabled when PJ4 is set, otherwise giving people the
choice as it used to be.

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 67874b8..ef6733a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1171,9 +1171,9 @@ config ARM_NR_BANKS
 	default 8
 
 config IWMMXT
-	bool "Enable iWMMXt support"
+	bool "Enable iWMMXt support" if !CPU_PJ4
 	depends on CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_PJ4
-	default y if PXA27x || PXA3xx || ARCH_MMP
+	default y if PXA27x || PXA3xx || ARCH_MMP || CPU_PJ4
 	help
 	  Enable support for iWMMXt context switching at run time if
 	  running on a CPU that supports it.

