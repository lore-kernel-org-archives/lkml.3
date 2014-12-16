Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaLPMxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:53:05 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:62252 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLPMxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:53:01 -0500
Date: Tue, 16 Dec 2014 13:52:59 +0100
From: Johan Hovold <johan@kernel.org>
To: George McCollister <george.mccollister@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: serial: add nt124 usb to serial driver
Message-ID: <20141216125259.GM6778@localhost>
References: <1418081057-25283-1-git-send-email-george.mccollister@gmail.com>
 <20141210130412.GJ14346@localhost>
 <CAFSKS=PnDa+_2eBk0M7xiE5me-7muo2ddVzhk=gHWMYoXhZtmw@mail.gmail.com>
 <CAFSKS=MH0CU=t-TyHgcOun050EBQawkaDXfSN2OoC6MpZKgjmw@mail.gmail.com>
 <20141215095238.GB6778@localhost>
 <CAFSKS=P2TdK08m-pCY-WadBrMjXQj2ue-AxOujuKBaFFqvokaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=P2TdK08m-pCY-WadBrMjXQj2ue-AxOujuKBaFFqvokaQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:09:22AM -0600, George McCollister wrote:
> On Mon, Dec 15, 2014 at 3:52 AM, Johan Hovold <johan@kernel.org> wrote:
> > On Sun, Dec 14, 2014 at 11:51:11AM -0600, George McCollister wrote:
> >> Johan,
> >>
> >> While working on the tx_empty changes you suggested it occurred to me
> >> that it might not be obvious to others that the firmware doesn't send
> >> a packet with the NT124_CTRL_TXEMPTY flag cleared when it begins
> >> transmitting. The practical implication is that if the driver sets
> >> tx_empty = true when it sees NT124_CTRL_TXEMPTY, tx_empty must be
> >> reset to false somewhere when more data is transmitted. Perhaps I
> >> could add prepare_write_buffer and do it in there before calling
> >> usb_serial_generic_prepare_write_buffer(). Does that sound acceptable?
> >
> > Hmm. There's no way to query that flag? And the status is sent (as bulk
> > in data) periodically or only when data has been received? And not when
> > the actual status changes?
>
> The bulk in packets are not sent periodically only on TXEMPTY, other
> line change or received data. There's no way to query the flag, though
> we're still at the stage we can make modifications to the firmware if
> there's justification. One of the design goals is to minimize
> unnecessary USB traffic so if there's a place to clear the flag in the
> driver without querying it would be preferable.
>
> > A potential problem with using prepare_write_buffer would be on failures
> > to submit the write urb, in which case this flag might never be cleared.
>
> Yes, this could be a problem though I wonder how many (if any)
> recoverable situations this would happen in that didn't eventually
> lead to a transmission. Adding a timer with a long timeout that set
> tx_empty  = true crossed my mind but that doesn't really seem any less
> error prone than the original issue. I could of course duplicate a
> bunch of code from generic.c and make a few minor changes to set
> tx_empty = true but that obviously isn't desirable either.
> 
> If none of the above solutions sound acceptable, let me know I and I
> guess I'll change the firmware to allow polling of TXEMPTY with a
> control message and remove it from the bulk in packet.

I think it would be best if you could add a way to query the driver. It
seems like that is the only way to avoid having write race with the
tx_empty bulk-in status reports.

Thanks,
Johan
