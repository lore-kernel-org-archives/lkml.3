Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab3GaQFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:05:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:47210 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab3GaQFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,788,1367996400"; 
   d="scan'208";a="374069970"
Date: Wed, 31 Jul 2013 09:05:43 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH] usb: core: don't try to reset_device() a port that got
 just disconnected
Message-ID: <20130731160543.GA5714@xanatos>
References: <1375204090-27465-1-git-send-email-jwerner@chromium.org>
 <Pine.LNX.4.44L0.1307301320360.1105-100000@iolanthe.rowland.org>
 <CAODwPW8ZRpVPWKp0Eda4GDhNHiBqcWECW7d69H_oi4UoFQL_NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAODwPW8ZRpVPWKp0Eda4GDhNHiBqcWECW7d69H_oi4UoFQL_NQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 07:33:46PM -0700, Julius Werner wrote:
> > Wait a moment.  Why does each of these attempts lead to a 5-second
> > timeout?  Why don't they fail immediately?
> 
> Now that you mention it, that's a very good question. The kernel
> enqueues a control transfer to the now disconnected address because
> it's internal bookkeeping is not yet updated, but I guess that should
> usually fail very fast from an xHC-internal transaction timeout. I
> have now tried to debug the cause of this: I see the transfer being
> enqueued and the doorbell triggered, but never get a transfer event
> back from it (until the software timeout calls usb_kill_urb() which
> stops the endpoint). With the same setup on a PantherPoint system I
> get the same U1/U2 disable control messages on unplugging, but they
> fail within <5ms with a transaction error... so I guess this must be a
> LynxPoint hardware bug.
> 
> Regardless, calling usb_reset_device() is still wrong and will at
> least lead to pointless transfer attempts and error messages, so I
> think my patch still has merit.

Hmm, 5 seconds is the xHCI command timeout.  Could the driver be
possibly issuing either a Reset Device or Address Device command that
simply times out?

Sarah Sharp
