Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaFXOBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:01:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbaFXOBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:01:03 -0400
Date: Tue, 24 Jun 2014 10:00:49 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxwacom-devel <linuxwacom-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/5] Input - wacom: create a separate input device for
 pads
Message-ID: <20140624140049.GB7841@mail.corp.redhat.com>
References: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
 <1403557039-1487-2-git-send-email-benjamin.tissoires@redhat.com>
 <CAF8JNhKxSuLNj2TXFu3FcgH9c1QsfprvX5LfMr1Aj1yoJRsT8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF8JNhKxSuLNj2TXFu3FcgH9c1QsfprvX5LfMr1Aj1yoJRsT8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ping,

On Jun 23 2014 or thereabouts, Ping Cheng wrote:
> Hi Benjamin,
> 
> On Mon, Jun 23, 2014 at 1:57 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> > Currently, the pad events are sent through the stylus input device
> > for the Intuos/Cintiqs, and through the touch input device for the
> > Bamboos.
> >
> > To differentiate the buttons pressed on the pad from the ones pressed
> > on the stylus, the Intuos/Cintiq uses MISC_SERIAL and ABS_MISC. This
> > lead to a multiplexing of the events into one device, which are then
> > splitted out in xf86-input-wacom. Bamboos are not using MISC events
> > because the pad is attached to the touch interface, and only BTN_TOUCH
> > is used for the finger (and DOUBLE_TAP, etc...). However, the user space
> > driver still splits out the pad from the touch interface in the same
> > way it does for the pro line devices.
> >
> > The other problem we can see with this fact is that some of the Intuos
> > and Cintiq have a wheel, and the effective range of the reported values
> > is [0..71]. Unfortunately, the airbrush stylus also sends wheel events
> > (there is a small wheel on it), but in the range [0..1023]. From the user
> > space point of view it is kind of difficult to understand that because
> > the wheel on the pad are quite common, while the airbrush tool is not.
> >
> > A solution to fix all of these problems is to split out the pad device
> > from the stylus/touch. This decision makes more sense because the pad is
> > not linked to the absolute position of the finger or pen, and usually, the
> > events from the pad are filtered out by the compositor, which then convert
> > them into actions or keyboard shortcuts.
> 
> This is a very good solution. I like it.
> 
> > For backward compatibility with current xf86-input-wacom, the pad devices
> > still present the ABS_X, ABS_Y and ABS_MISC events, but they can be
> > completely ignored in the new implementation.
> 
> I do not think we need to keep ABS_X and ABS_Y for pad. We've already
> supported a tablet (Intuos pen small, a pen only tablet with buttons
> reported on touch interface) that does not set ABS_X and ABS_Y for
> pad.

Hmm, actually, when I tried removing X and Y, xf86-input-wacom
complained that max_x and max_y where set to 0, and it thus rejected the
device. Maybe there is a special quirk in the xorg driver for the device
you mentioned?

Anyway, it's not a big deal, and when both xorg and libinput will know
how to handle properly the pad device nodes, we can remove this.

> 
> Unless you plan to use other means to tell userland those events are
> from PAD tool, ABS_MISC is necessary and is a reasonable way to group

Well, given that the pad now has its own input node, ABS_MISC could be
dropped. We just need to teach the users that whichever event comes from
this input device is a PAD event. 

> PAD events. So, I do not think it is for backward compatibility. It is
> there to stay. With that said, the whole patchset is
> 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> Reviewed-by: Ping Cheng <pingc@wacom.com>
> 

Thanks, that is greatly appreciated!

> Thank you, Benjamin, for your support.
> 
> Ping
> 

Cheers,
Benjamin

