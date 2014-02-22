Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaBVNZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 08:25:49 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:43260 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaBVNZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 08:25:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAA_UwzK38FpDgv0RKfQG_QZd-OttZBQC60UffbyUGWq8E05PpQ@mail.gmail.com>
References: <20140220235118.191692546@linuxfoundation.org>
	<20140220235119.236520201@linuxfoundation.org>
	<CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
	<5307683C.50209@suse.de>
	<CA+5PVA5W=t9+OmZXZuJT-1EsZXmTUBrX4eHjJcmQg676SOjSng@mail.gmail.com>
	<CAPXgP12Vs3LtVPOxF-Tnn4H7NjD6unXtPEOjFzRRhJhf0xndRQ@mail.gmail.com>
	<CAA_UwzK38FpDgv0RKfQG_QZd-OttZBQC60UffbyUGWq8E05PpQ@mail.gmail.com>
Date: Sat, 22 Feb 2014 14:25:46 +0100
Message-ID: <CANq1E4T25a3JkYB_JggtueygqpGVn0vBmaMZXvohWb_jinxuag@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
From: David Herrmann <dh.herrmann@gmail.com>
To: Ray Strode <halfline@gmail.com>
Cc: Kay Sievers <kay@vrfy.org>, Josh Boyer <jwboyer@fedoraproject.org>,
        Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Jiri Slaby <jslaby@suse.cz>, Werner Fink <werner@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Feb 21, 2014 at 11:53 PM, Ray Strode <halfline@gmail.com> wrote:
> Hi,
>
> On Fri, Feb 21, 2014 at 11:01 AM, Kay Sievers <kay@vrfy.org> wrote:
>> Why did the tty0 change to tty1 now? That doesn't look like a "driver
>> name" vs. "device name" issue?
>
> I don't know if it's intentional, but the patch does:
> +               int index = cs[i]->index;
> ...
> +               driver = cs[i]->device(cs[i], &index);
>
> which will presumably change the index from 0 to 1 because of this code:
>
> static struct tty_driver *vt_console_device(struct console *c, int *index)
> {
>        *index = c->index ? c->index-1 : fg_console;
>        return console_driver;
> }
>
> At least that's what it looks like is causing the problem from
> browsing through the source a bit.

Yepp, that's it. So if you configure the console to always be
redirected to the foreground terminal, you simply bind it to tty0 and
this file used to return tty0 then.
With this patch, we actually return the foreground terminal instead,
so tty0 is resolved to the real VT. This sounds like the correct
behavior (even though it currently breaks poll() on this file). But if
it breaks stuff, we should revert it and add a second file just like
Peter suggested.

Thanks
David
