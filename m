Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaFPNwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:52:31 -0400
Received: from bes.se.axis.com ([195.60.68.10]:49296 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaFPNwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:52:30 -0400
Date: Mon, 16 Jun 2014 15:52:23 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        Samuel Ortiz <samuel@sortiz.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH tty-next 09/22] tty: Remove tty_hung_up_p() tests from
 tty drivers' open()
Message-ID: <20140616135223.GJ732@axis.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
 <1402924639-5164-10-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402924639-5164-10-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 09:17:06AM -0400, Peter Hurley wrote:
> Since at least before 2.6.30, it has not been possible to observe
> a hung up file pointer in a tty driver's open() method unless/until
> the driver open() releases the tty_lock() (eg., before blocking).
> 
> This is because tty_open() adds the file pointer while holding
> the tty_lock() _and_ doesn't release the lock until after calling
> the tty driver's open() method. [ Before tty_lock(), this was
> lock_kernel(). ]
> 
> Since __tty_hangup() first waits on the tty_lock() before
> enumerating and hanging up the open file pointers, either
> __tty_hangup() will wait for the tty_lock() or tty_open() will
> not yet have added the file pointer. For example,
> 
> CPU 0                          |  CPU 1
>                                |
> tty_open                       |  __tty_hangup
>   ..                           |    ..
>   tty_lock                     |    ..
>   tty_reopen                   |    tty_lock  / blocks
>   ..                           |
>   tty_add_file(tty, filp)      |
>   ..                           |
>   tty->ops->open(tty, filp)    |
>     tty_port_open              |
>       tty_port_block_til_ready |
>         ..                     |
>         while (1)              |
>           ..                   |
>           tty_unlock           |    / unblocks
>           schedule             |    for each filp on tty->tty_files
>                                |      f_ops = tty_hung_up_fops;
>                                |    ..
>                                |    tty_unlock
>           tty_lock             |
>   ..                           |
>   tty_unlock                   |
> 
> Note that since tty_port_block_til_ready() and similar drop
> the tty_lock while blocking, when woken, the file pointer
> must then be tested for having been hung up.
> 
> Also, fix bit-rotted drivers that used extra_count to track the
> port->count bump.
> 
> CC: Mikael Starvik <starvik@axis.com>

For the CRIS part:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> CC: Samuel Ortiz <samuel@sortiz.org>
> CC: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
