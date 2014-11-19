Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbaKSVjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:39:41 -0500
Received: from e2big.org ([198.61.226.133]:51566 "EHLO e2big.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182AbaKSVjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:39:39 -0500
X-Greylist: delayed 2018 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2014 16:39:39 EST
Date: Wed, 19 Nov 2014 22:05:52 +0100
From: ulrik.debie-os@e2big.org
To: Marcus Overhagen <marcus.overhagen@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [git pull] Input updates for 3.18-rc4
Message-ID: <20141119210552.GA5464@lantern>
References: <20141114222640.GA39748@dtor-ws>
 <CAN+gG=FaovQETa3+qQsLoBBQnbZ8Q2uoQJD6_XvAmCCvGTHT1g@mail.gmail.com>
 <CAJBHPojp7JVG6KKgrNfbC-V5ibPs-j6+BnqrSDkxvak0vNGM8w@mail.gmail.com>
 <20141119181247.GE37989@dtor-ws>
 <CAJBHPohu71BXqyZ4u74tAiP84UcQhXgto34k8NtNHPgw61WvLQ@mail.gmail.com>
 <20141119183921.GF37989@dtor-ws>
 <CAJBHPog3qRMQgNnso_csUOgR30A6eFPx4PkTzfCzkB3Gd5oVfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJBHPog3qRMQgNnso_csUOgR30A6eFPx4PkTzfCzkB3Gd5oVfQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks Dmitry, the fix you provided will mitigate the regression. But
there might be more that is going on for v4 hardware. The detection
of PACKET_TRACKPOINT can be made more strict.
Thank you Marcus and Benjamin for the reports.

Sorry for the regression, it was not expected that lowest nibble of packet[3]
is 0x6 for non-trackpoint packets.

So we have two laptops where 
1) according to the msb of the capabilities has no trackpoint
Benjamin, can you give feedback if the laptop has actually a trackpoint/stick/
how else one calls that strange but convenient thing in the middle of the 
keyboard ?
Marcus, do you even have a trackpoint ?


2) mouse packets are received on serio that smell like a trackpoint packet.
When I look at the packet dump from marcus,
It would also fail the sanity check when crc_enabled is off, but probably
succeeds on marcus laptop ? 

Marcus, can you send the firmware and capabilities information for your laptop
(it is available in the kernel messages). Could you send me a kernel message log for a period of 1 minute when using the touchpad with the debug set to 2 ?

I wonder packet[3]==0x46, why the 0x40 and 0x04 bits are set and the current
elantech driver does not do anything with that part of the information. The
packets from Marcus are probably v4 'MOTION' packets, and since the odd 
behaviour when they are ignored, they at least are containing the motion
information, but maybe some extra information is hidden. There are multiple
of those packets in a very short timeframe (milliseconds), I wonder if all
of the MOTION packets have this signature. 

At least now I'm happy that the warning is there, because otherwise it 
might be more difficult to pinpoint the cause.

Thanks,
Ulrik

On Wed, Nov 19, 2014 at 08:23:32PM +0100, Marcus Overhagen wrote:
> Date: Wed, 19 Nov 2014 20:23:32 +0100
> From: Marcus Overhagen <marcus.overhagen@gmail.com>
> To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>, Ulrik De Bie
>  <ulrik.debie-os@e2big.org>, Hans de Goede <hdegoede@redhat.com>,
>  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-input
>  <linux-input@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>
> Subject: Re: [git pull] Input updates for 3.18-rc4
> 
> Hi Dmitry,
> 
> luckily I found some time right now. I haven't reverted the original large
> patch, but I tested your short patch and it fixes the problem for me.
> 
> regards
> Marcus
> 
> On Wed, Nov 19, 2014 at 7:39 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Wed, Nov 19, 2014 at 07:20:21PM +0100, Marcus Overhagen wrote:
> >> Hi,
> >>
> >> I will try reverting that, but may need until tomorrow or Friday.
> >>
> >> Just now I made a warm reboot from rc3 to rc5 and initially scrolling
> >> behaviour was ok,  but after about a minute it went wrong and I got
> >> this:
> >>
> >> [  179.705362] ------------[ cut here ]------------
> >> [  179.705382] WARNING: CPU: 3 PID: 0 at
> >> drivers/input/mouse/elantech.c:433
> >> elantech_report_trackpoint.isra.5+0x199/0x1b0 [psmouse]()
> >> [  179.705385] psmouse serio1: elantech: Unexpected trackpoint message
> >
> > Or just this for now:
> >
> > diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> > index 3fcb6b3..294f613 100644
> > --- a/drivers/input/mouse/elantech.c
> > +++ b/drivers/input/mouse/elantech.c
> > @@ -793,7 +793,7 @@ static int elantech_packet_check_v4(struct psmouse *psmouse)
> >         unsigned char packet_type = packet[3] & 0x03;
> >         bool sanity_check;
> >
> > -       if ((packet[3] & 0x0f) == 0x06)
> > +       if ((packet[3] & 0x0f) == 0x06 && etd->tp_dev)
> >                 return PACKET_TRACKPOINT;
> >
> >         /*
> >
> > --
> > Dmitry
