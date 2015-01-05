Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbbAEPa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:30:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbbAEPa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:30:26 -0500
Date: Mon, 5 Jan 2015 10:30:07 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chung-yih Wang <cywang@chromium.org>
Subject: Re: [PATCH 1/2] Input: synaptics: Use in-kernel tracking for
 reporting mt data
Message-ID: <20150105153007.GE19391@mail.corp.redhat.com>
References: <1414693987-6059-1-git-send-email-benjamin.tissoires@redhat.com>
 <20141031165136.GB32331@dtor-ws>
 <CAN+gG=EBz6vifWoV5PmGzMNJgHD59F2P_6sZfDZU5hbkSOPoQQ@mail.gmail.com>
 <CAN+gG=F0a1FLvgFkWMc4qC_WAj6dSmOaEEZhvty2KGbbM+uQtw@mail.gmail.com>
 <20141229222650.GG9565@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141229222650.GG9565@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Dec 29 2014 or thereabouts, Dmitry Torokhov wrote:
> Hi Benjamin,
> 
> On Mon, Dec 08, 2014 at 01:01:28PM -0500, Benjamin Tissoires wrote:
> > On Thu, Nov 20, 2014 at 2:42 PM, Benjamin Tissoires
> > <benjamin.tissoires@gmail.com> wrote:
> > > On Fri, Oct 31, 2014 at 12:51 PM, Dmitry Torokhov
> > > <dmitry.torokhov@gmail.com> wrote:
> > >> On Thu, Oct 30, 2014 at 02:33:06PM -0400, Benjamin Tissoires wrote:
> > >>> The current code tries to consider all states and transitions to properly
> > >>> detect which finger is attached to which slot. The code is quite huge
> > >>> and difficult to read.
> > >>> If the sensor manages to group the touch points but is not reliable in
> > >>> giving tracking ids, we can simply use the kernel tracking method. Note
> > >>> that it is already used by Cr-48 Chromebooks.
> > >>>
> > >>> Incidentaly, this fixes a bug reported by Peter Hutterer:
> > >>> """
> > >>> on the Lenovo T440, run:
> > >>> evemu-record /dev/input/event4 | grep BTN_
> > >>>
> > >>> then put one, two, three, two fingers down
> > >>> when you go from 3 to 2 fingers the driver sends a spurious BTN_TOUCH 0
> > >>> event:
> > >>>
> > >>> E: 0.000000 0001 014a 0001      # EV_KEY / BTN_TOUCH            1
> > >>> E: 0.000000 0001 0145 0001      # EV_KEY / BTN_TOOL_FINGER      1
> > >>> E: 0.770008 0001 0145 0000      # EV_KEY / BTN_TOOL_FINGER      0
> > >>> E: 0.770008 0001 014d 0001      # EV_KEY / BTN_TOOL_DOUBLETAP   1
> > >>> E: 1.924716 0001 014d 0000      # EV_KEY / BTN_TOOL_DOUBLETAP   0
> > >>> E: 1.924716 0001 014e 0001      # EV_KEY / BTN_TOOL_TRIPLETAP   1
> > >>>
> > >>> .. changing from 3 to 2 fingers now
> > >>>
> > >>> E: 3.152641 0001 014a 0000      # EV_KEY / BTN_TOUCH            0
> > >>> E: 3.152641 0001 014d 0001      # EV_KEY / BTN_TOOL_DOUBLETAP   1
> > >>> E: 3.152641 0001 014e 0000      # EV_KEY / BTN_TOOL_TRIPLETAP   0
> > >>> E: 3.176948 0001 014a 0001      # EV_KEY / BTN_TOUCH            1
> > >>>
> > >>> quick look in the kernel shows it's caused by hw.z going to 0 for a packet,
> > >>> so probably a firmware bug. either way, it makes it hard to track BTN_TOUCH
> > >>> as signal that at least one finger is down.
> > >>> """
> > >>>
> > >>> The in-kernel tracking is enough to remove this spurious BTN_TOUCH 0.
> > >>>
> > >>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > >>> ---
> > >>>
> > >>> Hi Dmitry,
> > >>>
> > >>> I started working on that for 2 other bug reports
> > >>> https://bugs.freedesktop.org/show_bug.cgi?id=81278
> > >>> and
> > >>> https://bugs.freedesktop.org/show_bug.cgi?id=76722
> > >>>
> > >>> I thought the cursor jumps could be fixed by the in-kernel tracking, but the
> > >>> tracking needs a little bit more work to filter them out (patches to follow soon).
> > >>>
> > >>> From a user perspective, this patch does not change anything to what the user
> > >>> previously had. It also fixes Peter's bug that's why I decide to send this out
> > >>> by itself (removing ~350 lines of code and fixing bugs is always nice).
> > >>>
> > >>> I think the cursor jump fixes will need more bikeshedding in input-mt.c (I am
> > >>> *really* bad at designing APIs), so I'll send it later as an RFC.
> > >>
> > >> Daniel and Chung-yih were working on the driver so let's see if they
> > >> have a moment...
> > >>
> > >
> > > Any news from the chrome team? This is a requirement for fixing the
> > > cursor jumps, and I'd rather have this series in shape before
> > > introducing the changes in input-mt.c.
> > >
> > 
> > ping?
> 
> Looks like a very nice fix and clean up. I queued it for 3.20, sorry for
> the delay.
> 

No worries. It actually gave me more time to focus on other internal
things :)
Now I need to address the input-mt bits to split the touches when the
hardware does not separate two touches... Lots of fun!

Cheers and greetings!
Benjamin

