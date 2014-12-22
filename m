Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaLVSZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:25:45 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34720 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaLVSZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:25:44 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1412221101540.23710-100000@netrider.rowland.org>
References: <1419244588-5227-3-git-send-email-wulf@rock-chips.com>
	<Pine.LNX.4.44L0.1412221101540.23710-100000@netrider.rowland.org>
Date: Mon, 22 Dec 2014 10:25:43 -0800
Message-ID: <CAODwPW8N-M0pwg0=gsp8WUkuo+B_Y6LSxWi1DbR1Ynx_u5qDXw@mail.gmail.com>
Subject: Re: [PATCH 2/2] USB: ehci-platform: Support ehci reset after resume quirk
From: Julius Werner <jwerner@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Wu Liang feng <wulf@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Eddie Cai <eddie.cai@rock-chips.com>, Roy Li <roy.li@rock-chips.com>,
        Chris Zhong <zyw@rock-chips.com>, Doug Anderson <dianders@google.com>,
        Pawel Osciak <posciak@google.com>, tfiga@google.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The EHCI controller doesn't properly detect the case when
>
> "The" EHCI controller?  I don't know what EHCI controller you're
> talking about, but my controllers don't have any trouble detecting
> device removal during suspend.

This is similar to other SoC-based controllers that loose state in
suspend, like on Samsung's Exynos. Usually we catch that with the
FLAG_CF check in ehci_resume(). In the case of RK3288 it unfortunately
leaves the CF flag (and other things, like PORTSC[PED] bits) set,
although it doesn't react to any events correctly. If the device
looses its power session the controller won't notice and then on
resume get stuck trying to send resume signals to something that had
been reset (or newly plugged in). I think since we can't trust the
controller to do anything right, the safest thing is to fall back to
the solution of resetting everything (at least we know that works),
and since the FLAG_CF check doesn't work we need another solution to
mark which controllers are affected.

> Isn't this solution too extreme?  What if the device was a flash
> storage drive and it wasn't unplugged during suspend?  This patch would
> force it to be removed, messing up any mounted filesystems, when there
> was no need.
>
> Can you find a better way to work around the problem?

As Doug said, I think persist is the solution. We have essentially the
same case: all we know is that there is now a device connected to the
same port that a device had been connected during suspend... but with
no guarantees whether it is the same device or in the same state. By
forcing people to use persist, we acknowledge that this has the same
risks (e.g. data corruption if a mounted mass storage device was
swapped out for another one), and we benefit from the same safety
checks like comparing the serial number.
