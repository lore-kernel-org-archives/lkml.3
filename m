Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaABVgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:36:16 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:39602 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaABVgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:36:14 -0500
Date: Thu, 2 Jan 2014 22:36:29 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH, RFC 15/30] usbserial: stop using interruptible_sleep_on
Message-ID: <20140102213629.GA12793@localhost>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
 <1388664474-1710039-16-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388664474-1710039-16-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Jan 02, 2014 at 01:07:39PM +0100, Arnd Bergmann wrote:
> We really want to kill off interruptible_sleep_on, which is defined
> in a way that is always racy. There are four usb-serial drivers using
> it to implement their tiocmiwait() functions, which is defined in
> a way that always has a race when called from user space.
> 
> This patch changes the four drivers in the same way to use an open-coded
> prepare_to_wait/finish_wait loop to get rid of the deprecated function
> call, but it does not address the fundamental race.
>
> This particular method of implementing it was chosen because it is
> least invasive, a better but more invasive alternative would be
> to use usb_serial_generic_tiocmiwait, which is something I did not
> dare try without access to hardware.

I'd prefer to just fix the race once and for all. These four drivers
have been on my todo list since I converted the other usb-serial drivers
about a year ago. In fact, I posted a fix for f81232 last week, and
I've had a fix for pl2303 brewing as part of larger series for quite
some time.

I'll post a conversion series to linux-usb shortly and make sure to keep
you CC:ed on the sleep_on-killing patches.

Thanks,
Johan

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Johan Hovold <jhovold@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/serial/ch341.c      | 29 ++++++++++++++++--------
>  drivers/usb/serial/cypress_m8.c | 49 ++++++++++++++++++++++++++---------------
>  drivers/usb/serial/f81232.c     | 29 ++++++++++++++++--------
>  drivers/usb/serial/pl2303.c     | 29 ++++++++++++++++--------
>  4 files changed, 91 insertions(+), 45 deletions(-)
