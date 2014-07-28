Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaG1UBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:01:20 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:45439 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaG1UBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:01:17 -0400
Date: Mon, 28 Jul 2014 13:01:14 -0700
From: Patrik Fimml <patrikf@chromium.org>
To: Dmitry Torokhov <dtor@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Patrik Fimml <patrikf@chromium.org>,
        Bastien Nocera <hadess@hadess.net>, linux-pm@vger.kernel.org,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power-managing devices that are not of interest at some point in
 time
Message-ID: <20140728200114.GB20708@google.com>
References: <Pine.LNX.4.44L0.1407181557020.979-100000@iolanthe.rowland.org>
 <2443949.K0iePsg3Aa@vostro.rjw.lan>
 <1693424.kPNUQHOHlX@vostro.rjw.lan>
 <1451627.FURGiR949u@dtor-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1451627.FURGiR949u@dtor-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 04:16:50PM -0700, Dmitry Torokhov wrote:
> [...]
> Anyway, even though it is very tempting to declare inhibit a "deeper" state of 
> runtime suspend maybe you are right and inhibit should really be separate from 
> PM and drivers would have to sort out all the possible state permutations.
> 
> Considering input devices:
> 
> input_open(): check if device is inhibited, if so do nothing. Otherwise try 
> waking up itself and parent (via pm_runtime_get_sync() on itself), this will 
> power up the device. Do additional configuration if needed.
> 
> input_close(): check if device is inhibited, if not do pm_runtime_put (_sync? 
> to make sure we power off properly and not leave device up and running? or 
> should we power down manually not waiting for runtime PM)?
> 
> inhibit(): check if device is opened, if opened do pm_runtime_put_sync().
> 
> uninhibit(): if device is opened do pm_runtime_get_sync(), let runtime PM 
> bring up the device. Do additional config if needed -> very similar to 
> input_open(), different condition.
> 
> runtime_suspend(): power down the device. If not inhibited enable as wakeup 
> source.
> 
> runtime_resume(): power up the device if device is opened and not inhibited.
> 
> system_suspend(): check if device is opened, not inhibited and not in 
> runtimesuspend  already; power down.
> 
> system_resume(): power up the device if it is opened and not inhibited. I 
> guess it's OK to wake up device that shoudl be runtime-PM-idle since it will 
> go to back sleep shortly.
> 
> Ugh.. This is complicated...

There might be more elegant ways to implement this. It might make sense
to factor out power transitions. One could have a function that derives
the appropriate power state given the circumstances (i.e.
suspend/inhibit/runtime suspend) and then performs the needed
transition. This is something one would have to see when actually
implementing this, I might experiment with this approach a bit.

Regards,
Patrik
