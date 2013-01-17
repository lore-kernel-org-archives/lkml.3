Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3AQVgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:36:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40743 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab3AQVgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:36:07 -0500
Date: Thu, 17 Jan 2013 22:36:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: dAgeCKo <dagecko@free.fr>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Shane Huang <Shane.Huang@amd.com>,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: Fwd: Linux - AMD SB950 USB Regression
Message-ID: <20130117213602.GA5998@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, dAgeCKo <dagecko@free.fr>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	Shane Huang <Shane.Huang@amd.com>,
	=?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
References: <50C9FCD6.6050809@free.fr>
 <50E6AD77.1000707@free.fr>
 <50F036CF.7010109@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50F036CF.7010109@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(leaving in the rest for reference, answer below, adding Alan, Joerg,
Shane and linux-usb to CC).

On Fri, Jan 11, 2013 at 04:59:11PM +0100, dAgeCKo wrote:
> the bug has been resolved after a BIOS upgrade. Since the mainboard
> constructor said me that it's impossible that the BIOS was an issue
> since their Windows users do not face the same issue, I beleived it
> could have come from the Linux kernel.
> 
> Bye.
> 
> Le 04/01/2013 11:22, dAgeCKo a écrit :
> >
> >Hello,
> >
> >Some months ago I noticed that my USB controler (and also my network
> >controler) does not work anymore on newer kernels from my debian wheezy
> >distribution.
> >
> >I then reported a bug for the former one here:
> >
> >https://bugzilla.kernel.org/show_bug.cgi?id=47791
> >
> >With some helps and time, I could locate the source of the regression,
> >that is an old commit from the year 2010 you seem to commit. Git
> >besection identified the commit as:
> >
> >git bisect bad 5c80cc78de46aef6cd5e714208da05c3f7f548f8
> >
> >Someone from the usb kernel mailing list (Alan Stern) then asked me to
> >write an email to you, in my hope the bug to be solved.
> >
> >Some informations were said on the bug tracker, but if you need any
> >other information that could help you in any manner, please let me know.
> >
> >Please note that the regression only involves USB2 ports of the
> >mainboard, not the USB3 ports.

So, there seems to be some serious breakage with GART on SB9xx. I don't
know whether this is the platform BIOS or the vendor BIOS causing it
because the original bug reporter says he observes the issue on an MSI
board and I'm experiencing this on my favourite bunch ASUS.

So, if you use the GART as an IOMMU, i.e.:

Jan 17 22:08:15 pd kernel: [    0.924063] PCI-DMA: using GART IOMMU.
Jan 17 22:08:15 pd kernel: [    0.924120] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture

USB ports start choking like this:

Jan 17 22:08:15 pd kernel: [    3.229909] usb 4-1: device descriptor read/64, error -32
Jan 17 22:08:15 pd kernel: [    3.432786] usb 4-1: new high-speed USB device number 3 using ehci-pci
Jan 17 22:08:15 pd kernel: [    3.534684] usb 4-1: device descriptor read/64, error -32
Jan 17 22:08:15 pd kernel: [    3.737642] usb 4-1: device descriptor read/64, error -32

I'd go and venture a guess here since I don't have an idea that DMA
somehow gets busted with the GART and thus the errors.

Now, those boards normally have an IOMMU too so if you go and enable

CONFIG_AMD_IOMMU=y

the problem is gone (we're using the real IOMMU for DMA mapping, etc,
etc). So dAgeCKo, that would be another thing you could do: try enabling
the IOMMU in the BIOS and the above CONFIG option and the issue would be
fixed too.

At least this fixes it on my box.

To the question "how do we fix the GART issue?" I have no answer and
would expect more informed opinions from someone else.

Thanks and HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
