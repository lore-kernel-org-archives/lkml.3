Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3GHNy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:54:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab3GHNyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:54:55 -0400
Subject: Re: memcpy_fromio in dmi_scan.c
From: Jean Delvare <jdelvare@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        DuanZhenzhong <zhenzhong.duan@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
In-Reply-To: <20130425133701.04d31844cb594030a0431171@linux-foundation.org>
References: <1366636689.4503.35.camel@chaos.site>
	 <5175FF0F.9050206@oracle.com> <1366702122.4667.11.camel@chaos.site>
	 <3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com>
	 <1366831328.4618.476.camel@chaos.site>
	 <3908561D78D1C84285E8C5FCA982C28F1EA53DAA@ORSMSX104.amr.corp.intel.com>
	 <20130425020724.GR3658@sgi.com> <20130425095242.GT3658@sgi.com>
	 <20130425133701.04d31844cb594030a0431171@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 08 Jul 2013 15:54:38 +0200
Message-ID: <1373291678.4298.211.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Sorry for the late reply.

Le Thursday 25 April 2013 à 13:37 -0700, Andrew Morton a écrit :
> So what's the fix?  This?
> 
> --- a/drivers/firmware/dmi_scan.c~a
> +++ a/drivers/firmware/dmi_scan.c
> @@ -500,9 +500,12 @@ void __init dmi_scan_machine(void)
>  			goto error;
>  
>  		for (q = p; q < p + 0x10000; q += 16) {
> -			if (memcmp(q, "_SM_", 4) == 0 && q - p <= 0xFFE0)
> +			char buf[5];
> +
> +			memcpy_from_io(buf, q, 5);
> +			if (memcmp(buf, "_SM_", 4) == 0 && q - p <= 0xFFE0)
>  				rc = smbios_present(q);
> -			else if (memcmp(q, "_DMI_", 5) == 0)
> +			else if (memcmp(buf, "_DMI_", 5) == 0)
>  				rc = dmi_present(q);
>  			else
>  				continue;

That would have been it, yes, but meanwhile Ben Hutchings reworked the
whole thing and that fixed the problem I reported as a side effect:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/firmware/dmi_scan.c?id=79bae42d51a5d498500c890c19ef76df41d2bf59

I'd suggest leaving the stable kernels alone until someone complains, as
there doesn't seem to be any issue in practice (the only machines where
it would possibly matter are already hopelessly broken.)

All I can say is that these dmi_scan patches should never have made it
to stable kernels in the first place, as they infringed several rules
stable patches are supposed to comply with.

-- 
Jean Delvare
Suse L3

