Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3BQCfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 21:35:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23852 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3BQCfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 21:35:21 -0500
MIME-Version: 1.0
Message-ID: <505e6314-555a-4bc6-96ef-dac735ae0bee@default>
Date: Sat, 16 Feb 2013 18:35:04 -0800 (PST)
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
To: <ben@decadent.org.uk>
Cc: <tmhikaru@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dmi_scan: Fix missing check for _DMI_ signature in
 smbios_present()
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- ben@decadent.org.uk wrote：

> Commit 9f9c9cbb6057 ('drivers/firmware/dmi_scan.c: fetch dmi version
> from SMBIOS if it exists') hoisted the check for "_DMI_" into
> dmi_scan_machine(), which means that we don't bother to check for
> "_DMI_" at offset 16 in an SMBIOS entry.  smbios_present() may also
> call dmi_present() for an address where we found "_SM_", if it failed
> further validation.
> 
> Check for "_DMI_" in smbios_present() before calling dmi_present().
> 
> Reported-by: Tim McGrath <tmhikaru@gmail.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable <stable@vger.kernel.org>
> ---
> This has a memcmp() that wasn't in the previous version, so I've not
> included the Acked-by or Tested-by for that.
Yes, the further "_DMI_" check is needed.
Acked-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> 
> Ben.
> 
>  drivers/firmware/dmi_scan.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/dmi_scan.c
> b/drivers/firmware/dmi_scan.c
> index 982f1f5..a86ccff 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -442,7 +442,6 @@ static int __init dmi_present(const char __iomem
> *p)
>  static int __init smbios_present(const char __iomem *p)
>  {
>  	u8 buf[32];
> -	int offset = 0;
>  
>  	memcpy_fromio(buf, p, 32);
>  	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
> @@ -461,9 +460,9 @@ static int __init smbios_present(const char
> __iomem *p)
>  			dmi_ver = 0x0206;
>  			break;
>  		}
> -		offset = 16;
> +		return memcmp(q + 16, "_DMI_", 5) || dmi_present(p + 16);
>  	}
> -	return dmi_present(buf + offset);
> +	return 1;
>  }
>  
>  void __init dmi_scan_machine(void)
