Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbaLPPsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:48:47 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:63102 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaLPPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:48:45 -0500
Message-ID: <5490545A.7020605@hurleysoftware.com>
Date: Tue, 16 Dec 2014 10:48:42 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Imre Deak <imre.deak@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] vt: fix console lock vs. kernfs s_active lock
 order
References: <1418681761-3709-1-git-send-email-imre.deak@intel.com>	<1418681761-3709-3-git-send-email-imre.deak@intel.com>	<20141216075300.GI2711@phenom.ffwll.local>	<1418725405.3185.31.camel@ideak-mobl>	<54902AA1.7080301@hurleysoftware.com>	<1418740692.7338.33.camel@intelbox>	<5490491E.70102@hurleysoftware.com> <CAKMK7uGbT6LYW5+75sowtJ95yitTTUbwRFhuWqeGKJNAUDY7kg@mail.gmail.com>
In-Reply-To: <CAKMK7uGbT6LYW5+75sowtJ95yitTTUbwRFhuWqeGKJNAUDY7kg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 10:10 AM, Daniel Vetter wrote:
> On Tue, Dec 16, 2014 at 4:00 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>>> The fix will be anyway the same in principal even after Daniel's planned
>>> rework for fbcon/fbdev: not holding the console_lock while freeing the
>>> sysfs entries.
>>
>> Oh, I didn't know Daniel was planning to rework fbcon/fbdev.
> 
> I don't. I've tried, cried and failed, so maybe in my next live ;-)
> But what I've tried was "let's fix fbcon" which was probably a bit too
> ambigitous. Splitting the notifier chains should be a lot more doable
> (but still lots of work I guess). The problem is it's not just the
> notifier chain that's broken with fbcon, but a lot more things:
> - initial modeset is done while holding the console lock. Would be
> true even after we fix this, since it's done as part of the con setup
> done by con_register. We'd need to do the modeset upfront, before
> registering fbcon.
> - panic handling is a joke with drm drivers and fbdev emulation plus
> fbcon - there's way too many sleeps and way too much code in the
> fbcon+drm panic path for this to ever work reliably as is. Would need
> massive rework. One of the most glaring things is that we have about 3
> things that tried to set up fbcon on panic (drm fbdev emulation panic
> handler, console unblanking on panic and fbcon panic handling).

yep - vt + printk + console lock + fbcon/fbdev + drm helper + kms driver
is a total nightmare.

> It's imo unfixable overall, so my long term plan is to get rid of
> fbdev emulation, fbcon and all console_lock paths from kms drivers (we
> have that now with I915_FBDEV=n). And then provide consoles with
> userspace deamons (kmscon) and a very minimalistic crash-dump tooling
> for panic handling on bare-bones kms drivers (not yet there, but
> patches from David Herrmann are floating around).

Interesting, I'll have to look into that.

Regards,
Peter Hurleykmscon

