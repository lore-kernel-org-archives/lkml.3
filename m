Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3DYUkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:40:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab3DYUkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:40:15 -0400
Date: Thu, 25 Apr 2013 17:39:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jon Arne =?UTF-8?B?SsO4cmdlbnNlbg==?= <jonarne@jonarne.no>
Cc: linux-media@vger.kernel.org, jonjon.arnearne@gmail.com,
        linux-kernel@vger.kernel.org, hverkuil@xs4all.nl,
        elezegarcia@gmail.com, mkrufky@linuxtv.org, bjorn@mork.no
Subject: Re: [RFC V2 1/3] [smi2021] Add gm7113c chip to the saa7115 driver
Message-ID: <20130425173948.10ff0a2a@redhat.com>
In-Reply-To: <20130425203319.GA18656@dell.arpanet.local>
References: <1366917020-18217-1-git-send-email-jonarne@jonarne.no>
	<1366917020-18217-2-git-send-email-jonarne@jonarne.no>
	<20130425171328.08c79893@redhat.com>
	<20130425203319.GA18656@dell.arpanet.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 25 Apr 2013 22:33:20 +0200
Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:

> On Thu, Apr 25, 2013 at 05:13:28PM -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 25 Apr 2013 21:10:18 +0200
> > Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:
> > 
> > >  	/* Check whether this chip is part of the saa711x series */
> > > -	if (memcmp(name + 1, "f711", 4)) {
> > > +	if (memcmp(id->name + 1, "gm7113c", 7)) {
> > > +		chip_id = 'c';
> > 
> > There are several issues on the above:
> > 1) "id" may be NULL on autodetect mode;
> > 
> > 2) Why are you adding 1 here?
> >    It should be, instead id->name
> > 
> > 3) memcmp returns 0 if matches. So, the test is wrong.
> >    So, It should be instead:
> > 	if (!memcmp(id->name, "gm7113c", 7)) {
> > 
> > 4) Also, while that works, it seems a little hackish...
> > 
> 
> Oh, this is embarrassing.
> I just tried to change as little as possible in this module to make the
> device work.

No problems. On my experience, quick hacks like that are the
ones that generally have more troubles ;)

> > Something like:
> > 
> > static int saa711x_detect_chip(struct i2c_client *client,
> > 			       struct saa711x_state *state,
> > 			       const struct i2c_device_id *id)
> > {
> > 	int i;
> > 	char chip_id, name[16];
> > 
> > 	/*
> > 	 * Check for gm7113c (a saa7113 clone). Currently, there's no
> > 	 * known way to autodetect it, so boards that use will need to
> > 	 * explicitly fill the id->name field.
> > 	 */
> > 	if (id && !memcmp(id->name, "gm7113c", 7)) {
> > 		state->ident = V4L2_IDENT_GM7113C;
> > 		snprintf(client->name, sizeof(client->name), "%s", id->name);
> > 		return 0;
> > 	}
> > 
> > 	/* Check for Philips/NXP original chips */
> > 	for (i = 0; i < sizeof(name); i++) {
> > 		i2c_smbus_write_byte_data(client, 0, i);
> > 		name[i] = (i2c_smbus_read_byte_data(client, 0) & 0x0f) + '0';
> > 		if (name[i] > '9')
> > 			name[i] += 'a' - '9' - 1;
> > 	}
> > 	name[i] = '\0';
> > 
> > 	if (memcmp(name + 1, "f711", 4))
> > 		return -ENODEV;
> > 
> > 	chip_id = name[5];
> > 
> > 	snprintf(client->name, sizeof(client->name), "saa711%c", chip_id);
> > 
> > 	/*
> > 	 * Put here the code that fills state->ident for Philips/NXP chips
> > 	 */
> > ...
> > 
> > 	return 0;
> 
> Yes this seems to be a much better way to do it.
> I will fix my code.

Thanks!
Mauro
