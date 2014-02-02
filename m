Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaBBSNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 13:13:49 -0500
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.180]:51947 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaBBSNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 13:13:47 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2014 13:13:46 EST
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTyvnOJ7o=
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Dave Jones <davej@redhat.com>
Subject: Re: rtl8821ae.
Date: Sun, 2 Feb 2014 18:07:34 +0000
User-Agent: KMail/1.13.7 (Linux/3.13-1.slh.1-aptosid-686; KDE/4.8.4; i686; ; )
Cc: gregkh@linuxfoundation.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        Andrea Merello <andrea.merello@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linux Driver Project <devel@linuxdriverproject.org>
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail> <20140202160512.GA4946@redhat.com>
In-Reply-To: <20140202160512.GA4946@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402021807.37772.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

[ CC'ing the relevant parties ]

On Sunday 02 February 2014, Dave Jones wrote:
> On Sun, Feb 02, 2014 at 03:41:27AM -0800, scan-admin@coverity.com wrote:
>  > 
>  > Please find the latest report on new defect(s) introduced to Linux found with Coverity Scan.
>  > 
>  > Defect(s) Reported-by: Coverity Scan
>  > Showing 20 of 83 defect(s)
> 
> Ugh, this is even worse than the usual realtek drivers. (With the exception of rtl8188eu)
> All 83 of those new defects came from this new driver, and while there's
> a bunch of "who cares" type things in there, there's a load of stuff that
> needs fixing a lot more urgently than CodingStyle issues or anything else in the TODO
> for that driver.
> 
> A bigger problem though, is what is the plan for these realtek drivers ?
> They've been in staging forever. rtl8187se has been there for _five_ years with
> no indication it's ever getting promoted to first class status.

Actually rtl8187se (aka rtl8185b) seems to have gotten some attention 
recently:

http://lkml.kernel.org/r/CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com

> The git logs are littered mostly with CodingStyle cleanups, sparse cleanups and such,
> meanwhile for five years they've had out of bounds reads, overflows, and such 
> for this whole time.  Even worse, when one of the drivers gets fixes for actual
> problems like this, they never make it back to Realtek, who clone the same
> old shitty driver they shipped last time, and reintroduce new variants of the
> same damn bugs, and then we import the new turd into staging and start all over again.
> 
> I get the whole "a shit driver is better than no driver", but there's no discernable
> effort to ever improve this pile, just to keep adding to it.
> 
> 	Dave

I think there are mostly two major problems with these drivers, besides 
RealTek still working on a non-mac80211 codebase for USB based devices.

The sheer number of slightly different RealTek drivers for similar
chipsets, for which RealTek as forked off a dedicated driver each, 
rather than extending the existing ones. With the other, probably even 
larger, problem being that it isn't possible to port wireless drivers
from non-mac80111 to mac80211 in a gradual fashion, it's always a 
parallel re-implementation. Just look at the recent history of staging
wireless drivers:

the successful ones:
- csr --> /dev/null
- otus --> ar9170 --> carl9170
- ( rt2870 && rt3070 ) --> rt2800usb
- rt2870 --> rt2800pci
- [ at76c503a --> ] at76_usb --> at76c50x-usb   [*] not in staging

the pending ones
- rtl8187se [ --> rtl8180 ]   [*] hopefully soon
- rtl8188eu --> ?
- [ rtl8192du --> ? ]   [*] not in staging, [1]
- rtl8192e --> ?
- rtl8192u --> ?
- rtl8192su --> rtl8712 --> ? [ r92su[2] would add cfg80211 support, 
                                but it being a fullmac like
                                re-implementation doesn't get it 
                                anywhere ]
- rtl8821ae [ --> mac80211 port planned for 3.15[3]? ]

these devices are, besides rtl8187se (802.11g) and rtl8821ae 
(802.11ac), all 802.11n compatible, but were quickly EOLed by the 
vendor, probably making it hard to get enough traction for a proper 
mac80211 port. Coincidentally these chipsets are also very popular, 
rtl8187se being the chipset of the early netbook craze, rtl8188eu 
pretty ubiquitous on embedded platforms, the others making the bulk 
of aftermarket USB devices.

ancient hardware, probably not going anywhere:
- vt6655 --> ?
- vt6656 --> ?
- wlags49_h2 --> ?
- wlags49_h25 --> ?
- wlan-ng --> ?

This likely leaves staging wireless drivers to small corrections and 
bugfixes. In the hope that the devices will get enough traction that 
someone takes up the effort of doing a parallel re-implementation of a
proper mac80211 based driver, using the staging source only as 
reference.

Regards
	Stefan Lippers-Hollmann

[1]	https://github.com/lwfinger/rtl8192du
[2]	https://github.com/chunkeey/rtl8192su/tree/master/r92su
[3]	http://lkml.kernel.org/r/52E066A1.9010009@lwfinger.net
	http://lkml.kernel.org/r/52E7D9F6.5070402@lwfinger.net
