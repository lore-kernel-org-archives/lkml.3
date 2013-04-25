Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab3DYUhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:37:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3DYUhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:37:02 -0400
Date: Thu, 25 Apr 2013 13:37:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jean Delvare <jdelvare@suse.de>,
        DuanZhenzhong <zhenzhong.duan@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: memcpy_fromio in dmi_scan.c
Message-Id: <20130425133701.04d31844cb594030a0431171@linux-foundation.org>
In-Reply-To: <20130425095242.GT3658@sgi.com>
References: <1366636689.4503.35.camel@chaos.site>
	<5175FF0F.9050206@oracle.com>
	<1366702122.4667.11.camel@chaos.site>
	<3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com>
	<1366831328.4618.476.camel@chaos.site>
	<3908561D78D1C84285E8C5FCA982C28F1EA53DAA@ORSMSX104.amr.corp.intel.com>
	<20130425020724.GR3658@sgi.com>
	<20130425095242.GT3658@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013 04:52:42 -0500 Robin Holt <holt@sgi.com> wrote:

> On Wed, Apr 24, 2013 at 09:07:24PM -0500, Robin Holt wrote:
> > On Wed, Apr 24, 2013 at 08:16:50PM +0000, Luck, Tony wrote:
> > > > That being said, "my" SN2 machine was previously running kernel 3.0.34
> > > > which has the old dmi_scan code and it also said "DMI not present or
> > > > invalid." Plus dmidecode fails on this machine with:
> > > >
> > > > /sys/firmware/efi/systab: SMBIOS entry point missing
> > > >
> > > > So it might as well be that DMI support on SN2 was already broken.
> > > > Please let me know your findings on other SN2 machines.
> > > 
> > > I don't have an sn2 to test. Added Robin Holt to Cc list
> > 
> > I will try and boot an sn2 machine first thing tomorrow morning.
> > I don't recall dmidecode being broken, but that was quite a while ago.
> > I thought the license validation code we used on sn2 used data from the
> > dmidecode output.
> 
>  # uname -r
> 3.0.13-0.27-default
>  # dmidecode
> # dmidecode 2.9
> /sys/firmware/efi/systab: SMBIOS entry point missing
> 
> 
> It looks like it is broken there as well.  This is running a SLES11SP2
> kernel with no local changes.
> 
> dmesg show:
> DMI not present or invalid.
> 

So what's the fix?  This?

--- a/drivers/firmware/dmi_scan.c~a
+++ a/drivers/firmware/dmi_scan.c
@@ -500,9 +500,12 @@ void __init dmi_scan_machine(void)
 			goto error;
 
 		for (q = p; q < p + 0x10000; q += 16) {
-			if (memcmp(q, "_SM_", 4) == 0 && q - p <= 0xFFE0)
+			char buf[5];
+
+			memcpy_from_io(buf, q, 5);
+			if (memcmp(buf, "_SM_", 4) == 0 && q - p <= 0xFFE0)
 				rc = smbios_present(q);
-			else if (memcmp(q, "_DMI_", 5) == 0)
+			else if (memcmp(buf, "_DMI_", 5) == 0)
 				rc = dmi_present(q);
 			else
 				continue;
_

