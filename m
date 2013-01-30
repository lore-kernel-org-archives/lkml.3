Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3A3IKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:10:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:44719 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3A3IKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:10:14 -0500
Date: Wed, 30 Jan 2013 00:12:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dirkjan Bussink <dirkjan.bussink@nedap.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: Prevent deadlock in n_gsm driver
Message-ID: <20130130051213.GA26675@kroah.com>
References: <4B03AD17-906A-4FBF-9F00-3F860395B229@nedap.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B03AD17-906A-4FBF-9F00-3F860395B229@nedap.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 09:49:52AM +0100, Dirkjan Bussink wrote:
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

It doesn't apply cleanly to the linux-next tree, can you refresh this
and resend it so that I can apply it?  If you want it backported to the
stable kernel releases, we can only do that after it gets into Linus's
tree, see the file, Documentation/stable_kernel_rules.txt for details
about this.

thanks,

greg k-h
