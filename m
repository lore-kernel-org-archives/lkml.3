Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaANVM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:12:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaANVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:12:55 -0500
Date: Tue, 14 Jan 2014 13:13:33 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] hvc: ensure hvc_init is only ever called once in
 hvc_console.c
Message-ID: <20140114211333.GB28453@kroah.com>
References: <1389733436-4661-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389733436-4661-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:03:37PM -0500, Paul Gortmaker wrote:
> Commit 3e6c6f630a5282df8f3393a59f10eb9c56536d23 ("Delay creation of
> khcvd thread") moved the call of hvc_init from being a device_initcall
> into hvc_alloc, and used a non-null hvc_driver as indication of whether
> hvc_init had already been called.
> 
> The problem with this is that hvc_driver is only assigned a value
> at the bottom of hvc_init, and so there is a window where multiple
> hvc_alloc calls can be in progress at the same time and hence try
> and call hvc_init multiple times.  Previously the use of device_init
> guaranteed that hvc_init was only called once.
> 
> This manifests itself as sporadic instances of two hvc_init calls
> racing each other, and with the loser of the race getting -EBUSY
> from tty_register_driver() and hence that virtual console fails:
> 
>     Couldn't register hvc console driver
>     virtio-ports vport0p1: error -16 allocating hvc for port
> 
> Here we add an atomic_t to guarantee we'll never run hvc_init twice.
> 
> Cc: stable@vger.kernel.org  # v2.6.24+
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Fixes: 3e6c6f630a52 ("Delay creation of khcvd thread")
> Reported-by: Jim Somerville <Jim.Somerville@windriver.com>
> Tested-by: Jim Somerville <Jim.Somerville@windriver.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> 
> [Greg: I realize tty-next is closed; given that this is an ancient
>  bug, I don't see any real urgency here, so feel free to queue it
>  whenever/whereever is most convenient - assuming it is an OK fix.]

Looks ok, I'll queue it up after 3.14-rc1 is out, thanks.

greg k-h
