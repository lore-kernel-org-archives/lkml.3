Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaD0IWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 04:22:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbaD0IWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 04:22:11 -0400
Message-ID: <1398586927.5442.6.camel@linux-fkkt.site>
Subject: Re: [PATCH v2 09/24] input: Port hid-dr to ff-memless-next
From: Oliver Neukum <oneukum@suse.de>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Date: Sun, 27 Apr 2014 10:22:07 +0200
In-Reply-To: <2156054.MZkXeC543k@sigyn>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
	 <1398175209-9565-10-git-send-email-madcatxster@devoid-pointer.net>
	 <1398260463.32091.5.camel@linux-fkkt.site> <2156054.MZkXeC543k@sigyn>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 12:32 +0200, Michal Malý wrote:
> On Wednesday 23 of April 2014 15:41:03 Oliver Neukum wrote:
> > On Tue, 2014-04-22 at 15:59 +0200, Michal Malý wrote:
> > >  static int drff_play(struct input_dev *dev, void *data,
> > > 
> > > -                                struct ff_effect *effect)
> > > +                       const struct mlnx_effect_command *command)
> > > 
> > >  {
> > >  
> > >         struct hid_device *hid = input_get_drvdata(dev);
> > >         struct drff_device *drff = data;
> > > 
> > > +       const struct mlnx_rumble_force *rumble_force =
> > > &command->u.rumble_force;
> > > 
> > >         int strong, weak;
> > > 
> > > -       strong = effect->u.rumble.strong_magnitude;
> > > -       weak = effect->u.rumble.weak_magnitude;
> > > +       strong = rumble_force->strong;
> > > +       weak = rumble_force->weak;
> > > 
> > >         dbg_hid("called with 0x%04x 0x%04x", strong, weak);
> > > 
> > > -       if (strong || weak) {
> > > -               strong = strong * 0xff / 0xffff;
> > > -               weak = weak * 0xff / 0xffff;
> > > -
> > > -               /* While reverse engineering this device, I found that
> > > when
> > > -                  this value is set, it causes the strong rumble to
> > > function
> > > -                  at a near maximum speed, so we'll bypass it. */
> > > -               if (weak == 0x0a)
> > > -                       weak = 0x0b;
> > > -
> > > -               drff->report->field[0]->value[0] = 0x51;
> > > -               drff->report->field[0]->value[1] = 0x00;
> > > -               drff->report->field[0]->value[2] = weak;
> > > -               drff->report->field[0]->value[4] = strong;
> > > -               hid_hw_request(hid, drff->report, HID_REQ_SET_REPORT);
> > > -
> > > -               drff->report->field[0]->value[0] = 0xfa;
> > > -               drff->report->field[0]->value[1] = 0xfe;
> > > -       } else {
> > > +       switch (command->cmd) {
> > > +       case MLNX_START_RUMBLE:
> > > +               if (strong || weak) {
> > > +                       strong = strong * 0xff / 0xffff;
> > > +                       weak = weak * 0xff / 0xffff;
> > > +
> > > +                       /* While reverse engineering this device, I
> > > found that when
> > > +                       this value is set, it causes the strong rumble
> > > to function
> > > +                       at a near maximum speed, so we'll bypass it.
> > > */
> > > +                       if (weak == 0x0a)
> > > +                               weak = 0x0b;
> > > +
> > > +                       drff->report->field[0]->value[0] = 0x51;
> > > +                       drff->report->field[0]->value[1] = 0x00;
> > > +                       drff->report->field[0]->value[2] = weak;
> > > +                       drff->report->field[0]->value[4] = strong;
> > 
> > This looks like an endianness bug.
> 
> I don't have a big endian machine to check but why would this be an endianness 
> issue? We're dealing with values all the time here, not addresses so I'd 
> expect the 'weak' and 'strong' values to be truncated if they won't fit into 
> byte. Division done beforehand makes sure that the values are within <0; 255> 
> range. As far as I can see this is quite common in the HID and Input code. Am 
> I missing something here?

Sorry, I thought you were writing to 16bit variables.

	Regards
		Oliver


