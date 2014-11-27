Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbaK0Ult (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:41:49 -0500
Received: from e2big.org ([198.61.226.133]:48739 "EHLO e2big.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaK0Uls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:41:48 -0500
Date: Thu, 27 Nov 2014 21:41:39 +0100
From: ulrik.debie-os@e2big.org
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Marcus Overhagen <marcus.overhagen@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [git pull] Input updates for 3.18-rc4
Message-ID: <20141127204139.GA18953@lantern>
References: <20141119181247.GE37989@dtor-ws>
 <CAJBHPohu71BXqyZ4u74tAiP84UcQhXgto34k8NtNHPgw61WvLQ@mail.gmail.com>
 <20141119183921.GF37989@dtor-ws>
 <CAJBHPog3qRMQgNnso_csUOgR30A6eFPx4PkTzfCzkB3Gd5oVfQ@mail.gmail.com>
 <20141119210552.GA5464@lantern>
 <CAJBHPoiQ0ZuW2TjDu68SQrgOS=+OMTt0hptBmVedMLS55td1Rg@mail.gmail.com>
 <20141119215417.GC5464@lantern>
 <CAJBHPojucTj27EVLQRjDHZJe6bwZW3i-brwQ9N8mVY3rTp8koA@mail.gmail.com>
 <20141125212321.GA12591@lantern>
 <CAN+gG=FkhofpNmpP6=3uBeywYRVceYViGoAG1Z5W6u1Bofm9tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=FkhofpNmpP6=3uBeywYRVceYViGoAG1Z5W6u1Bofm9tA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Wed, Nov 26, 2014 at 09:33:26AM -0500, Benjamin Tissoires wrote:
> 
> Hi Ulrik,
> 
> On Tue, Nov 25, 2014 at 4:23 PM,  <ulrik.debie-os@e2big.org> wrote:
> > Hi,
> >
> > On Wed, Nov 19, 2014 at 11:21:31PM +0100, Marcus Overhagen wrote:
> >> Hi,
> >>
> >> when moving a single finger [3] seems to be one of 0x21, 0x25, 0x31, 0x35
> >> moving two fingers [3] seems to be mostly 0x22, 0x26, 0x32, 0x36  but
> >> also sometimes it's 0x42, 0x46, 0x52, 0x56.
> >> It seems to occationally seems to switch between these two groups
> >> after touching the pad with three or more fingers, but not every time.
> >>
> >> Moving three fingers I see[3] beeing  0x26, 0x36, 0x76, 0x66 (probably more)
> >>
> >> regards
> >> Marcus
> >
> >
> > Ok, after some digging through the packet dump kindly provided by Marcus,
> > it is clear that Documentation/input/elantech.txt is not correctly
> > representing anymore the packets of the v4 hardware. There should be some
> > 0 and 1's replaced by x because they are currently "don't know" and definitely
> > not always 0 or 1.
> >
> > Example:
> > He has 0x26,0x36,0x46,0x56,0x66,0x76 in packet[3], and the documentation had
> > the bits as:
> > id2 id1 id0   1   0   0   1   0
> >               X       X
> > The bits marked with X can thus be different. But when those are changed to
> > X==don't care then it is not trivial to differentiate them from the trackpoint
> > that has the following signature for that byte:
> > 0   0   ~sy  ~sx  0   1   1   0
> >
> >
> >
> > I'm considering the following change:
> > The test
> >
> >         t = get_unaligned_le32(&packet[0]);
> >
> >         switch (t & ~7U) {
> >         case 0x06000030U:
> >         case 0x16008020U:
> >         case 0x26800010U:
> >         case 0x36808000U:
> >
> > could be moved to elantech_packet_check_v3/4() instead of the
> > simpler test on the lowest nibble of packet[3] (and keep the etd->tp_dev check):
> >        if ((packet[3] & 0x0f) == 0x06 && etd->tp_dev)
> >                 return PACKET_TRACKPOINT;
> >
> > I'll think a little bit more on it. Based on the packet dump I have this
> > seems to allow a perfect discrimation between trackpoint and touchpad packets.
> >
> 
> Thanks for the progress on these. Do you think you will be able to get
> something in shape before the final 3.18?
> 
> Dmitry, can we either revert the current patches and reschedule them
> for 3.19 or at least apply one quick fix? I am starting to see a lot
> of people complaining about it, and I am wondering if adding this
> functionality in a -rc5 release was not a good idea :-/.

Dmitry has already requested Linus to pull the quick fix 
b54783f2de0c216115333eca1a8d3d5c3e75b 

I expect this fix from Dmitry to also help the person that you reported,
could you confirm that ? Basically when the hardware reports no trackpoint
present, it will then behave like before the trackpoint as enabled on v4.

I expect some responses from people soon in order to find out if there
is even a better way to fix it.

Thanks,
Kind regards,
Ulrik



> Cheers,
> Benjamin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
