Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3BFUbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:31:20 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:54028 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756968Ab3BFUbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:31:18 -0500
Message-ID: <1360182669.5226.36.camel@thor.lan>
Subject: Re: 3.8-rc regression with pps-ldisc due to 70ece7a731
From: Peter Hurley <peter@hurleysoftware.com>
To: George Spelvin <linux@horizon.com>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Wed, 06 Feb 2013 15:31:09 -0500
In-Reply-To: <20130206194514.16104.qmail@science.horizon.com>
References: <20130206194514.16104.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-06 at 14:45 -0500, George Spelvin wrote:
> > Tight coupling is what caused this to break in the first place -- I
> > don't think tighter coupling is the right answer.
> 
> Agreed.  But given that n_tty already knows there are wrappers, it would
> have been possible to find a cleaner way to access an "aux pointer" in
> the tty structure, if that's what was desired.

I know. Like n_tty_get/set_data() with a void* in struct n_tty_data. But
I'm sure you'd agree that's just an expedient. If there were multiple
uses for this requirement, it'd be better to have this supported by the
base interface for all ldiscs.

> > You are not supposed to receive ldisc->dcd_change() calls outside
> > the open()/close() pair.
> 
> Yes, I figured that out.  I was wondering because I couldn't see any
> way that the serial interrupt hander was blocked or masked, but
> then I figured out that it's not, but instead the TTY_LDISC flag
> is used.
> 
> At the time the open() method is called, the flag is cleared, which makes
> tty_ldisc_ref() return NULL, which prevents calling the ldisc methods.

Exactly.

> > In the patch series I sent, I changed the BUG_ON() to WARN_ON_ONCE().
> > Please reply to that patch with the snipped kernel log output if it
> > warns in your testing and we'll go from there.
> 
> I really doubt it will.  The entire code change and comment was
> just caution on my part.

There were race conditions in the existing ldisc layer which allowed
references past halts. Just 2 days ago, I put up a 23-part
patch series to address it. It's very complicated and it's possible I
missed something.

Regards,
Peter Hurley


