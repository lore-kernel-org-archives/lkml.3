Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3LQVZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 16:25:39 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:40305 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3LQVZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 16:25:36 -0500
MIME-Version: 1.0
X-Originating-IP: [67.244.6.56]
In-Reply-To: <52B0BD72.9000804@iki.fi>
References: <1386969579.3914.13.camel@piranha.localdomain>
	<20131214092443.622b069d@samsung.com>
	<52ACE809.1000406@gmail.com>
	<CAGoCfiwxGU-j14oGDfvoYTA5WZUkQdM_3=80gfpWUjXVNN_nng@mail.gmail.com>
	<52AFE107.4040705@gmail.com>
	<CAGoCfiztzv-QFjmKXdiJreTPCYN1RTe5bPTO0awx5a-ER161qQ@mail.gmail.com>
	<52B0BD72.9000804@iki.fi>
Date: Tue, 17 Dec 2013 16:25:35 -0500
Message-ID: <CAGoCfixT0rabuv-MAhw4vhhCxyeOgzjb3FGbORPTV3JgkhjKdw@mail.gmail.com>
Subject: Re: stable regression: tda18271_read_regs: [1-0060|M] ERROR:
 i2c_transfer returned: -19
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Connor Behan <connor.behan@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Frederik Himpe <fhimpe@telenet.be>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 4:09 PM, Antti Palosaari <crope@iki.fi> wrote:
> That shared DVB / V4L2 tuner is one problem that I have also currently (SDR
> is on V4L2 API and DTV is provided via DVB API). I have decided to try model
> where I separate RF tuner totally independent used DVB / V4L2 APIs, just to
> plain I2C driver model. Idea is here to provide needed set of general
> callbacks and communication and device binding is done via I2C driver model.
> I am not sure though if there is any big caveats I haven't realized yet...

It's a tough problem - a more strictly defined API in theory allows
for better uniformity across drivers (although admittedly we've done a
piss-poor job in practice).  However such a strictly defined API makes
it harder to add hacks that are sometimes required by the silicon.

The additional abstractions provided by v4l2 subdev and tuner-core
just make it that much harder to get past those layers and poke the
device directly (which as much as I hate to admit it, is sometimes
required to work around bugs and weird edge cases in the silicon not
addressable via the API).  These problems are exacerbated by cases
where there are order-of-operations requirements that cannot be
accommodated by the API.

All that said though, moving to an entirely I2C based API feels like
to provides "too much flexibility" such that every bridge will talk a
little differently to every tuner.  Given what a crappy job we've done
in the past even with a strict framework, I cringe to think how much
worse the problem would be if every developer took a different
approach.

I'm not against implementing a callback which allows you to feed
arbitrary I2C commands to a device, to be used *sparingly* for those
cases where it is *really* required to do something not supported via
the framework's API.  But I don't see it as a replacement for the
existing frameworks for addressing tuners.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
