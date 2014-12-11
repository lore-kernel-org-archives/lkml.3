Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbaLKTZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:25:23 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63247 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbaLKTZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:25:22 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: NULL pointer dereference in i2c-hid
Date: Thu, 11 Dec 2014 20:25:18 +0100
Message-ID: <1997315.tMSpVcGjDP@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CAN+gG=Fa5dPtfMSsU2MpqQJ6PWMTjN2izOfx2-ee-Shq21Hutw@mail.gmail.com>
References: <31518562.V5Oyo0POsI@xps13> <2128690.c90ERDd9ZP@xps13> <CAN+gG=Fa5dPtfMSsU2MpqQJ6PWMTjN2izOfx2-ee-Shq21Hutw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2014 13:41:57 Benjamin Tissoires wrote:
> On Thu, Dec 11, 2014 at 1:16 PM, Gabriele Mazzotta
> <gabriele.mzt@gmail.com> wrote:
> > On Thursday 11 December 2014 16:03:07 Mika Westerberg wrote:
> >> On Thu, Dec 11, 2014 at 10:58:01AM +0200, Mika Westerberg wrote:
> >> > On Wed, Dec 10, 2014 at 06:04:51PM +0100, Gabriele Mazzotta wrote:
> >> > > my laptop uses a touchpad that needs hid-rmi along with i2c-hid to work.
> >> > > i2c-hid and hid-rmi can be loaded and unloaded independelty from each
> >> > > other, however since 34f439e4afcd ("HID: i2c-hid: add runtime PM support")
> >> > > if I unload hid-rmi and after it I also unload i2c-hid, I get a NULL
> >> > > pointer dereference.
> >> >
> >> > I'll look into this.
> >> >
> >> > I can reproduce this easily with i2c-hid + hid-multitouch following your
> >> > directions.
> >>
> >> Can you try the below patch?
> >>
> >> I think we shouldn't free buffers yet in ->stop() because we need the
> >> command buffer sending power commands to the device. Also it seems that
> >> ->start() re-allocates buffers anyway if maximum size increases.
> >>
> >> It shouldn't even leak memory as we release buffers at ->remove()
> >> anyway.
> >>
> >> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> >> index 62cec01937ea..68a8c938feea 100644
> >> --- a/drivers/hid/i2c-hid/i2c-hid.c
> >> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> >> @@ -705,12 +705,7 @@ static int i2c_hid_start(struct hid_device *hid)
> >>
> >>  static void i2c_hid_stop(struct hid_device *hid)
> >>  {
> >> -     struct i2c_client *client = hid->driver_data;
> >> -     struct i2c_hid *ihid = i2c_get_clientdata(client);
> >> -
> >>       hid->claimed = 0;
> >> -
> >> -     i2c_hid_free_buffers(ihid);
> >>  }
> >>
> >>  static int i2c_hid_open(struct hid_device *hid)
> 
> Mika,
> 
> you can add my Rev-by when submitting this patch to the mailing list.
> 
> 
> >
> > Yes, it works, thanks.
> >
> > This change seems to also prevent kernel ooops when I unload either
> > i2c-hid or i2c-designware-platform while the touchpad is in use,
> > thing that is likely to happen because of the other bug I reported.
> >
> > Speaking of it, does any of you have any suggestion on how to debug it?
> 
> Hehe, I coincidentally just replied to your bug with one patch to try
> (that was proposed by the intel folks back in May[1]).
> The powertop problem is IMO really worrying because the purpose of
> i2c_hid was to reduce power consumption :)
> 
> Anyway, thanks for the quick test.
> 
> Cheers,
> Benjamin
> 
> [1] https://patchwork.kernel.org/patch/4133771/

Thanks for the reply.

It is sad that using the touchpad as PS/2 device gives me a better
battery life. What makes me use hid-rmi is that the touchpad works
definitely better with it (touchpad more reactive, correct min/max range
and palm detection that takes into account the width of the fingers).
The only other advantage of using the touchpad as PS/2 device (maybe
disadvantage for someone else) is that the keyboard illumination is
automatically turned on when the touchpad is in use. For some reason
it doesn't happen with hid-rmi, but that's really not a problem.

Anyway, I tried the patch and unfortunately it makes no difference.

Gabriele
