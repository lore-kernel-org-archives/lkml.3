Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3GXWS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:18:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3GXWS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:18:27 -0400
Date: Wed, 24 Jul 2013 15:18:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dean Jenkins <Dean_Jenkins@mentor.com>
Cc: Andre Naujoks <nautsch2@gmail.com>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 5/5] SLIP: Fix transmission segmentation mechanism
Message-ID: <20130724221827.GC21709@kroah.com>
References: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
 <1372779094-11730-6-git-send-email-Dean_Jenkins@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372779094-11730-6-git-send-email-Dean_Jenkins@mentor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 04:31:34PM +0100, Dean Jenkins wrote:
> Binding SLIP with a PTY/TTY can cause truncated SLIP frames to be
> transmitted when the first write to the TTY fails to consume all
> the characters of the SLIP frame.
> 
> Asynchronous to the write function is a wakeup event from the TTY
> that indicates the TTY can accept more data. The wakeup event
> calls tty_wakeup() which calls slip_write_wakeup() when
> TTY_DO_WRITE_WAKEUP is set.
> 
> To complete the transmission of a SLIP frame to the TTY,
> slip_write_wakeup() must run at least once. Unfortunately, pty_write()
> also calls tty_wakeup() and when TTY_DO_WRITE_WAKEUP is set,
> slip_write_wakeup() is called. xleft is always zero and
> causes slip_write_wakeup() to complete the transmission and
> clears the TTY_DO_WRITE_WAKEUP flag. This can cause a truncated
> SLIP frame because any remaining characters will not get sent.
> 
> The wakeup event is unable to process the remaining characters
> because the TTY_DO_WRITE_WAKEUP flag has been cleared.
> 
> The code modification fixes the transmission segmentation
> mechanism by preventing pty_write() from calling
> slip_write_wakeup() by clearing TTY_DO_WRITE_WAKEUP before calling
> pty_write(). After pty_write() returns, TTY_DO_WRITE_WAKEUP is set
> to allow the TTY wakeup event to call slip_write_wakeup() to
> attempt to complete the transmission of the SLIP frame.
> 
> This may not be foolproof because a timeout is needed to
> break out of the cycle of transmission attempts. Note error
> codes from the TTY layer will break out of the cycle of
> transmission attempts.
> 
> Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
