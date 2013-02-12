Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab3BLTjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 14:39:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153Ab3BLTjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 14:39:07 -0500
Date: Tue, 12 Feb 2013 14:39:01 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130212193901.GA18906@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Thinkpad T430s suspend/resumes fine most of the time. But every so often
(like one in ten times or so), as soon as I suspend, I get a black screen,
and a blinking power button.

(Note: Not the capslock lights like when we panic, this laptop 'conveniently
 doesn't have those. This is the light surrounding the power button, which afaik
 isn't even OS controlled, so maybe we're dying somewhere in SMI/BIOS land?)

I tried debugging this with pm_trace, which told me..

[    4.576035]   Magic number: 0:455:740
[    4.576037]   hash matches drivers/base/power/main.c:645

Which points me at..

 642  Complete:
 643         complete_all(&dev->power.completion);
 644 
 645         TRACE_RESUME(error);
 646 
 647         return error;
 648 }

The only thing interesting here I think is that this is the resume path.
So perhaps something failed to suspend, and we tried to back out of suspending,
but something was too screwed up to abort cleanly ?

I've tried hooking up a serial console, and even tried console_noblank, 
which yielded no additional info at all. (I'm guessing the consoles are suspended
at the time of panic)

I also tried unloading all the modules I have loaded before the suspend, which
seemed to reduce the chances of it happening, but eventually it reoccurred.

Any ideas on how I can further debug this ?

	Dave

