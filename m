Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3LLSBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:01:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36587 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3LLSBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:01:41 -0500
Message-ID: <52A9FA00.7080506@wwwdotorg.org>
Date: Thu, 12 Dec 2013 11:01:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com, grant.likely@linaro.org
CC: ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        swarren@nvidia.com, kerwinw@nvidia.com, david@gibson.dropbear.id.au
Subject: Re: [PATCH 1/2] of: add support for reading s32 property value
References: <1386854693-10871-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1386854693-10871-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 06:24 AM, Laxman Dewangan wrote:
> Add of_property_read_s32() to read the signed 32bit number
> from dt property value. This supports to pass the -ve numbers
> from dt. Use 2's complement method for represnting negative number
> and passed as u32 from dts. When reading back the value, again
> converted to 2's complement if msb shows as 1.

> diff --git a/include/linux/of.h b/include/linux/of.h

> +static inline int of_property_read_s32(const struct device_node *np,
> +				       const char *propname,
> +				       s32 *out_value)
> +{
> +	u32 val;
> +	int ret;
> +
> +	ret = of_property_read_u32(np, propname, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* 2's complement if MSB is 1 */
> +	*out_value = (val & 0x80000000U) ? -((val ^ 0xFFFFFFFFU) + 1) : val;

I may not be thinking straight today since I have a cold, but doesn't
patch 2/2 encode negative values as 2's complement, and an s32 variable
in the kernel is also encoded as 2's complement, so all you need here is
a cast:

	*out_value = (s32)val;

... since the cast doesn't change the binary representation?
