Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3BUTGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:06:23 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:64913 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3BUTGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:06:21 -0500
MIME-Version: 1.0
In-Reply-To: <51258D5D.2070404@oracle.com>
References: <CAMe9rOrE4okBffqCE0mAK_ogc76Ty12OvBJGy69kLebGGXmM=Q@mail.gmail.com>
	<51258D5D.2070404@oracle.com>
Date: Thu, 21 Feb 2013 11:06:21 -0800
Message-ID: <CAMe9rOpfd+xtyfvr21C771smTE7AXefxVJu73B7Xotf4EvYy+A@mail.gmail.com>
Subject: Re: [PATCH] DMI: Always call dmi_present with DMI structure
From: "H.J. Lu" <hjl.tools@gmail.com>
To: zhenzhong.duan@oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 6:58 PM, Zhenzhong Duan
<zhenzhong.duan@oracle.com> wrote:
> Hi
> Ben had sent a patch fixing this issue. Would you like to test his patch?
> https://lkml.org/lkml/2013/2/16/102
> zduan

The patch has a typo:

-		offset = 16;
+		return memcmp(q + 16, "_DMI_", 5) || dmi_present(p + 16);
 	}

'q' isn't defined here.  Change it to `p" also fixes the problem for me.


H.J.
---
> On 2013-02-21 02:12, H.J. Lu wrote:
>>
>> Hi,
>>
>> This patch:
>>
>> commit 9f9c9cbb60576a1518d0bf93fb8e499cffccf377
>> Author: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> Date:   Thu Dec 20 15:05:14 2012 -0800
>>
>>      drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it
>> exists
>>
>>      The right dmi version is in SMBIOS if it's zero in DMI region
>>
>>      This issue was originally found from an oracle bug.
>>      One customer noticed system UUID doesn't match between dmidecode &
>> uek2.
>>
>>       - HP ProLiant BL460c G6 :
>>         # cat /sys/devices/virtual/dmi/id/product_uuid
>>         00000000-0000-4C48-3031-4D5030333531
>>         # dmidecode | grep -i uuid    drivers/firmware/dmi_scan.c:
>> fetch dmi version from SMBIOS if it exists
>>
>>      The right dmi version is in SMBIOS if it's zero in DMI region
>>
>>      This issue was originally found from an oracle bug.
>>      One customer noticed system UUID doesn't match between dmidecode &
>> uek2.
>>
>>       - HP ProLiant BL460c G6 :
>>         # cat /sys/devices/virtual/dmi/id/product_uuid
>>         00000000-0000-4C48-3031-4D5030333531
>>         # dmidecode | grep -i uuid
>>         UUID: 00000000-0000-484C-3031-4D5030333531
>>
>>      From SMBIOS 2.6 on, spec use little-endian encoding for UUID other
>> than
>>      network byte order.
>>
>>      So we need to get dmi version to distinguish.  If version is 0.0, the
>>      real version is taken from the SMBIOS version.  This is part of
>> original
>>      kernel comment in code.
>>
>>         UUID: 00000000-0000-484C-3031-4D5030333531
>>
>>      From SMBIOS 2.6 on, spec use little-endian encoding for UUID other
>> than
>>      network byte order.
>>
>>      So we need to get dmi version to distinguish.  If version is 0.0, the
>>      real version is taken from the SMBIOS version.  This is part of
>> original
>>      kernel comment in code.
>>
>> causes a regression in 3.7, 3.8 and 3.9 kernels.   Before the change,
>> we only scan DMI structure.  Now smbios_present scans SMBIOS
>> entry point.  I have a machine which has invalid checksum in
>> SMBIOS entry point.  We wind up calling dmi_present with SMBIOS
>> entry point instead of DMI structure.  This patch changes smbios_present
>> to always call dmi_present with DMI structure.
>>
>>
>
