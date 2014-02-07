Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaBGOmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:42:01 -0500
Received: from mx0.aculab.com ([213.249.233.131]:33772 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752684AbaBGOlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:41:08 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Emil Goode'" <emilgoode@gmail.com>,
        =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "'Igor Gnatenko'" <i.gnatenko.brain@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ming Lei <ming.lei@canonical.com>, Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: asix: fix bad header length bug
Thread-Topic: [PATCH] net: asix: fix bad header length bug
Thread-Index: AQHPI+hM9jIHqyBVlkS9F+g2/ALCs5qp0BoAgAAJosA=
Date: Fri, 7 Feb 2014 14:40:07 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6BA7AF@AcuExch.aculab.com>
References: <1391691384-8486-1-git-send-email-emilgoode@gmail.com>
 <1391692768.2843.4.camel@X1Carbon.localdomain>
 <063D6719AE5E284EB5DD2968C1650D6D0F6B99F7@AcuExch.aculab.com>
 <20140206224121.GB5251@lianli> <87wqh7i7pf.fsf@nemi.mork.no>
 <20140207135320.GA4252@lianli>
In-Reply-To: <20140207135320.GA4252@lianli>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s17Eg6xn015843

From: Emil Goode 
> On Fri, Feb 07, 2014 at 10:38:04AM +0100, BjÃ¸rn Mork wrote:
> > Emil Goode <emilgoode@gmail.com> writes:
> > > On Thu, Feb 06, 2014 at 03:28:13PM +0000, David Laight wrote:
> > >> From: Igor Gnatenko
> > >> > On Thu, 2014-02-06 at 13:56 +0100, Emil Goode wrote:
> > >> > > The AX88772B occasionally send rx packets that cross urb boundaries
> > >> > > and the remaining partial packet is sent with no header.
> > >> > > When the buffer with a partial packet is of less number of octets
> > >> > > than the value of hard_header_len the buffer is discarded by the
> > >> > > usbnet module. This is causing dropped packages and error messages
> > >> > > in dmesg.
> >
> > > I will do some more digging in the code, but the test of skb->len
> > > against hard_header_len is done already in the completion callback
> > > function passed to usb_fill_bulk_urb so it seems that buffers of less
> > > than hard_header_len number of octets will be dropped regardless.
> >
> > I am pretty sure you are right about this bug. And the exact same
> > solution is already used by the cx82310_eth minidriver, so I don't see
> > the problem.  Your fix is fine IMHO.  But you should apply it to all the
> > devices using asix_rx_fixup_common(), not just the ax88772 ones.
> >
> > You could maybe make this a usbnet flag instead and create a generic
> > solution in usbnet, but frankly I believe the number of flags and their
> > meaning have exceeded drivers authors capabilities a long time ago.  At
> > least mine, which are quite limited ;-)
> >
> > An example of that problem is another bloody obvious bug I noticed while
> > looking at this driver: The 'struct driver_info ax88178_info' points to
> > asix_rx_fixup_common without setting the FLAG_MULTI_PACKET.  This will
> > result in usbnet rx_process() calling usbnet_skb_return() on skbs which
> > are already consumed by the minidriver.  Not a big problem, but will
> > give some odd results.  But if you allow skbs shorter than ETH_HLEN to
> > slip through then it might go boom, so you should probably fix that as
> > well.
> >
> >
> > BjÃ¸rn
> 
> Yes I believe the patch is necessary, but maybe it would be nice with
> a prettier solution rather than setting hard_header_len to 0 for all
> devices with this behaviour. Perhaps it would be better to let each
> driver that uses the usbnet module decide what skbs to discard?
> 
> What David describes seems to be another bug, but I don't think it is
> related to this patch as I'm able to reproduce the bug without the patch
> beeing applied by setting the mtu to pretty much any value other than
> 1500 and using ping with a larger packet size than that mtu value.

Yes - plenty of bugs if you just look for them!

I did a quick scan through the sub-drivers and although the usbnet code
seems to treat the 'hard_header_len' as a constant to add to the mtu when
allocating rx urb (when the driver doesn't set rx_urb_len), some of the
sub-drivers seem to have three length, the rx header, tx header and hard_header,
and set them separately (I've not just rechecked) - which may not exactly
match what the usbnet code does is the lengths are different.

The ax88772b driver seems to support several different bits of silicon.
Only some put multiple ethernet frames in a single urb, and only for these
does the driver set the rx_urb_length to 2048.
For the other silicon it relies on usbnet setting the rx urb size - so
the hard_header_len better not be set to zero.

Someone with some time to spare needs to modify usbnet to support page
aligned rx buffers (probably 4k urb) and then build correctly formatted
skb from them.

At the moment the ax179_178a driver allocates 20kB urb which end up
with an 0x40 byte offset into the page (so are probably 24k) and
then cause alignment issues in the xhci driver which currently doesn't
correctly handle non-aligned 64k address boundaries when the cross the
ring end.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
