Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3LQS5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:57:53 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:60061 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751037Ab3LQS5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:57:51 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Tue, 17 Dec 2013 18:57:42 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/intel: Only smash VGA SR01 register if
 intel is default VGA device
Message-ID: <20131217185742.GP22448@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Keith Packard <keithp@keithp.com>, intel-gfx@lists.freedesktop.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1387300330-8844-1-git-send-email-keithp@keithp.com>
 <20131217172740.GM22448@nuc-i3427.alporthouse.com>
 <86bo0fs5or.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bo0fs5or.fsf@miki.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 10:17:24AM -0800, Keith Packard wrote:
> Chris Wilson <chris@chris-wilson.co.uk> writes:
> 
> > The bspec still says we must assert SR01 bit5 prior to disabling the VGA
> > plane.
> >
> > Perhaps the test should be whether (vga_reg & VGA_DISP_DISABLE) == 0 and
> > do nothing if the plane is already off.
> 
> The problem is that for some reason we're smashing *some other video
> card* when it's being used via efifb.

Ok, so as no vgaarb_clients have yet been registered and so the call to
grab the IO resource does not actually disable VGA IO routing to the
nvidia card.
 
> I'm wondering if vgaarb just doesn't work because efifb isn't telling
> vgaarb that it's using those registers (I mean, how would it even know?)

Agreed, that does seem to be the nub of the problem.
 
> The other simple option is to just not disable VGA if the card isn't
> primary; presumably it wasn't ever enabled.
> 
> And, yes, I know that the card probably won't work at all if it isn't
> primary because so much currently depends on the BIOS setting up bits of
> the card that we can't autodetect. So, another simple option would be to
> just refuse to load the driver if the card is secondary...

If you care to update the changelog to explain the problem is that
vgaarb is ineffective before all clients are registered, then I think
this is a good temporary hack. It should be possible for vgaarb to mark
resources as locked if the device is interpretting IO access and has no
method for disabling the IO grab (and then a vga_tryget() check here).
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
