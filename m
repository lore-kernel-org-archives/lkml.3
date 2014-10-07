Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaJGRPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:15:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40842 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754632AbaJGRPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:15:33 -0400
Date: Tue, 7 Oct 2014 13:15:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <20141007165149.GT24720@saruman>
Message-ID: <Pine.LNX.4.44L0.1410071310550.1504-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014, Felipe Balbi wrote:

> > Please believe me that I totally agree with you, but I also see Robert's
> > point. Let's take ADB as example. Before ADB has been ported to
> > FunctionFS it communicated with kernel using dev node provided by ADB
> > function driver. With that infrastructure death of daemon didn't cause
> > gadget unbind because kernel driver of that function was just stalling
> > the endpoints. This allows user to use all other functions of this
> 
> I really mixed feelings about that. It's really counter-intuitive to
> allow a non-working function to be exposed to the host.

...

> > Here also I agree. Zombie mode should "mock" the function until first
> > next enumeration or unbind. It should not be possible to bind gadget
> > with function in zombie mode to UDC. Zombie mode should "pretend" only
> > as long as gadget is bound and enumerated.
> 
> Not really. We shouldn't even coonect to host until adbd is running.
> Now, when adbd crashes we fix adbd. If it gets killed due to OOM we
> can't even say "ok, we'll buffer USB requests until adbd is restarted"
> because, well, we're running out of memory.
> 
> So, OOM we can't fix. Soon enough, another daemon (mtpd, ptpd, whatever)
> will be killed and another function will be left unusable.
> 
> As for adbd/mtpd/ptpd crashes, those need to fixed and kernel should not
> have to deal with them in any way.

It seems to me that we should imitate what an ordinary USB device would
do.  If part of the firmware crashes, generally you would expect none
of the endpoints associated with that function to work.  Either they
refuse to accept output from the host or they stall everything.  But
endpoints associated with other parts of the firmware might very well
continue to work okay.

Don't buffer requests.  Either allow the internal FIFOs to fill up or
else reject everything.  Any reasonable host will start getting timeout
expirations and will realize that something is wrong.

Alan Stern

