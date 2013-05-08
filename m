Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3EHSrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:47:09 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36792 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3EHSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <s5ha9o5wi7j.wl%tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
 <CACVXFVPwXtD8uO-L6xhYC8j1B3XMVKQSDd=tMskgAvGQ=dNrZw@mail.gmail.com> <s5ha9o5wi7j.wl%tiwai@suse.de>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 8 May 2013 20:46:43 +0200
Message-ID: <CAPXgP13yH_JvdrewbXjvpuQg2E4oaqJAk6zrPMXvEHX-cns0qg@mail.gmail.com>
Subject: Re: [PATCH 0/3] firmware: Fix usermodehelper deadlock at shutdown
To: Takashi Iwai <tiwai@suse.de>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 6:26 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 9 May 2013 00:07:17 +0800,
> Ming Lei wrote:

>> On Wed, May 8, 2013 at 2:56 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > Hi,
>> >
>> > this is a series of patches for the issue we faced in the firmware
>> > loader code during debugging the problem with dell_rbu driver with
>> > 3.9 kernel.
>> >
>> > The original problem was that the shutdown gets stuck when DELL BIOS
>> > update is performed.  This turned out to be a problem in the firmware
>> > loader.  Although the reason of dell_rbu driver breakage is still
>>
>> Sorry, from these patchset, I can't see why it is a problem in firmware.
>>
>> > unclear, we should fix the firmware loader side, at least, not to
>> > stall during shutdown.
>>
>> Firstly you need to describe what/why is the stall? In fact, firmware
>> loading can't stall forever and it will timeout, but the current 60sec
>> timeout might be too long.
>
> The timeout check is activated only when uevent flag is set, and
> dell_rbu driver doesn't set it explicitly (because it's not supposed
> to be handled via udev or whatever).

These use the firmware loader not in the way the interface was intended:
  drivers/misc/lattice-ecp3-config.c
  drivers/firmware/dell_rbu.c

They just use the mechanism without any of the usual userspace setup.
It's really a nasty hack to hijack the interface that way.

The commit 6e3eaab02028c4087a92711b20abb9e72cc803a7 is a pretty broken
idea to start with. If something triggers uevents during runtime which
is not uncommon, these on-demand silently created firmware devices
would get really confused and race against the udev firmware loader
which cancels the events.

As if the userspace firmware loading in general wasn't a bad enough
idea already. :)

Kay
