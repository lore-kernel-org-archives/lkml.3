Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaJNBxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:53:46 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:38746 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaJNBxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:53:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAE1zotL4Pb5etHzakCxeDLvZR112XGGaHomZ_dbh=AQVc0wvPg@mail.gmail.com>
References: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
 <1412885235-14026-4-git-send-email-octavian.purdila@intel.com>
 <CAJjB1qKQ0ND2CeF=Npahn0r19WjdTwc7D3Th7PLnn0FJxHa_KQ@mail.gmail.com> <CAE1zotL4Pb5etHzakCxeDLvZR112XGGaHomZ_dbh=AQVc0wvPg@mail.gmail.com>
From: Mark Roszko <mark.roszko@gmail.com>
Date: Mon, 13 Oct 2014 21:53:20 -0400
Message-ID: <CAJjB1qJsmFebE2u_wMe2gdrQYcEwY1-yDLpufK97EXjEoR6omQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] i2c: show and change bus frequency via sysfs
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linux-i2c <linux-i2c@vger.kernel.org>, linux-api@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Johan Hovold <johan@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If this limitations exists
>they are not introduced by this patch. This patch just exposes the
>frequency so that it can be read or changed in userspace.

Ah, well right now you can have an i2c bus with driver 1 and 2. Say
the i2c bus is configured for 60khz in kernel space which normally
can't be changed. Driver 1 talks to a slave that cannot go above
100khz. Now the userspace interface is added to the i2c bus. Some
userspace application decides to reconfigure the bus for 400khz and do
its communication to some slave device. Now the kernel tries to do
some background talking to the drive 1 slave and suddenly finds it can
no longer communicate with it. Right now with the kernel space only
configuration, the system is safe from being messed up easily. It's
more of a sanity of configuration issue.

>On a different not, I have noticed that a fixed set of frequencies
>might not be the best API, since multiple drivers rather support a
>rather large set of frequencies in a range. A better API might be to
>expose a min-max range and let the bus driver adjust the requested
>frequency. I will follow up with a second version that does that.

I was actually thinking you could eliminate the table of supported
frequencies and just have the bus driver handle the set frequency
decision itself and just return an error code if it's invalid. There
are legitiamate drivers that cannot do more than a list of frequencies
already as well. One example is here:
http://lxr.free-electrons.com/source/drivers/i2c/busses/i2c-bcm-kona.c#L717
