Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab3LLHCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:02:01 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:38473 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3LLHB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:01:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAA9_cmc8b2rmp6hsgkLUEnFBmKqwdYCbdb_2rEycs-qVksAFpg@mail.gmail.com>
References: <CAGm_ybgC6Ca0qz6zJL0PkEUiyUi=Ct0L5t2GJOt9ZU-buP+wBQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1312111204220.1531-100000@iolanthe.rowland.org>
	<CAODwPW_ZUgHWymOF7Fzxh7sbhrvV0-g-pMXWQm=eSz2U8EBRtQ@mail.gmail.com>
	<20131211193647.GA25483@xanatos>
	<CAA9_cme4XmXqQfx9kTPEJWdx2XwBZk-G8s7pjSuZ5KWg3UZZ8Q@mail.gmail.com>
	<CAA9_cmc8b2rmp6hsgkLUEnFBmKqwdYCbdb_2rEycs-qVksAFpg@mail.gmail.com>
Date: Wed, 11 Dec 2013 23:01:57 -0800
X-Google-Sender-Auth: faZzJQEPHK_39jMQtSW9gyc3JZg
Message-ID: <CAODwPW8GqOcUadYD_jXdyFxJ0cdeLLRi6hs9jFODkQ1KuUr5FQ@mail.gmail.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming SuperSpeed HUBs
From: Julius Werner <jwerner@chromium.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Julius Werner <jwerner@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Vikas Sajjan <sajjan.linux@gmail.com>,
        Vikas Sajjan <vikas.sajjan@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Douglas Anderson <dianders@chromium.org>, Felipe Balbi <balbi@ti.com>,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> ...although, the spec says that it does not wait for the port resets
>> to complete.  As far as I can see re-issuing a warm reset and waiting
>> is the only way to guarantee the core times the recovery.  Presumably
>> the portstatus debounce in hub_activate() mitigates this, but that
>> 100ms is less than a full reset timeout.

It's definitely not just a timing issue for us. I can't reproduce all
the same cases as Vikas, but when I attach a USB analyzer to the ones
I do see the host controller doesn't even start sending a reset.

>>> The xHCI spec requires that when the xHCI host is reset, a USB reset is
>>> driven down the USB 3.0 ports.  If hot reset fails, the port may migrate
>>> to warm reset.  See table 32 in the xHCI spec, in the definition of
>>> HCRST.  It sounds like this host doesn't drive a USB reset down USB 3.0
>>> ports at all on host controller reset?

Oh, interesting, I hadn't seen that yet. So I guess the spec itself is
fine if it were followed to the letter.

I did some more tests about this on my Exynos machine: when I put a
device to autosuspend (U3) and manually poke the xHC reset bit, I do
see an automatic warm reset on the analyzer and the ports manage to
retrain to U0. But after a system suspend/resume which calls
xhci_reset() in the process, there is no reset on the wire. I also
noticed that it doesn't drive a reset (even after manual poking) when
there is no device connected on the other end of the analyzer.

So this might be our problem: maybe these host controllers (Synopsys
DesignWare) issue the spec-mandated warm reset only on ports where
they think there is a device attached. But after a system
suspend/resume (where the whole IP block on the SoC was powered down),
the host controller cannot know that there is still a device with an
active power session attached, and therefore doesn't drive the reset
on its own.

Even though this is a host controller bug, we still have to deal with
it somehow. I guess we could move the code into xhci_plat_resume() and
hide it behind a quirk to lessen the impact. But since reset_resume is
not a common case for most host controllers, it's hard to say if this
is DesignWare specific or a more widespread implementation mistake.
