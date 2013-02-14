Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551Ab3BNS22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 13:28:28 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:61682 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab3BNS21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 13:28:27 -0500
Date: Thu, 14 Feb 2013 10:28:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org
Subject: Re: [PATCH] drivercore: Fix ordering between deferred_probe and
 exiting initcalls
Message-ID: <20130214182824.GA20163@kroah.com>
References: <1360865667-8353-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360865667-8353-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 06:14:27PM +0000, Grant Likely wrote:
> One of the side effects of deferred probe is that some drivers which
> used to be probed before initcalls completed are now happening slightly
> later. This causes two problems.
> - If a console driver gets deferred, then it may not be ready when
>   userspace starts. For example, if a uart depends on pinctrl, then the
>   uart will get deferred and /dev/console will not be available
> - __init sections will be discarded before built-in drivers are probed.
>   Strictly speaking, __init functions should not be called in a drivers
>   __probe path, but there are a lot of drivers (console stuff again)
>   that do anyway. In the past it was perfectly safe to do so because all
>   built-in drivers got probed before the end of initcalls.
> 
> This patch fixes the problem by forcing the first pass of the deferred
> list to complete at late_initcall time. This is late enough to catch the
> drivers that are known to have the above issues.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Tested-by: Haojian Zhuang <haojian.zhuang@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: stable@vger.kernel.org
> ---
> 
> Hi Greg and Linus,
> 
> Okay, so this is really late to be sending for v3.8, and it doesn't have
> nearly the amount of testing that I would like it to have. I haven't
> even put it into linux-next yet. However, it is a real bug that some of
> the Linaro folks have run into that is caused by deferred probe. It
> isn't very widespread, but it is there.
> 
> It probably should be in v3.8, but given how ridiculously late it is and
> that it isn't a widespread problem it would probably be just fine to go
> in during the v3.9 merge window and get backported to linux-stable. If I
> don't hear otherwise then that is what I'll do.
> 
> Still, here it is. If you think it really should be merged before
> tagging v3.8 then please go ahead and apply it.

Nah, we can wait for 3.9-rc1, I'll queue it up in my tree and push it to
Linus for then, and tag it for stable kernels to be backported at that
point in time.

thanks,

greg k-h
