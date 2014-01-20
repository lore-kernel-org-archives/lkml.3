Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaATL46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:56:58 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55650 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaATL44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:56:56 -0500
Message-ID: <52DD0EFF.2010305@imgtec.com>
Date: Mon, 20 Jan 2014 11:56:47 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, <devel@driverdev.osuosl.org>,
        <andreas.dilger@intel.com>, Greg KH <gregkh@linuxfoundation.org>,
        <bergwolf@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <oleg.drokin@intel.com>, <jacques-charles.lafoucriere@cea.fr>,
        <jinshan.xiong@intel.com>, <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add "__attribute__((packed))"
 for the related union
References: <52DA4E6A.1000308@gmail.com> <20140118100547.GS7444@mwanda> <52DA56C2.5010802@gmail.com> <20140118142404.GT7444@mwanda> <52DBA3D4.3090308@gmail.com>
In-Reply-To: <52DBA3D4.3090308@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_01_20_11_56_51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On 19/01/14 10:07, Chen Gang wrote:
> BTW: this patch is related with another patch which is discussing (so I
> have cc that patch to you and Greg too): "if we could sure that it is a
> compiler's feature issue, we will skip this patch".

If you're referring to the #pragma pack portability issue then this
issue is unrelated since it doesn't use #pragma pack.

The issue is *not* that the compiler is defectively failing to pack
nested structs. Doing that would be utterly broken since it would change
the layout of the same struct depending on where it is placed in the
program, Consider this example (which uses a nested struct rather than
union to demonstrate the point):

struct a {
	struct b {
		unsigned int x;
		unsigned short y;
	} x;
	unsigned short y;
} __packed;

Both ABIs behave the same here:

Arch	sizeof(struct b)	sizeof(struct a)
x86_64	8			10
metag	8			10

If struct b is made __packed, again both ABIs behave differently in the
same way:

Arch	sizeof(struct b)	sizeof(struct a)
x86_64	6			8
metag	6			8

The issue is that C compiler ABIs may (and unfortunately metag ABI does)
pack structs and unions to at least 4 bytes, even if no members of the
struct or union are that large, which means that the nested struct/union
should be __packed too to portably ensure it's the expected size.

Cheers
James

