Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3KFRDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:03:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab3KFRDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:03:50 -0500
Date: Wed, 6 Nov 2013 16:38:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        James Henstridge <james.henstridge@canonical.com>,
        =?ISO-8859-15?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        Bastien Nocera <hadess@hadess.net>
Subject: Re: [appleir] BUG: unable to handle kernel NULL pointer
 dereference
In-Reply-To: <20131029145139.GA2788@hercules>
Message-ID: <alpine.LNX.2.00.1311061635160.835@pobox.suse.cz>
References: <20131029145139.GA2788@hercules>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, Luis Henriques wrote:

> James has reported a NULL pointer dereference[1] on the appleir
> driver.  From the bug report[2] it looks like it is 100%
> reproducible using a 3.12-rc6 kernel simply by pressing any button on
> the IR remote.
> 
> >From the stack trace, it looks like input_event is invoked with the
> input_dev parameter set to NULL, which seems to indicate that
> appleir_input_configured is never invoked.
> 
> Any ideas?
> 
> [1] https://launchpadlibrarian.net/154942024/macmini-oops.jpg
> [2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1244505

[ adding some more CCs ]

Okay, so apparently we didn't register with input, but only hiddev / 
hidraw.

appleir 0003:05AC:8240.0005: hiddev0,hidraw4: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.3-2/input0

Therefore ->input_configured() callback has never been called, and thus we 
oops due to appleir->input_dev being NULL when the first raw event is 
reported.

Could you please provide report descriptor of the device?

The driver apparently relies on it being registered with hid-input, but 
for some reason that doesn't happen.

-- 
Jiri Kosina
SUSE Labs
