Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3LPTTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:19:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55856 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3LPTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:19:43 -0500
Message-ID: <52AF5249.6050802@wwwdotorg.org>
Date: Mon, 16 Dec 2013 12:19:37 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, swarren@nvidia.com, will.deacon@arm.com,
        grant.likely@linaro.org, thierry.reding@gmail.com,
        robherring2@gmail.com, joro@8bytes.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, galak@codeaurora.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 10/12] iommu/tegra: smmu: allow duplicate ASID wirte
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-11-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1386835033-4701-11-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 12:57 AM, Hiroshi Doyu wrote:
> The device, which belongs to the same ASID, can try to enable the same
> ASID as the other swgroup devices. This should be allowed but just
> skip the actual register write. If the write value is different, it
> will return -EINVAL.

I guess this simplifies the body of the code a lot. Given this, I would
revise the code I suggested in response to a previous patch, to
something more like:

		offs = HWGRP_ASID_REG(i);
		val = smmu_read(smmu, offs);
		if (on) {
			if (WARN_ON(val && val != new_val))
				return -ENODEV;
			memcpy(c->hwgrp, map, sizeof(u64));
		} else {
			WARN_ON(val);
		}
		smmu_write(smmu, val, offs);

> +			if (val) {
> +				if (WARN_ON(val != mask))
> +					return -EINVAL;
> +				goto skip;

That means that:

a) No error is returned when the ASIDs don't match. Surely you still
want to return an error?

b) "skip" skips setting up all HWGRP IDs for the device, whereas perhaps
only 1 was shared yet the rest still need to be set up. If you really do
want to ignore the error, then surely you want "continue;" here not
"goto skip;"?

> +			}
...
> +skip:
>  	return 0;

