Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbaFIIZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:25:44 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26106 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbaFIIZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:25:39 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-f0-53956f80f9cc
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: "'Michal Nazarewicz'" <mina86@mina86.com>, "'Felipe Balbi'" <balbi@ti.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1402045976-26580-1-git-send-email-mina86@mina86.com>
 <1402045976-26580-5-git-send-email-mina86@mina86.com>
In-reply-to: <1402045976-26580-5-git-send-email-mina86@mina86.com>
Subject: RE: [PATCHv2 5/5] tools: ffs-test: add compatibility code for old
 kernels
Date: Mon, 09 Jun 2014 10:25:39 +0200
Message-id: <006601cf83bc$66197b30$324c7190$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+BZ4Yw44op+tusSICAHbODtx1YJACUs8WQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7oN+VODDaas5LM4eL/e4vbEaWwW
	l3fNYbNYtKyV2WLB8RZWB1aPdX9eMXn0bVnF6HH8xnYmj8+b5AJYorhsUlJzMstSi/TtErgy
	ek5MZCu4I1Kx/9sklgbG6QJdjJwcEgImEm/33mGDsMUkLtxbD2RzcQgJLGWU2DD1ETOE08Ak
	8fLEO5YuRg4ONgF9iXm7REEaRATKJT70/2YCCTMLWEv83JcPEhYSqJTYtmgeK4jNKeAkcWjr
	UrD5wgIhEi8XnmYHsVkEVCWuXDrGBGLzCjhK/Lm7lx3CFpT4MfkeC4jNLKAuMWneImYIW1vi
	ybsLrCCrJIDij/7qQlxgJHHyeRtUibjEpAcP2ScwCs1CMmkWkkmzkEyahaRlASPLKkbR1NLk
	guKk9FwjveLE3OLSvHS95PzcTYyQSPi6g3HpMatDjAIcjEo8vAlMU4OFWBPLiitzDzFKcDAr
	ifD65ACFeFMSK6tSi/Lji0pzUosPMTJxcEo1MB6at6Hq53OjlxsKL/S+SLgz4ZF7bLDuZv64
	es/OF8FfZokKvHG61zo1edbxl0LlutN2Jpp5SfDrR0cXWZn11ZnNZHfUNdC5m695WO6sU6xM
	t9F7nck52W+Vq2ZuN1R441Y1b+0m87yTS2r9FAyMf/54qrVwZfapYv6Qb0ucrbbav/M6rigV
	osRSnJFoqMVcVJwIALiH1rhiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> -----Original Message-----
> From: Michal Nazarewicz [mailto:mina86@mina86.com]
> Sent: Friday, June 06, 2014 11:13 AM
> To: Felipe Balbi; Krzysztof Opasiak
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Michal
> Nazarewicz
> Subject: [PATCHv2 5/5] tools: ffs-test: add compatibility code for
> old kernels

(... snip ...)

> +static size_t descs_to_legacy(void **legacy, const void
> *descriptors) {
> +	__u32 length, flags, fs_count = 0, hs_count = 0, count;
> +	const unsigned char *descs = descriptors, *usb_descs;
> +	unsigned char *out;
> +
> +	if (get_unaligned_le32(descs) !=
> FUNCTIONFS_DESCRIPTORS_MAGIC_V2)
> +		return 0;
> +
> +	length = get_unaligned_le32(descs + 4);
> +	if (length < 8)
> +		return 0;
> +	descs += 8;
> +	length -= 8;
> +
> +#define GET_LE32(ret) do {				\
> +		if (length < 4)				\
> +			return 0;			\
> +		ret = get_unaligned_le32(descs);	\
> +		descs += 4;				\
> +		length -= 4;				\
> +	} while (0)
> +
> +	GET_LE32(flags);
> +	if (flags & FUNCTIONFS_HAS_FS_DESC)
> +		GET_LE32(fs_count);
> +	if (flags & FUNCTIONFS_HAS_HS_DESC)
> +		GET_LE32(hs_count);
> +	if (!fs_count && !hs_count)
> +		return 0;
> +	if (flags & FUNCTIONFS_HAS_SS_DESC)
> +		GET_LE32(count);  /* The value is ignored later on
> anyway. */
> +	if (flags)
> +		return 0;

As far as I understand you are taking the flags from descriptor and then test them with possible ffs speed flags, after getting flags your are not assigning anything to this variable so in this place it will be != 0  unless none of the flags has been provided. I don't think this is intended behavior.

> +
> +#undef GET_LE32
> +
> +	usb_descs = descs;
> +	for (count = fs_count + hs_count; count; --count) {
> +		if (length < *descs)
> +			return 0;
> +		length -= *descs;
> +		descs += *descs;
> +	}
> +
> +	length = 16 + (descs - usb_descs);
> +	out = malloc(length);
> +	put_unaligned_le32(FUNCTIONFS_DESCRIPTORS_MAGIC, out);
> +	put_unaligned_le32(length, out + 4);
> +	put_unaligned_le32(fs_count, out + 8);
> +	put_unaligned_le32(hs_count, out + 12);
> +	memcpy(out + 16, usb_descs, length - 16);
> +	*legacy = out;
> +	return length;
> +}
> +

As this is an example which will be copy-paste by many users maybe you should you struct usb_functionfs_descs_head and struct usb_functionfs_descs_head_v2 instead of direct operations using hard-coded offsets to make this function more readable?

--
BR's
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com




