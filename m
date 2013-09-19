Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3ISK3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:29:54 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63141 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3ISK3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:29:52 -0400
Message-ID: <523AD21C.8030102@gmail.com>
Date: Thu, 19 Sep 2013 12:29:48 +0200
From: Andre Naujoks <nautsch2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: davem@davemloft.net, Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] slip/slcan: added locking in wakeup function
References: <1379093833-4949-1-git-send-email-nautsch2@gmail.com> <1379093833-4949-2-git-send-email-nautsch2@gmail.com> <523AC589.5040006@pengutronix.de>
In-Reply-To: <523AC589.5040006@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.09.2013 11:36, schrieb Marc Kleine-Budde:
> On 09/13/2013 07:37 PM, Andre Naujoks wrote:
>> The locking is needed, since the the internal buffer for the CAN
>> frames is changed during the wakeup call. This could cause buffer
>> inconsistencies under high loads, especially for the outgoing
>> short CAN packet skbuffs.
>> 
>> The needed locks led to deadlocks before commit 
>> "5ede52538ee2b2202d9dff5b06c33bfde421e6e4 tty: Remove extra
>> wakeup from pty write() path", which removed the direct callback
>> to the wakeup function from the tty layer.
> 
> What does that mean for older kernels? (<
> 5ede52538ee2b2202d9dff5b06c33bfde421e6e4)

It seems the slcan (and slip) driver is broken for older kernels. See
this thread for a discussion about the patch in pty.c.

http://marc.info/?l=linux-kernel&m=137269017002789&w=2

The patch from Peter Hurley was actually already in the queue, when I
ran into the problem, and is now in kernel 3.12.

Without the pty patch and slow CAN traffic, the driver works, because
the wakeup is called directly from the pty driver. That is also the
reason why there was no locking. It would just deadlock.

When the pty driver defers the wakeup, we ran into synchronisation
problems (which should be fixed by the locking) and eventually into a
kernel panic because of a recursive loop (which should be fixed by the
pty.c patch).

Maybe it is possible to get both patches back into the stable branches?

Regards
  Andre

> 
>> As slcan.c is based on slip.c the issue in the original code is
>> fixed, too.
>> 
>> Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
> Acked-by: Marc Kleine-Budde  <mkl@pengutronix.de>
> 
> Marc
> 

