Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaLQGyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 01:54:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:46278 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbaLQGyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 01:54:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,592,1413270000"; 
   d="scan'208";a="638844909"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Chris Rorvick <chris@rorvick.com>, "Drokin, Oleg" <oleg.drokin@intel.com>
CC: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "Hammond, John" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "HPDD-discuss@lists.01.org" <HPDD-discuss@ml01.01.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] drivers: staging: lustre: Track sign separately
Thread-Topic: [PATCH v2 2/2] drivers: staging: lustre: Track sign separately
Thread-Index: AQHQGbF4PBVUumjKwk2gmAPsw3ZGK5yTafeA
Date: Wed, 17 Dec 2014 06:54:06 +0000
Message-ID: <D0B67685.D0A5B%andreas.dilger@intel.com>
References: <1418790242-14309-1-git-send-email-chris@rorvick.com>
 <1418790242-14309-3-git-send-email-chris@rorvick.com>
In-Reply-To: <1418790242-14309-3-git-send-email-chris@rorvick.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.108.8]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <038B0399EA6AB94A9EEB856008D98744@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/16, 9:24 PM, "Chris Rorvick" <chris@rorvick.com> wrote:

>The `mult' parameter is negated if the user data begins with a '-' so
>that the final value has the appropriate sign.  But `mult' is only used
>if the user data does not include a "units" suffix.  In this case,
>`mult' is overridden with the numeric scale conveyed by the units suffix,
>but retains the sign of the original value.
>
>Having `mult' serving double-duty works but is confusing.  Use a new
>local variable to store the sign of the user data instead.  This also
>fixes a pitfall of passing 0 to `mult', expecting it to be ignored when
>a units suffix is specified, but having the effect of taking the
>absolute value of the user-provided data.
>
>Signed-off-by: Chris Rorvick <chris@rorvick.com>

Both patches look good to me.
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>

>---
> drivers/staging/lustre/lustre/obdclass/lprocfs_status.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
>b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
>index 92ed0a0..b6c3352 100644
>--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
>+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
>@@ -1864,6 +1864,7 @@ int lprocfs_write_frac_u64_helper(const char
>*buffer, unsigned long count,
> 	char kernbuf[22], *end, *pbuf;
> 	__u64 whole, frac = 0, units;
> 	unsigned frac_d = 1;
>+	int sign = 1;
> 
> 	if (count > (sizeof(kernbuf) - 1))
> 		return -EINVAL;
>@@ -1874,7 +1875,7 @@ int lprocfs_write_frac_u64_helper(const char
>*buffer, unsigned long count,
> 	kernbuf[count] = '\0';
> 	pbuf = kernbuf;
> 	if (*pbuf == '-') {
>-		mult = -mult;
>+		sign = -1;
> 		pbuf++;
> 	}
> 
>@@ -1911,11 +1912,11 @@ int lprocfs_write_frac_u64_helper(const char
>*buffer, unsigned long count,
> 	}
> 	/* Specified units override the multiplier */
> 	if (units > 1)
>-		mult = mult < 0 ? -units : units;
>+		mult = units;
> 
> 	frac *= mult;
> 	do_div(frac, frac_d);
>-	*val = whole * mult + frac;
>+	*val = sign * (whole * mult + frac);
> 	return 0;
> }
> EXPORT_SYMBOL(lprocfs_write_frac_u64_helper);
>-- 
>2.1.0
>
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


