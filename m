Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaKYVXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:23:34 -0500
Received: from e2big.org ([198.61.226.133]:35245 "EHLO e2big.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbaKYVXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:23:32 -0500
Date: Tue, 25 Nov 2014 22:23:23 +0100
From: ulrik.debie-os@e2big.org
To: Marcus Overhagen <marcus.overhagen@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [git pull] Input updates for 3.18-rc4
Message-ID: <20141125212321.GA12591@lantern>
References: <CAN+gG=FaovQETa3+qQsLoBBQnbZ8Q2uoQJD6_XvAmCCvGTHT1g@mail.gmail.com>
 <CAJBHPojp7JVG6KKgrNfbC-V5ibPs-j6+BnqrSDkxvak0vNGM8w@mail.gmail.com>
 <20141119181247.GE37989@dtor-ws>
 <CAJBHPohu71BXqyZ4u74tAiP84UcQhXgto34k8NtNHPgw61WvLQ@mail.gmail.com>
 <20141119183921.GF37989@dtor-ws>
 <CAJBHPog3qRMQgNnso_csUOgR30A6eFPx4PkTzfCzkB3Gd5oVfQ@mail.gmail.com>
 <20141119210552.GA5464@lantern>
 <CAJBHPoiQ0ZuW2TjDu68SQrgOS=+OMTt0hptBmVedMLS55td1Rg@mail.gmail.com>
 <20141119215417.GC5464@lantern>
 <CAJBHPojucTj27EVLQRjDHZJe6bwZW3i-brwQ9N8mVY3rTp8koA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJBHPojucTj27EVLQRjDHZJe6bwZW3i-brwQ9N8mVY3rTp8koA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 19, 2014 at 11:21:31PM +0100, Marcus Overhagen wrote:
> Hi,
> 
> when moving a single finger [3] seems to be one of 0x21, 0x25, 0x31, 0x35
> moving two fingers [3] seems to be mostly 0x22, 0x26, 0x32, 0x36  but
> also sometimes it's 0x42, 0x46, 0x52, 0x56.
> It seems to occationally seems to switch between these two groups
> after touching the pad with three or more fingers, but not every time.
> 
> Moving three fingers I see[3] beeing  0x26, 0x36, 0x76, 0x66 (probably more)
> 
> regards
> Marcus


Ok, after some digging through the packet dump kindly provided by Marcus,
it is clear that Documentation/input/elantech.txt is not correctly 
representing anymore the packets of the v4 hardware. There should be some
0 and 1's replaced by x because they are currently "don't know" and definitely
not always 0 or 1.

Example:
He has 0x26,0x36,0x46,0x56,0x66,0x76 in packet[3], and the documentation had
the bits as:
id2 id1 id0   1   0   0   1   0
              X       X
The bits marked with X can thus be different. But when those are changed to
X==don't care then it is not trivial to differentiate them from the trackpoint
that has the following signature for that byte:
0   0   ~sy  ~sx  0   1   1   0



I'm considering the following change:
The test

        t = get_unaligned_le32(&packet[0]);

        switch (t & ~7U) {
        case 0x06000030U:
        case 0x16008020U:
        case 0x26800010U:
        case 0x36808000U:

could be moved to elantech_packet_check_v3/4() instead of the
simpler test on the lowest nibble of packet[3] (and keep the etd->tp_dev check):
       if ((packet[3] & 0x0f) == 0x06 && etd->tp_dev)
                return PACKET_TRACKPOINT;

I'll think a little bit more on it. Based on the packet dump I have this
seems to allow a perfect discrimation between trackpoint and touchpad packets.

Thanks,
Regards,
Ulrik

