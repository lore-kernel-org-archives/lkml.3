Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaA1RMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:12:30 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46667 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1RM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:12:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
	<1390590670-25901-4-git-send-email-yinghai@kernel.org>
	<CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com>
	<CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com>
Date: Tue, 28 Jan 2014 09:12:27 -0800
X-Google-Sender-Auth: oPlXRK8rm4HiLKBDB0W1-RYc_oM
Message-ID: <CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
From: Yinghai Lu <yinghai@kernel.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: multipart/mixed; boundary=bcaec5101cbbc1db7b04f10aeddc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec5101cbbc1db7b04f10aeddc
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 28, 2014 at 7:30 AM, Kevin Hilman <khilman@linaro.org> wrote:
> On Tue, Jan 28, 2014 at 12:02 AM, Olof Johansson <olof@lixom.net> wrote:
>> Hi,
>>
>> On Fri, Jan 24, 2014 at 11:11 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> The new memblock_virt APIs are used to replaced old bootmem API.
>>>
>>> We need to allocate page below 4G for swiotlb.
>>>
>>> That should fix regression on Andrew's system that is using swiotlb.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>
>> This seems to have been merged by Linus tonight as ad6492b80f, and it
>> had fallout on ARM systems (boot failures with no console output on
>> all but 5 of my machine/config combos).
>>
>> Seems like it didn't have a chance to sit in -next, which is somewhat
>> understandable given that it's considered a bugfix and it indeed fixed
>> the bug it was meant to.
>>
>> i'm out of time to debug this tonight (I noticed the failures as I was
>> heading to bed and figured I'd at least bisect them), so I wouldn't
>> mind seeing a revert of the ARM side change of ad6492b80f until it's
>> been sorted out so we keep bisectabilty intact for the rest of the
>> kernel.
>
> Like Olof, I noticed multiple boot failures on various ARM boards.
> I've confirmed that reverting the arch/arm part of this patch makes
> them all happily booting again.

please try attached patch.

Index: linux-2.6/include/linux/bootmem.h
===================================================================
--- linux-2.6.orig/include/linux/bootmem.h
+++ linux-2.6/include/linux/bootmem.h
@@ -179,6 +179,9 @@ static inline void * __init memblock_vir
                                                    NUMA_NO_NODE);
 }

+/* Take arch's ARCH_LOW_ADDRESS_LIMIT at first*/
+#include <asm/processor.h>
+
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT  0xffffffffUL
 #endif

--bcaec5101cbbc1db7b04f10aeddc
Content-Type: text/x-patch; charset=US-ASCII; name="fix_arm_low.patch"
Content-Disposition: attachment; filename="fix_arm_low.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqzf7orh0

LS0tCiBpbmNsdWRlL2xpbnV4L2Jvb3RtZW0uaCB8ICAgIDMgKysrCiAxIGZpbGUgY2hhbmdlZCwg
MyBpbnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42L2luY2x1ZGUvbGludXgvYm9vdG1lbS5o
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2luY2x1ZGUvbGludXgvYm9vdG1lbS5oCisr
KyBsaW51eC0yLjYvaW5jbHVkZS9saW51eC9ib290bWVtLmgKQEAgLTE3OSw2ICsxNzksOSBAQCBz
dGF0aWMgaW5saW5lIHZvaWQgKiBfX2luaXQgbWVtYmxvY2tfdmlyCiAJCQkJCQkgICAgTlVNQV9O
T19OT0RFKTsKIH0KIAorLyogVGFrZSBhcmNoJ3MgQVJDSF9MT1dfQUREUkVTU19MSU1JVCBhdCBm
aXJzdCovCisjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5oPgorCiAjaWZuZGVmIEFSQ0hfTE9XX0FE
RFJFU1NfTElNSVQKICNkZWZpbmUgQVJDSF9MT1dfQUREUkVTU19MSU1JVCAgMHhmZmZmZmZmZlVM
CiAjZW5kaWYK
--bcaec5101cbbc1db7b04f10aeddc--
