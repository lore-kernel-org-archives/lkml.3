Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3BPPzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 10:55:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29535 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3BPPzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 10:55:53 -0500
MIME-Version: 1.0
Message-ID: <32913552-e848-4416-a747-5fa47e1a93de@default>
Date: Sat, 16 Feb 2013 07:55:36 -0800 (PST)
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
To: <ben@decadent.org.uk>
Cc: <tmhikaru@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Re: 3.2.38 most of the time has 100% cpu use reported
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, Feb 16, 2013 at 05:18:10AM +0000, Ben Hutchings wrote：
> On Fri, 2013-02-15 at 22:23 -0500, tmhikaru@gmail.com wrote:
> > On Thu, Feb 14, 2013 at 05:04:07AM +0000, Ben Hutchings wrote:
> > > On Tue, 2013-02-12 at 00:01 -0500, tmhikaru@gmail.com wrote:
> > > > 	Okay, I finally have located the patch causing this bizzare
> problem
> > > > for me. Before I discuss it, I'm going to drag out the kernel
> bug reporting
> > > > guidelines and try to make a proper bug report out of this.
> > > > 
> > > > [1.] One line summary of the problem:
> > > > 3.2.38 most of the time has 100% cpu use reported
> > > > 
> > > > [2.] Full description of the problem/report:
> > > > Reverse applying the patch for
> > > > 
> > > > [9a1f08a1a192f9177d7063d903773aed800b840f]
> drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it
> exists
> > > > 
> > > > on top of a clean 3.2.38 tree makes the problem go away.
> > > [...]
> > > > I have to admit I have no idea what the patch I'm reversing
> actually does,
> > > 
> > > It changes how we look for the version of a BIOS interface (DMI
> or
> > > SMBIOS).  All the code that it touches, and the version number
> variable,
> > > are discarded after boot and therefore can have very limited
> effect on
> > > what happens later!
> > 
> > Actually upon poking about, I noticed something VERY different about
> what
> > the patch does to my computer during the boot process.  Let me show
> you
> > dmesg output from a good kernel without the patch, then a bad one
> with the
> > patch, then I'll point out the important differences I noticed:
> [...]
> > Important bits I noticed: The 'bad' kernel initially boots with
> acpi
> > disabled, then later turns it back on, whereas the 'good' one boots
> with
> > acpi completely enabled with no problems.
> >
> > Also, very early on just after yelling about the NX bit not existing
> in my
> > cpu, it says this: (-good/+bad)
> > 
> > -[    0.000000] DMI 2.3 present.
> > -[    0.000000] DMI: ECS M848A/M848A, BIOS 07.00T 04/02/01
> > +[    0.000000] Legacy DMI 0.0 present.
> > +[    0.000000] DMI:  , BIOS  
> 
> Oh wow, this has really gone very wrong.
> 
> > The 'good' kernel without the patch finds something for DMI (That is
> in fact
> > my motherboard model number, so I know it's doing *something* right)
> whereas
> > the bad one with the patch...  Does not.
> >
> > Anyway, I suppose I could try using acpi=force as the kernel
> suggests for a
> > workaround for now, but I'm still convinced something went wrong
> with that
> > patch now more than ever.  Due to the fact that ACPI gets reenabled
> I didn't
> > catch on that something was going wrong so early in the boot process
> with it
> > until now.
> >
> > One thing I want to emphasize is that the only difference between
> the two
> > kernels is that lone patch.
> >
> > As for perf top, I tried running it as you suggested, but I honestly
> can't
> > figure out how to get this thing to dump output to a file. Every
> time I
> > redirect stdio/stderr I get a empty file, I don't know what I'm
> doing wrong.
> > Any tips?
> [...]
> 
> Don't worry about it - I think the log messages are a pretty good
> clue.
> 
> Does this patch fix the log messages and/or the other issues?
> 
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -416,6 +416,9 @@ static int __init dmi_present(const char __iomem
> *p)
>  
>  	memcpy_fromio(buf, p, 15);
>  	if (dmi_checksum(buf, 15)) {
> +		print_hex_dump(KERN_INFO, "DMI entry: ", DUMP_PREFIX_NONE,
> +			       16, 1, buf, 15, false);
> +
>  		dmi_num = (buf[13] << 8) | buf[12];
>  		dmi_len = (buf[7] << 8) | buf[6];
>  		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
> @@ -442,10 +445,12 @@ static int __init dmi_present(const char __iomem
> *p)
>  static int __init smbios_present(const char __iomem *p)
>  {
>  	u8 buf[32];
> -	int offset = 0;
>  
>  	memcpy_fromio(buf, p, 32);
>  	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
> +		print_hex_dump(KERN_INFO, "SMBIOS entry: ", DUMP_PREFIX_NONE,
> +			       16, 1, buf, 16, false);
> +
>  		dmi_ver = (buf[6] << 8) + buf[7];
>  
>  		/* Some BIOS report weird SMBIOS version, fix that up */
> @@ -461,9 +466,9 @@ static int __init smbios_present(const char
> __iomem *p)
>  			dmi_ver = 0x0206;
>  			break;
>  		}
> -		offset = 16;
> +		return dmi_present(p + 16);
>  	}
> -	return dmi_present(buf + offset);
> +	return 1;
>  }
>  
>  void __init dmi_scan_machine(void)
> --- END ---
Thanks Ben fix it.
Acked-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
