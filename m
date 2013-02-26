Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3BZDBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 22:01:13 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58802 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3BZDBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 22:01:12 -0500
X-IronPort-AV: E=Sophos;i="4.84,736,1355126400"; 
   d="scan'208";a="26604988"
Message-ID: <512C2577.3030202@codeaurora.org>
Date: Mon, 25 Feb 2013 19:01:11 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: vfp: fix fpsid register subarchitecture field mask
 width
References: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org> <20130222182705.GC19527@mudshark.cambridge.arm.com> <5128034A.4000008@codeaurora.org> <20130225111835.GA24254@mudshark.cambridge.arm.com>
In-Reply-To: <20130225111835.GA24254@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/13 03:18, Will Deacon wrote:
> On Fri, Feb 22, 2013 at 11:46:18PM +0000, Stephen Boyd wrote:
>> On 2/22/2013 10:27 AM, Will Deacon wrote:
>>> What value do you have in fpsid? As far as I can tell, the
>>> subarchitecture bits 6:0 should start at 0x40 for you, right?
>> Yes it does.
> Ok, good. Could you share the different subarchitecture encodings that you
> have please? (assumedly some/all of these are compatible with a variant of
> VFP).

Definitely all Krait processors have 0x40 for the subarchitecture
encoding. I need to check our Scorpions but I'm fairly certain they also
have 0x40.

>
>>> I can see cases for changing this code, I just don't see why it would go
>>> wrong in the case you're describing.
>> VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;
>>
>> causes VFP_arch to be equal to 0 because 0x40 & 0xf == 0.
>>
>> and then a little bit later we have
>>
>>                if (VFP_arch >= 2) {
>>                         elf_hwcap |= HWCAP_VFPv3;
>>
>>
>> The branch is not taken so we never set VFPv3.
> Ah, that's what I feared: the low bits are zero yet you are compatible with
> VFPv3. That's fine, but the proposed fix feels like a kludge; the only reason
> we'd choose on VFPv3 is because the implementor is not ARM, which may not hold
> true for other vendors. I think it would be better if we translated
> vendor-specific subarchitectures that are compatible with VFPvN into the
> corresponding architecture number instead. This would also allow us to add
> extra hwcaps for extensions other than VFP.

Ok. We should be able to make VFP_arch into 0x4 if the implementer is
0x51 and the subarch bits are 0x40.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

