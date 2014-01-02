Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaABQs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:48:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:65024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaABQsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:48:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH, RFC 21/30] isdn: divert, hysdn: fix interruptible_sleep_on race
Date: Thu, 02 Jan 2014 17:48:47 +0100
Message-ID: <3610183.tucaANtxQk@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52C57F3B.9070509@cogentembedded.com>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-22-git-send-email-arnd@arndb.de> <52C57F3B.9070509@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:EjE6kYlwm6pHc8rKx7zr0z7IPdV/1/q+K7iLU3Pg5d6
 B3kJglBb1EJmDJ0d3DIzchXi0gyhJIts37+KPG1d4R7SBcxE8b
 MQE6/VXn+0gk29ulD8RrGpAEJC7qhoLEmmWeFCQ0h2uTdcRyPj
 KG6lOWXhkqJubtEPZjZaZr3JoPAW1kaXwfBwmoYBmtzjhafazA
 KAASVSZksLpEukmDeWtwVY/qqETzqN38oq2N23HmK2FQCb58iq
 GImE5GxfePQ6M4wSKm6xqylh8w30GsKD8ZbxZYmpcRXtFVY2rx
 51DiKZ3kqLCIBfy0m3AQjppWr+nJ/iwCpzOtFU2aCgPa+yeZn4
 iQdt/z/0kzqcEFPkitFI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 January 2014 19:01:15 Sergei Shtylyov wrote:
> > diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
> > index fb4f1ba..1c5dc34 100644
> > --- a/drivers/isdn/divert/divert_procfs.c
> > +++ b/drivers/isdn/divert/divert_procfs.c
> > @@ -86,12 +86,13 @@ isdn_divert_read(struct file *file, char __user *buf, size_t count, loff_t *off)
> >       struct divert_info *inf;
> >       int len;
> >
> > -     if (!*((struct divert_info **) file->private_data)) {
> > +     if (!(inf = *((struct divert_info **) file->private_data))) {
> 
>     checkpatch.pl shouldn't approve assignment inside *if*. Though you're 
> moving it from the existing code, it wouldn't hurt to fix it.

I tried to touch as little as possible, and while I wouldn't use that
style myself, it is applied consistently in this driver, including the
wait_event line I'm adding, where I feel it actually makes sense.

> >               if (file->f_flags & O_NONBLOCK)
> >                       return -EAGAIN;
> > -             interruptible_sleep_on(&(rd_queue));
> > +             wait_event_interruptible(rd_queue, (inf =
> > +                     *((struct divert_info **) file->private_data)));
> 
>     Parens around assignment are hardly useful.

We get a gcc warning without them:

drivers/isdn/divert/divert_procfs.c:95:14: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
    *((struct divert_info **) file->private_data));


I can still change the first one (in both files) if you think it's important,
but I'd rather not spend too much energy at coding style changes.

Thanks for taking a look.

	Arnd
