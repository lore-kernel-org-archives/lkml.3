Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaFELZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:25:04 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12363 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFELZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:25:01 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-80-5390538a1bb3
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: "'Michal Nazarewicz'" <mina86@mina86.com>, "'Felipe Balbi'" <balbi@ti.com>
Cc: Krzysztof Opasiak <k.opasiak@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1401954206-8491-1-git-send-email-mina86@mina86.com>
 <1401954206-8491-2-git-send-email-mina86@mina86.com>
In-reply-to: <1401954206-8491-2-git-send-email-mina86@mina86.com>
Subject: RE: [PATCH 2/2] tools: ffs-test: convert to new descriptor format
 fixing compilation error
Date: Thu, 05 Jun 2014 13:25:01 +0200
Message-id: <008101cf80b0$caf88dc0$60e9a940$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+AkeGQNjmGw0WaTO6XyMCvFODpVgAHKllg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xq7pdwROCDe5+NbU4eL/e4vbEaWwW
	l3fNYbNYtKyV2WLB8RZWB1aPdX9eMXn0bVnF6HH8xnYmj8+b5AJYorhsUlJzMstSi/TtErgy
	vn+8zliwTbDi2oENrA2M0/m6GDk4JARMJPb8Le1i5AQyxSQu3FvP1sXIxSEksJRR4v2Mz8wQ
	TgOTxKErK1hAGtgE9CXm7RIFaRAR8JK4v2kBI4jNLJAhMfnZQiYQW0igXOLpokPMIDangKPE
	3n2/WEBsYYFUiXeLz7KDjGERUJU4dr8EJMwLVHL153cWCFtQ4sfkeywQI9UlJs1bxAxha0s8
	eXeBFeJkdYlHf3UhLjCS+Nm/lB2iRFxi0oOH7BMYhWYhmTQLyaRZSCbNQtKygJFlFaNoamly
	QXFSeq6hXnFibnFpXrpecn7uJkZIHHzZwbj4mNUhRgEORiUeXofX/cFCrIllxZW5hxglOJiV
	RHjtHCYEC/GmJFZWpRblxxeV5qQWH2Jk4uCUamAsj3CoPDO3jl1HY+nP0ok+BqwhVxdluKdo
	WWm+lpvDnVx1qce0feX5E16Jx+aU/3jS9Or9fnWf6eVfn4ffzuG41M90sOOQRFOO8M6ybxuP
	Psn4pSSbuaBWqHdDF4P5cdusIl+H/UcMopK7n1i+ONR78Yzjxju/89+qr7Hml9sl/OBFR9mi
	G5ZKLMUZiYZazEXFiQBvXWK8YQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Michal Nazarewicz [mailto:mina86@mina86.com]
> Sent: Thursday, June 05, 2014 9:43 AM
> To: Felipe Balbi
> Cc: Krzysztof Opasiak; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; Michal Nazarewicz
> Subject: [PATCH 2/2] tools: ffs-test: convert to new descriptor
> format fixing compilation error
> 
> Commit [ac8dde11: “usb: gadget: f_fs: Add flags to descriptors
> block”]
> which introduced a new descriptor format for FunctionFS removed the
> usb_functionfs_descs_head structure, which is still used by ffs-
> test.
> tool.
> 
> Convert ffs-test by converting it to use the new header format.
> For
> testing kernels prior to 3.14 (when the new format was introduced)
> and
> parsing of the legacy headers in the new kernels, provide a
> compilation
> flag to make the tool use the old format.
> 
> Finally, include information as to when the legacy FunctionFS
> headers
> format has been deprecated (which is also when the new one has been
> introduced).
> 
> Reported-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Reported-by: Krzysztof Opasiak <k.opasiak@samsung.com>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

(...)

> 
>  static const struct {
> -	struct usb_functionfs_descs_head header;
> +	struct {
> +		__le32 magic;
> +		__le32 length;
> +#ifndef USE_LEGACY_DESC_HEAD
> +		__le32 flags;
> +#endif
> +		__le32 fs_count;
> +		__le32 hs_count;
> +	} __attribute__((packed)) header;

I would suggest adding a suitable structure as you described in previous discussion[1]. Writing first 3 fields in each userspace program doesn't look quite good. Using:

#ifndef USE_LEGACY_DESC_HEAD
struct {
	struct usb_functionfs_desc_head2 header;
	__le32 fs_count
	(... and rest according to flags ...)
} __attribute__((packed)) header;
#else ...

Would be shorter, more flexible and user friendly. Moreover it gives less places for mistake (writing fields in wrong order).

Footnotes:
1 - http://marc.info/?l=linux-usb&m=140190878901586&w=2


--
BR's
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com





