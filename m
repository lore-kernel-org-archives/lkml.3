Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3A3KPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:15:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:49010 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab3A3KPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:15:01 -0500
Date: Wed, 30 Jan 2013 11:10:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dirkjan Bussink <dirkjan.bussink@nedap.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: Prevent deadlock in n_gsm driver
Message-ID: <20130130101058.GA9532@kroah.com>
References: <4B03AD17-906A-4FBF-9F00-3F860395B229@nedap.com>
 <20130130051213.GA26675@kroah.com>
 <0E76C0E9-AC46-42C0-BF43-12DAF0DCE313@nedap.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0E76C0E9-AC46-42C0-BF43-12DAF0DCE313@nedap.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 10:51:59AM +0100, Dirkjan Bussink wrote:
> This change fixes a deadlock when the multiplexer is closed while there
> are still client side ports open.
> 
> When the multiplexer is closed and there are active tty's it tries to
> close them with tty_vhangup. This has a problem though, because
> tty_vhangup needs the tty_lock. This patch changes it to unlock the
> tty_lock before attempting the hangup and relocks afterwards. The
> additional call to tty_port_tty_set is needed because otherwise the
> port stays active because of the reference counter.
> 
> This change also exposed another problem that other code paths don't
> expect that the multiplexer could have been closed. This patch also adds
> checks for these cases in the gsmtty_ class of function that could be
> called.
> 
> The documentation explicitly states that "first close all virtual ports
> before closing the physical port" but we've found this to not always
> reality in our field situations. The GPRS / UTMS modem sometimes crashes
> and needs a power cycle in that case which means cleanly shutting down
> everything is not always possible. This change makes it much more robust
> for our situation where at least the system is recoverable with this patch
> and doesn't hang in a deadlock situation inside the kernel.
> 
> The patch is against the long term support kernel (3.4.27) and should
> apply cleanly to more recent branches. Tested with a Telit GE864-QUADV2
> and Telit HE910 modem.
> 
> Signed-off-by: Dirkjan Bussink <dirkjan.bussink@nedap.com>
> Cc: stable <stable@vger.kernel.org>

This patch breaks the build in the tty-next tree:

drivers/tty/n_gsm.c: In function ‘gsm_dlci_release’:
drivers/tty/n_gsm.c:1713:3: error: too few arguments to function ‘tty_unlock’
In file included from drivers/tty/n_gsm.c:44:0:
include/linux/tty.h:596:24: note: declared here
drivers/tty/n_gsm.c:1715:3: error: too few arguments to function ‘tty_lock’
In file included from drivers/tty/n_gsm.c:44:0:
include/linux/tty.h:595:24: note: declared here

Can you fix this up (get it to build on the linux-next tree) and resend
it?

thanks,

greg k-h
