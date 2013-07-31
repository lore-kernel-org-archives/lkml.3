Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab3GaCdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:33:49 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:37362 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3GaCdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1307301320360.1105-100000@iolanthe.rowland.org>
References: <1375204090-27465-1-git-send-email-jwerner@chromium.org>
	<Pine.LNX.4.44L0.1307301320360.1105-100000@iolanthe.rowland.org>
Date: Tue, 30 Jul 2013 19:33:46 -0700
X-Google-Sender-Auth: -vSTCw8Uq-KpHjhbk7S1Yv9pOKc
Message-ID: <CAODwPW8ZRpVPWKp0Eda4GDhNHiBqcWECW7d69H_oi4UoFQL_NQ@mail.gmail.com>
Subject: Re: [PATCH] usb: core: don't try to reset_device() a port that got
 just disconnected
From: Julius Werner <jwerner@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Wait a moment.  Why does each of these attempts lead to a 5-second
> timeout?  Why don't they fail immediately?

Now that you mention it, that's a very good question. The kernel
enqueues a control transfer to the now disconnected address because
it's internal bookkeeping is not yet updated, but I guess that should
usually fail very fast from an xHC-internal transaction timeout. I
have now tried to debug the cause of this: I see the transfer being
enqueued and the doorbell triggered, but never get a transfer event
back from it (until the software timeout calls usb_kill_urb() which
stops the endpoint). With the same setup on a PantherPoint system I
get the same U1/U2 disable control messages on unplugging, but they
fail within <5ms with a transaction error... so I guess this must be a
LynxPoint hardware bug.

Regardless, calling usb_reset_device() is still wrong and will at
least lead to pointless transfer attempts and error messages, so I
think my patch still has merit.

> What will happen here if udev is NULL?  Maybe you should change the
> test to (!udev || !(portstatus & ...)).

Right... I'm not sure if that can happen in practice, but I'll change
it just in case.
