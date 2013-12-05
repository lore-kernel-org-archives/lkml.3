Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab3LESsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:48:51 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44853 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025Ab3LESst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:48:49 -0500
From: "Strashko, Grygorii" <grygorii.strashko@ti.com>
To: Tejun Heo <tj@kernel.org>
CC: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [PATCH v2 08/23] mm/memblock: Add memblock memory allocation
 apis
Thread-Topic: [PATCH v2 08/23] mm/memblock: Add memblock memory allocation
 apis
Thread-Index: AQHO789nHFbKKAfbc0Sh2+NWsZmHZppDDVGAgAKyLgCAAAUlgIAALcpR
Date: Thu, 5 Dec 2013 18:48:21 +0000
Message-ID: <902E09E6452B0E43903E4F2D568737AB097B26B2@DNCE04.ent.ti.com>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
 <1386037658-3161-9-git-send-email-santosh.shilimkar@ti.com>
 <20131203232445.GX8277@htj.dyndns.org>
 <52A0AB34.2030703@ti.com>,<20131205165325.GA24062@mtj.dyndns.org>
In-Reply-To: <20131205165325.GA24062@mtj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

>On Thu, Dec 05, 2013 at 06:35:00PM +0200, Grygorii Strashko wrote:
>> >> +#define memblock_virt_alloc_align(x, align) \
>> >> +  memblock_virt_alloc_try_nid(x, align, BOOTMEM_LOW_LIMIT, \
>> >> +                               BOOTMEM_ALLOC_ACCESSIBLE, MAX_NUMNODES)
>> >
>> > Also, do we really need this align variant separate when the caller
>> > can simply specify 0 for the default?
>>
>> Unfortunately Yes.
>> We need it to keep compatibility with bootmem/nobootmem
>> which don't handle 0 as default align value.
>
>Hmm... why wouldn't just interpreting 0 to SMP_CACHE_BYTES in the
>memblock_virt*() function work?
>

Problem is not with memblock_virt*(). The issue will happen in case if
memblock or nobootmem are disabled in below code (memblock_virt*() is disabled).

+/* Fall back to all the existing bootmem APIs */
+#define memblock_virt_alloc(x) \
+       __alloc_bootmem(x, SMP_CACHE_BYTES, BOOTMEM_LOW_LIMIT)

which will be transformed to 
+/* Fall back to all the existing bootmem APIs */
+#define memblock_virt_alloc(x, align) \
+       __alloc_bootmem(x, align, BOOTMEM_LOW_LIMIT)

and used as

memblock_virt_alloc(size, 0);

so, by default bootmem code will use 0 as default alignment and not SMP_CACHE_BYTES
and that is wrong.

Regards,
-grygorii