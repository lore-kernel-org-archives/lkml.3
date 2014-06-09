Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbaFIOCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:02:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45019 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaFIOCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:02:11 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-42-5395be600bd9
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: "'Michal Nazarewicz'" <mina86@mina86.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1402045976-26580-1-git-send-email-mina86@mina86.com>
 <1402045976-26580-5-git-send-email-mina86@mina86.com>
 <006601cf83bc$66197b30$324c7190$%opasiak@samsung.com>
 <xa1tmwdmdxgh.fsf@mina86.com>
In-reply-to: <xa1tmwdmdxgh.fsf@mina86.com>
Subject: RE: [PATCHv2 5/5] tools: ffs-test: add compatibility code for old
 kernels
Date: Mon, 09 Jun 2014 16:02:17 +0200
Message-id: <007601cf83eb$6cf9b0d0$46ed1270$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+D5qYiWrKGKWklQ3Wv/6Yk5l7B7AAA9d0Q
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7qJ+6YGG7xxtjh4v97i9sRpbBaX
	d81hs1i0rJXZYsHxFlYHVo91f14xefRtWcXocfzGdiaPz5vkAliiuGxSUnMyy1KL9O0SuDJe
	757IWHBAqmLBjXvMDYztol2MnBwSAiYSG190sEPYYhIX7q1n62Lk4hASWMooMXnKenYIp4FJ
	4v2EjyxdjBwcbAL6EvN2iYLERQSWMEr8an7PChJnFrCW+LkvH6L+IqPEqX+3mEHinAJaEpee
	y4EsEBYIkXi58DTYMhYBVYmdr/rZQGxeAUeJFcfXQ9mCEj8m32MBsZkF1CUmzVvEDGFrSzx5
	dwFslQRQ/NFfXZCwiICRxOvvjWwQJeISkx48ZJ/AKDQLyaRZSCbNQjJpFpKWBYwsqxhFU0uT
	C4qT0nMN9YoTc4tL89L1kvNzNzFCIuHLDsbFx6wOMQpwMCrx8GZwTg0WYk0sK67MPcQowcGs
	JMI7eQdQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2Pg7s+mp9T6bvi4/Yw2vVqXERDiX19sHf4/
	To+vburl6XzFhU0fUiMeCXNfDD14LutW+qpFObZPnNk+vr36es1Du5nnbxbOLj747szq5pZ0
	U4PQe29Sr7y/KqphyPPfxWCzL5vJQeXvV059m+jsPd/U6pvaK/V7D4TuxFhEZBjJGa1dG+Hw
	PU+JpTgj0VCLuag4EQAB22QhYgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Michal Nazarewicz [mailto:mpn@google.com] On Behalf Of Michal
> Nazarewicz
> Sent: Monday, June 09, 2014 3:28 PM
> To: Krzysztof Opasiak; 'Felipe Balbi'; Krzysztof Opasiak
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv2 5/5] tools: ffs-test: add compatibility code
> for old kernels
> 
> On Mon, Jun 09 2014, Krzysztof Opasiak wrote:
> > As this is an example which will be copy-paste by many users
> maybe you
> > should you struct usb_functionfs_descs_head and struct
> > usb_functionfs_descs_head_v2 instead of direct operations using
> > hard-coded offsets to make this function more readable?
> 
> v3 uses usb_functionfs_descs_head{_v2,} instead of hard-coded
> offsets.
> I also started wondering if it would make sense to go one step
> further
> and define a temporary structure holding the headers.  Something
> like:
> 
> ----------- >8 ----------------------------------------------------
> -----
> 	/* Read v2 header */
> 	{
> 		const struct {
> 			const struct usb_functionfs_descs_head_v2 header;
> 			const __le32 counts[];
> 		} __attribute__((packed)) *const in = descriptors;
> 		const __le32 *counts = in->counts;
> 		__u32 flags;
> 
> 		if (le32_to_cpu(in->header.magic) !=
> 		    FUNCTIONFS_DESCRIPTORS_MAGIC_V2)
> 			return 0;
> 		length = le32_to_cpu(in->header.length);
> 		if (length <= sizeof in->header)
> 			return 0;
> 		length -= sizeof in->header;
> 		flags = le32_to_cpu(in->header.flags);
> 		if (flags & ~(FUNCTIONFS_HAS_FS_DESC |
> FUNCTIONFS_HAS_HS_DESC |
> 			      FUNCTIONFS_HAS_SS_DESC))
> 			return 0;
> 
> #define GET_NEXT_COUNT_IF_FLAG(ret, flg) do {		\
> 			if (!(flags & (flg)))		\
> 				break;			\
> 			if (length < 4)			\
> 				return 0;		\
> 			ret = le32_to_cpu(*counts);	\
> 			length -= 4;			\
> 			++counts;			\
> 		} while (0)
> 
> 		GET_NEXT_COUNT_IF_FLAG(fs_count,
> FUNCTIONFS_HAS_FS_DESC);
> 		GET_NEXT_COUNT_IF_FLAG(hs_count,
> FUNCTIONFS_HAS_HS_DESC);
> 		GET_NEXT_COUNT_IF_FLAG(count, FUNCTIONFS_HAS_SS_DESC);
> 
> 		count = fs_count + hs_count;
> 		if (!count)
> 			return 0;
> 		descs_start = descs_end = (const void *)counts;
> 
> #undef GET_NEXT_COUNT_IF_FLAG
> 	}
> 
> ----------- >8 ----------------------------------------------------
> -----
> 
> 	/* Allocate legacy descriptors and copy the data. */
> 	{
> 		struct {
> 			struct usb_functionfs_descs_head header;
> 			__u8 descriptors[];
> 		} __attribute__((packed)) *out;
> 
> 		length = sizeof out->header + (descs_end -
> descs_start);
> 		out = malloc(length);
> 		out->header.magic =
> cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC);
> 		out->header.length = cpu_to_le32(length);
> 		out->header.fs_count = cpu_to_le32(fs_count);
> 		out->header.hs_count = cpu_to_le32(hs_count);
> 		memcpy(out->descriptors, descs_start, descs_end -
> descs_start);
> 		*legacy = out;
> 	}
> ----------- >8 ----------------------------------------------------
> -----
> 
> Thoughts?

Looks very good to me! In my opinion this one should be used, it emphasizes your intentions very well so it's perfect code for sample app.

--
BR's
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com





