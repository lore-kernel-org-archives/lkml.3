Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaJTRHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:07:24 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59870 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJTRHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:07:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-api@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        John Stultz <john.stultz@linaro.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the kernel
Date: Mon, 20 Oct 2014 19:06:47 +0200
Message-ID: <2166528.FFdzTaR0kp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141016124741.GA3832@kroah.com>
References: <20141016124741.GA3832@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:u5mRGVEfxSZSF2CROxDoP5FysmGdbotA3RxSxi1qMt3
 6AhLp6Me3zIqmhu05jyBFtlerq6L3A0GYCedTOXq+zx6e6YxoW
 BR2tmvDT90lclni9wmnFI75zA6DdmpcGXWOBURfIQRc+Sfio5x
 uDXolDQ6zRjNnO3tVj2ktZCYG3IyIDD6sSrwAbIlaRXH9acroB
 BhHUyV6IjhxyHCWEgJMujDt0MQgTcR+L7fANW3TOXMgZ/EhbCQ
 8GnIgJl3BSMOyixIapNWT+lPQvq3Q3SHeNgpV9cc2OQ5KjYLeP
 flXQ3mzLlEIUPh3i0YgPVIDsTW/muqVdSSwDQFdqWuiuOoj4f6
 Br9OXS+yVV/qu5J9jyhc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2014 14:47:41 Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The Android binder code has been "stable" for many years now.  No matter
> what comes in the future, we are going to have to support this API, so
> might as well move it to the "real" part of the kernel as there's no
> real work that needs to be done to the existing code.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> This was discussed in the Android miniconf at the Plumbers conference.
> If anyone has any objections to this, please let me know, otherwise I'm
> queueing this up for 3.19-rc1

I'm worried about the user interface: since graduating binder out of
staging with the existing ioctl interface has never been discussed
as a real option and (I assume) everybody expected the way forward
would be to have a replacement, I don't think it ever received the
attention it should have. Specific concerns are:

- I don't think there has been an audit of which subset of the API
  is actually required. IIRC, it was said initially that actual
  applications don't use all the features, and that we should have
  a smaller attack surface.

- Using kernel pointers in user space interfaces is an information
  leak that can be used to construct an exploit. (I don't know if
  this is still used that way, I think it was doing it last
  time I checked).

- The driver supports two versions of the user interface (v7 and
  v8), but only one of them can be selected at compile-time, and
  an 'allmodconfig' kernel will only include the deprecated one
  on 32-bit machines.

- The implementation is not namespace-aware and will cause
  information to be shared across containers in a potentially
  harmful way.
  If we graduate the driver from staging, it should IMHO at least
  be useful in containers to run Android user space safely.

	Arnd
