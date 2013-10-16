Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760985Ab3JPXhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:37:12 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:49733 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab3JPXhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:37:10 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt@console-pimps.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: RE: [PATCH 2/5] efi: Introduce a Runtime Services lock
Thread-Topic: [PATCH 2/5] efi: Introduce a Runtime Services lock
Thread-Index: AQHOynbHY2VNq83FuUG2svgzWrUV2Jn3+XQA
Date: Wed, 16 Oct 2013 23:36:54 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EF85DC@USINDEM103.corp.hds.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-3-git-send-email-matt@console-pimps.org>
In-Reply-To: <1381931460-6999-3-git-send-email-matt@console-pimps.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-16_07:2013-10-17,2013-10-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310160113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define efi_call_reset_virt(f, args...)					\
> +({									\
> +	unsigned long __flags;						\
> +	bool __nmi = in_nmi();						\
> +									\
> +	if (__nmi)							\
> +		spin_lock_irqsave(&efi_runtime_lock, __flags);		\

If the lock is not held in the nmi context, runtime service may run concurrently
in non-nmi context as follows.
 - In nmi context, cpu0 calls a runtime service (no lock is held.)
 - In non-nmi context, cpu1 call can take the lock and call the runtime service.

To avoid this, using try_lock in nmi context is better..

If(in_nmi())
	try_spin_lock_irqsave();
else
	spin_lock_irqsave();

Please see the commit abd4d5587be911f63592537284dad78766d97d62,
which is introduced to pstore by Don Zickus.

Seiji



