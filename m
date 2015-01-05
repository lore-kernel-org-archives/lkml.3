Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbbAESLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:11:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:29662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbbAESLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:11:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,701,1413270000"; 
   d="scan'208";a="632760606"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Yucong <slaoub@gmail.com>
CC: "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86, mce: use mce_usable_address() for UCNA memory
 error recovery
Thread-Topic: [PATCH] x86, mce: use mce_usable_address() for UCNA memory
 error recovery
Thread-Index: AQHQIyoB8zfGvsiUaEOgdUiVlczvJJyx3VXQ
Date: Mon, 5 Jan 2015 18:11:28 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3298FE25@ORSMSX114.amr.corp.intel.com>
References: <1419831623-14078-1-git-send-email-slaoub@gmail.com>
In-Reply-To: <1419831623-14078-1-git-send-email-slaoub@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The IA32_MCi_ADDR MSR contains the address of the code or data memory
> location that produced the machine-check error. The IA32_MCi_ADDR
> register is either not implemented or contains no address if the ADDRV
> flag in the IA32_MCi_STATUS register is clear. The address returned is
> an offset into a segment, linear address, physical address, or memory
> address. This depends on the error encountered.
>                                          -- Intel SDM Volume 3B

But SDM also says:

If both MISCV and IA32_MCG_CAP[24] are set, the IA32_MCi_MISC_MSR
is defined according to Figure 15-8 to support software recovery of
uncorrected errors (see Section 15.6):

So you should only look at the LSB/MODE bits in MCi_MISC on Intel processors
which have MCG_CAP[24] == 1 (handily saved in "mca_cfg.ser" in mce.c).

This was buried in the old code because the only caller of mce_usable_address() was:

	if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))

and we can only have AO_SEVERITY set on systems with MCG_CAP[24]==1.

-Tony
