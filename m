Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaBGKRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:17:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaBGKRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:17:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH, RFC 07/30] [media] radio-cadet: avoid interruptible_sleep_on race
Date: Fri, 07 Feb 2014 11:17:19 +0100
Message-ID: <55674412.rAimUmdW3X@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <52F4A82C.7010104@xs4all.nl>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <201401171528.02016.arnd@arndb.de> <52F4A82C.7010104@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:T+cgLCsMALC0gtJO2rUNM+uk7nX4UBC0kY3+y/Fm95I
 gdgIsFV1n28JOUwyuit2sh16UwJuz/iCU6FWtAao6dhqzUIUMJ
 12gpY1lFvi3nV4b7QN/9MHbtU6wnkEpMSS+S9tdzbGKHS2h+/G
 Yp3mIIOyJT3Tt0aA5mtHxgtYyKZFXY5+yFF/WbXEXojYgO+D0M
 AsRFj0g4uS8z0yQbZU5TES9pwv7w+eD2QGntGqKvPWnxkN2jUx
 3YzxHL1V82IkTaQy2QOcnw48r8rT/y4oVyHbwmyxvMNVxwwwDs
 8y5fgNnrasB8pPjEAIC49huxYn8yuZufCeTp4uv4p+EGDbIWDZ
 VXkcVK3P4sMz1RBTjRgU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 February 2014 10:32:28 Hans Verkuil wrote:
>         mutex_lock(&dev->lock);
>         if (dev->rdsstat == 0)
>                 cadet_start_rds(dev);
> -       if (dev->rdsin == dev->rdsout) {
> +       while (dev->rdsin == dev->rdsout) {
>                 if (file->f_flags & O_NONBLOCK) {
>                         i = -EWOULDBLOCK;
>                         goto unlock;
>                 }
>                 mutex_unlock(&dev->lock);
> -               interruptible_sleep_on(&dev->read_queue);
> +               if (wait_event_interruptible(&dev->read_queue,
> +                                            dev->rdsin != dev->rdsout))
> +                       return -EINTR;
>                 mutex_lock(&dev->lock);
>         }
>         while (i < count && dev->rdsin != dev->rdsout)
> 

This will normally work, but now the mutex is no longer
protecting the shared access to the dev->rdsin and
dev->rdsout variables, which was evidently the intention
of the author of the original code.

AFAICT, the possible result is a similar race as before:
if once CPU changes dev->rdsin after the process in
cadet_read dropped the lock, the wakeup may get lost.

It's quite possible this race never happens in practice,
but the code is probably still wrong.

If you think we don't actually need the lock to check
"dev->rdsin != dev->rdsout", the code can be simplified
further, to

	if ((dev->rdsin == dev->rdsout) && (file->f_flags & O_NONBLOCK)) {
	        return -EWOULDBLOCK;
	i = wait_event_interruptible(&dev->read_queue, dev->rdsin != dev->rdsout);
	if (i)
		return i;
	
	Arnd
