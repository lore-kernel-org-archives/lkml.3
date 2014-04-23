Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbaDWQC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:02:29 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47978 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbaDWQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:02:25 -0400
Date: Wed, 23 Apr 2014 09:02:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Michal =?iso-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, elias.vds@gmail.com, anssi.hannula@iki.fi,
        simon@mungewell.org
Subject: Re: [PATCH v2 11/24] input: Port hid-holtekff to ff-memless-next
Message-ID: <20140423160220.GC10531@core.coreip.homeip.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
 <1398175209-9565-12-git-send-email-madcatxster@devoid-pointer.net>
 <1398255470.32091.3.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398255470.32091.3.camel@linux-fkkt.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 02:17:50PM +0200, Oliver Neukum wrote:
> On Tue, 2014-04-22 at 15:59 +0200, Michal Malý wrote:
> >  static int holtekff_play(struct input_dev *dev, void *data,
> > -                        struct ff_effect *effect)
> > +                        const struct mlnx_effect_command *command)
> >  {
> >         struct hid_device *hid = input_get_drvdata(dev);
> >         struct holtekff_device *holtekff = data;
> > +       const struct mlnx_rumble_force *rumble_force =
> > &command->u.rumble_force;
> >         int left, right;
> >         /* effect type 1, length 65535 msec */
> >         u8 buf[HOLTEKFF_MSG_LENGTH] =
> >                 { 0x01, 0x01, 0xff, 0xff, 0x10, 0xe0, 0x00 };
> 
> On the kernel stack.
> 
> >  
> > -       left = effect->u.rumble.strong_magnitude;
> > -       right = effect->u.rumble.weak_magnitude;
> > -       dbg_hid("called with 0x%04x 0x%04x\n", left, right);
> > +       switch (command->cmd) {
> > +       case MLNX_START_RUMBLE:
> > +               left = rumble_force->strong;
> > +               right = rumble_force->weak;
> > +               dbg_hid("called with 0x%04x 0x%04x\n", left, right);
> >  
> > -       if (!left && !right) {
> > -               holtekff_send(holtekff, hid, stop_all6);
> > -               return 0;
> > -       }
> > +               if (!left && !right) {
> > +                       holtekff_send(holtekff, hid, stop_all6);
> > +                       return 0;
> > +               }
> >  
> > -       if (left)
> > -               buf[1] |= 0x80;
> > -       if (right)
> > -               buf[1] |= 0x40;
> > +               if (left)
> > +                       buf[1] |= 0x80;
> > +               if (right)
> > +                       buf[1] |= 0x40;
> >  
> > -       /* The device takes a single magnitude, so we just sum them
> > up. */
> > -       buf[6] = min(0xf, (left >> 12) + (right >> 12));
> > +               /* The device takes a single magnitude, so we just sum
> > them up. */
> > +               buf[6] = min(0xf, (left >> 12) + (right >> 12));
> >  
> > -       holtekff_send(holtekff, hid, buf);
> > -       holtekff_send(holtekff, hid, start_effect_1);
> > +               holtekff_send(holtekff, hid, buf);
> > +               holtekff_send(holtekff, hid, start_effect_1);
> > +               return 0;
> > +       case MLNX_STOP_RUMBLE:
> > +               holtekff_send(holtekff, hid, stop_all6);
> > +               return 0;
> > +       default:
> > +               return -EINVAL;
> > +       }
> >  
> >         return 0;
> >  }
> 
> This looks very much like doing DMA on the kernel stack.

It isn't:

static void holtekff_send(struct holtekff_device *holtekff,
                          struct hid_device *hid,
                          const u8 data[HOLTEKFF_MSG_LENGTH])
{
        int i;

        for (i = 0; i < HOLTEKFF_MSG_LENGTH; i++) {
                holtekff->field->value[i] = data[i];
        }

        dbg_hid("sending %7ph\n", data);

        hid_hw_request(hid, holtekff->field->report, HID_REQ_SET_REPORT);
}

And also hid layer copies data a bunch of times over into DMA-safe
buffers.

> That is very strictly forbidden. The bug is also in the current
> code, but would you care to fix it up?
> 
> 	Regards
> 		Oliver
> 
> 

-- 
Dmitry
