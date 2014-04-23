Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaDWMbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:31:49 -0400
Received: from prifuk.cz ([31.31.77.140]:49614 "EHLO smtp.devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbaDWMbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:31:46 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: Re: [PATCH v2 11/24] input: Port hid-holtekff to ff-memless-next
Date: Wed, 23 Apr 2014 14:31:42 +0200
Message-ID: <1592278.pD8vu465lA@sigyn>
User-Agent: KMail/4.13 (Linux/3.14.1-1-my-rd; KDE/4.13.0; x86_64; ; )
In-Reply-To: <1398255470.32091.3.camel@linux-fkkt.site>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net> <1398175209-9565-12-git-send-email-madcatxster@devoid-pointer.net> <1398255470.32091.3.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 of April 2014 14:17:50 Oliver Neukum wrote:
> On Tue, 2014-04-22 at 15:59 +0200, Michal Malý wrote:
> >  static int holtekff_play(struct input_dev *dev, void *data,
> > 
> > -                        struct ff_effect *effect)
> > +                        const struct mlnx_effect_command *command)
> > 
> >  {
> >  
> >         struct hid_device *hid = input_get_drvdata(dev);
> >         struct holtekff_device *holtekff = data;
> > 
> > +       const struct mlnx_rumble_force *rumble_force =
> > &command->u.rumble_force;
> > 
> >         int left, right;
> >         /* effect type 1, length 65535 msec */
> >         u8 buf[HOLTEKFF_MSG_LENGTH] =
> >         
> >                 { 0x01, 0x01, 0xff, 0xff, 0x10, 0xe0, 0x00 };
> 
> On the kernel stack.
> 
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
> >  
> >  }
> 
> This looks very much like doing DMA on the kernel stack.
> That is very strictly forbidden. The bug is also in the current
> code, but would you care to fix it up?

Okay, I'll look into it.

Michal

