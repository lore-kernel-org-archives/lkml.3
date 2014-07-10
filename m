Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaGJPul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:50:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41041 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaGJPuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:50:40 -0400
Date: Thu, 10 Jul 2014 16:50:03 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Olivier Sobrie'" <olivier@sobrie.be>, David Miller <davem@davemloft.net>,
        "j.dumon@option.com" <j.dumon@option.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] hso: fix deadlock when receiving bursts of data
Message-ID: <20140710165003.0309924e@alan.etchedpixels.co.uk>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17270044@AcuExch.aculab.com>
References: <1404723967-24245-1-git-send-email-olivier@sobrie.be>
	<1404723967-24245-2-git-send-email-olivier@sobrie.be>
	<20140708.161633.2130069042930765600.davem@davemloft.net>
	<20140710142848.GA28056@hposo>
	<063D6719AE5E284EB5DD2968C1650D6D17270044@AcuExch.aculab.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014 14:37:37 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> From: Olivier Sobrie
> ...
> > The function put_rxbuf_data() is called from the urb completion handler.
> > It puts the data of the urb transfer in the tty buffer with
> > tty_insert_flip_string_flags() and schedules a work queue in order to
> > push the data to the ldisc.
> > Problem is that we are in a urb completion handler so we can't wait
> > until there is room in the tty buffer.

The tty provides the input queue, if the queue is full then just chuck
the data in the bitbucket.  hso is trying to be far too clever.

If hso is fast enough that the buffering isn't sufficient on the tty side
then we need to fix the tty buffer size.

Arguably what we need are tty fastpaths for non N_TTY but thats rather
more work. There's no fundamental reason that hso can't throw the buffer
at buffer straight at the PPP ldisc and straight into the network stack -
just that 

1. The tty mid layer glue is standing in the way
2. The change of line discipline code has to lock against it

Alan
