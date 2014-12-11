Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbaLKTLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:11:21 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43631 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaLKTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:11:20 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        benjamin.tissoires@redhat.com, jkosina@suse.cz
Subject: Re: NULL pointer dereference in i2c-hid
Date: Thu, 11 Dec 2014 20:11:17 +0100
Message-ID: <2171175.gv8IA3dxxN@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <5489E505.3050903@synaptics.com>
References: <31518562.V5Oyo0POsI@xps13> <2128690.c90ERDd9ZP@xps13> <5489E505.3050903@synaptics.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2014 10:40:05 Andrew Duggan wrote:
> On 12/11/2014 10:16 AM, Gabriele Mazzotta wrote:
> > On Thursday 11 December 2014 16:03:07 Mika Westerberg wrote:
> >> On Thu, Dec 11, 2014 at 10:58:01AM +0200, Mika Westerberg wrote:
> >>> On Wed, Dec 10, 2014 at 06:04:51PM +0100, Gabriele Mazzotta wrote:
> >>>> my laptop uses a touchpad that needs hid-rmi along with i2c-hid to work.
> >>>> i2c-hid and hid-rmi can be loaded and unloaded independelty from each
> >>>> other, however since 34f439e4afcd ("HID: i2c-hid: add runtime PM support")
> >>>> if I unload hid-rmi and after it I also unload i2c-hid, I get a NULL
> >>>> pointer dereference.
> >>> I'll look into this.
> >>>
> >>> I can reproduce this easily with i2c-hid + hid-multitouch following your
> >>> directions.
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
> >>   static void i2c_hid_stop(struct hid_device *hid)
> >>   {
> >> -	struct i2c_client *client = hid->driver_data;
> >> -	struct i2c_hid *ihid = i2c_get_clientdata(client);
> >> -
> >>   	hid->claimed = 0;
> >> -
> >> -	i2c_hid_free_buffers(ihid);
> >>   }
> >>   
> >>   static int i2c_hid_open(struct hid_device *hid)
> > Yes, it works, thanks.
> >
> > This change seems to also prevent kernel ooops when I unload either
> > i2c-hid or i2c-designware-platform while the touchpad is in use,
> > thing that is likely to happen because of the other bug I reported.
> >
> > Speaking of it, does any of you have any suggestion on how to debug it?
> I was able to reproduce the initial issue by unloading hid-rmi and 
> i2c-hid while holding my fingers on the touchpad. Mika's patch fixes it 
> for me.
> 
> For the original bug, you can modprobe i2c-hid debug=1 and we can see 
> what data the touchpad is reporting. That might help narrowing down if 
> it's noise which the touchpad thinks are fingers or if there is a 
> problem with the I2C lines causing spurious interrupts.
> 
> Andrew

I've already tried to do that and here what I got:

When I release the finger, the last message is repeated 81 times.
If the byte containing informations about the width of the finger
becomes equal to either c0 or 0c at least once, the last message is
repeated indefinitely and changes as soon as I start using the touchpad.
The only way to stop it is to unload and reload i2c-hid.
