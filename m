Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaAGNyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:54:21 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35803 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaAGNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:54:11 -0500
Date: Tue, 7 Jan 2014 07:54:09 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Heider <andreas@meetr.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 0/4] Get EDID late for VGA switcheroo
Message-ID: <20140107135409.GA21190@thinkpad-t410>
Mail-Followup-To: Ramkumar Ramachandra <artagnon@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andreas Heider <andreas@meetr.de>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 03:28:39PM +0530, Ramkumar Ramachandra wrote:
> Hi,
> 
> VGA switcheroo doesn't work on my 2013 MBP, and I'm trying to fix
> it. From what I've gathered from previous patches, it seems that the
> EDID is not computed at boottime, because LVDS isn't connected to the
> i915 card (and is connected to the nouveau card instead). So, here's a
> series to get switcheroo-reprobe to call get-edid. I think it's a step
> in the right direction, although I think more stuff is required to fix
> the issue.

It's been a while since I've thought about this, so my memory is
suspect. It's also a bit dated, and I haven't kept up to know what's
changed in since then. But I don't think just reading the mode on
reprobe gets you very far.

These are the main problems as I remember them:

 1. On many Macbook models the firmware isn't putting LVDS information
    in opregion. Reading the EDID during device initialization also
    fails since the DDC is muxed to the DGPU, so i915 concludes there's
    no LVDS and doesn't register an LVDS connector at all. I also think
    it was impossible to register a new connector at a later time,
    though I'm not sure about that.

 2. If i915 is forced to register the LVDS connector (say via a quirk)
    it still may not know the panel mode and guesses something rather
    conservative. This mode it assumes is used to allocate framebuffer
    memory, which is likely to end up being too small, and I don't think
    there was any support for resizing it later. This resulted in VTs
    not working because there isn't enough framebuffer memory for the
    mode they're trying to use.

 3. So what is really wanted is to be able to mux just the DDC over to
    the IGPU when the device is initialized to read the panel mode. One
    possible problem is that the hw might not support muxing the DDC
    separately, but Apple hw does so we'll ignore that for now. The
    basic code for muxing only the DDC isn't too difficult, and I had
    some patches for this at one point. The problem is that the handler
    must register with vga_switcheroo before this is possible, so
    there's a module initialization ordering issue that wasn't easily
    solved. Maybe now it would be possible to do something with
    EPROBE_DEFER, though I'm not sure how i915 would know whether or not
    it should wait for a switcheroo handler.

I just didn't have enough time to spend on this issue to work through
all of this. I also never looked at doing this with eDP, which is what I
thought all the Macbooks have been using for the last couple of years.
Are you sure your machine uses LVDS and not eDP?

Seth

