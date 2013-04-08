Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935533Ab3DHSsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:48:10 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:43500 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935047Ab3DHSsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:48:08 -0400
Date: Mon, 8 Apr 2013 11:48:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Ilya Zykov <linux@izyk.ru>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Fix race condition if flushing tty flip buffers
Message-ID: <20130408184804.GA4066@kroah.com>
References: <5149AFD0.8020604@izyk.ru>
 <1363800043-21449-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363800043-21449-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 01:20:43PM -0400, Peter Hurley wrote:
> As Ilya Zykov identified in his patch 'PROBLEM: Race condition in
> tty buffer's function flush_to_ldisc()', a race condition exists
> which allows a parallel flush_to_ldisc() to flush and free the tty
> flip buffers while those buffers are in-use. For example,
> 
>   CPU 0                         |  CPU 1                                  |  CPU 2
>                                 | flush_to_ldisc()                        |
>                                 |  grab spin lock                         |
> tty_buffer_flush()              |                                         | flush_to_ldisc()
>  wait for spin lock             |                                         |  wait for spin lock
>                                 |   if (!test_and_set_bit(TTYP_FLUSHING)) |
>                                 |    while (next flip buffer)             |
>                                 |     ...                                 |
>                                 |     drop spin lock                      |
>   grab spin lock                |                                         |
>    if (test_bit(TTYP_FLUSHING)) |                                         |
>     set_bit(TTYP_FLUSHPENDING)  |      receive_buf()                      |
>     drop spin lock              |                                         |
>                                 |                                         |   grab spin lock
>                                 |                                         |    if (!test_and_set_bit(TTYP_FLUSHING))
>                                 |                                         |    if (test_bit(TTYP_FLUSHPENDING))
>                                 |                                         |    __tty_buffer_flush()
> 
> CPU 2 has just flushed and freed all tty flip buffers while CPU 1 is
> transferring data from the head flip buffer.
> 
> The original patch was rejected under the assumption that parallel
> flush_to_ldisc() was not possible. Because of necessary changes to
> the workqueue api, work items can execute in parallel on SMP.
> 
> This patch differs slightly from the original patch by testing for
> a pending flush _after_ each receive_buf(), since TTYP_FLUSHPENDING
> can only be set while the lock is dropped around receive_buf().
> 
> Reported-by: Ilya Zykov <linux@izyk.ru>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_buffer.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)

What tree is this against?  Does it need your other larger set of ldisc
patches, or can it be applied without it?

confused,

greg k-h
