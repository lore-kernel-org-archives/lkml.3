Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaJAWJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:09:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38355 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaJAWJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:09:31 -0400
Message-ID: <542C7B99.60500@codeaurora.org>
Date: Wed, 01 Oct 2014 15:09:29 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: vfp: fix VFPv3 hwcap detection on non-ARM vfp
 implementations
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org> <1411076592-6157-3-git-send-email-sboyd@codeaurora.org> <20140918224625.GF5182@n2100.arm.linux.org.uk> <541C74C1.9060504@codeaurora.org> <20141001215043.GS5182@n2100.arm.linux.org.uk>
In-Reply-To: <20141001215043.GS5182@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/14 14:50, Russell King - ARM Linux wrote:
> On Fri, Sep 19, 2014 at 11:24:01AM -0700, Stephen Boyd wrote:
>>
>> Do you, or anyone else, know of other implementations? I *hope* that
>> this same exercise was done by the VFP architects before they
>> re-purposed bits but who knows. If nobody is actually setting these
>> higher bits then is there any problem widening the mask (besides it
>> being slightly confusing)?
> There are certainly non-ARM implementations around, eg:
>
> VFP support v0.3: implementor 56 architecture 2 part 20 variant 9 rev 5

Can you provide the raw value of the id register or at least bits 22:16?
This print is currently masking off the bits so we don't know what's
there. All we know is that bit 20 is not set because it doesn't fail to
initialize vfp.

>
> which is from Marvell Dove.  I don't know how the other Marvell offerings
> identify.  I wouldn't be surprised if there were other implementations
> from other vendors too.
>
> However, if we do have any implementation which indicates that it does
> not support both single and double precision ops (bit 20), then today
> the VFP support code refuses to initialise, and the system will behave
> as if there is no VFP present.
>
> So, the problem case is whether we do have non-ARM produced implementations
> where the VFP code refuses to init, which would then be misidentified as
> some insane architecture version.
>

I'm not aware of anything. You would know better than I though.

That check assumes a v2. We should update that check to only look for v2
or less (this isn't based on the current patch but can be squashed in).

---8<---
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 2f37e1d6cb45..22d6a1171a4e 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -738,14 +738,18 @@ static int __init vfp_init(void)
 	vfp_vector = vfp_null_entry;
 
 	pr_info("VFP support v0.3: ");
-	if (VFP_arch)
+	if (VFP_arch) {
 		pr_cont("not present\n");
-	else if (vfpsid & FPSID_NODOUBLE) {
-		pr_cont("no double precision support\n");
 	} else {
 		hotcpu_notifier(vfp_hotplug, 0);
 
 		VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;  /* Extract the architecture version */
+
+		if (VFP_arch < 2 && (vfpsid & FPSID_NODOUBLE)) {
+			pr_cont("no double precision support\n");
+			return 0;
+		}
+
 		pr_cont("implementor %02x architecture %d part %02x variant %x rev %x\n",
 			(vfpsid & FPSID_IMPLEMENTER_MASK) >> FPSID_IMPLEMENTER_BIT,
 			(vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT,


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

