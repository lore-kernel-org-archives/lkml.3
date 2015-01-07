Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbbAGWzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 17:55:10 -0500
Received: from skprod3.natinst.com ([130.164.80.24]:37134 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752050AbbAGWzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 17:55:07 -0500
In-Reply-To: <1419953965-16494-1-git-send-email-peter@hurleysoftware.com>
References: <1419942873-6779-1-git-send-email-peter@hurleysoftware.com> <1419953965-16494-1-git-send-email-peter@hurleysoftware.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH v2] tty: Prevent hw state corruption in exclusive mode reopen
X-KeepSent: E11B8E2C:C7D29A8E-86257DC6:007DA974;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3FP3 November 16, 2012
From: Shreyas Bethur <shreyas.bethur@ni.com>
Message-ID: <OFE11B8E2C.C7D29A8E-ON86257DC6.007DA974-86257DC6.007DE311@ni.com>
Date: Wed, 7 Jan 2015 16:55:01 -0600
X-MIMETrack: Serialize by Router on US-AUS-MAIL4/AUS/M/NIC(Release 8.5.3FP6|November 21, 2013) at
 01/07/2015 04:55:01 PM,
	Serialize complete at 01/07/2015 04:55:01 PM
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-07_09:2015-01-07,2015-01-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley <peter@hurleysoftware.com> wrote on 12/30/2014 09:39:25 AM:

> From: Peter Hurley <peter@hurleysoftware.com>
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
> Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org, 
> linux-serial@vger.kernel.org, Shreyas Bethur 
> <shreyas.bethur@ni.com>, Peter Hurley <peter@hurleysoftware.com>
> Date: 12/30/2014 09:39 AM
> Subject: [PATCH v2] tty: Prevent hw state corruption in exclusive mode 
reopen
> 
> Exclusive mode ttys (TTY_EXCLUSIVE) do not allow further reopens;
> fail the condition before associating the file pointer and calling
> the driver open() method.
> 
> Prevents DTR programming when the tty is already in exclusive mode.
> 
> Reported-by: Shreyas Bethur <shreyas.bethur@ni.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_io.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 4f35b43..51f066a 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1464,6 +1464,9 @@ static int tty_reopen(struct tty_struct *tty)
>         driver->subtype == PTY_TYPE_MASTER)
>        return -EIO;
> 
> +   if (test_bit(TTY_EXCLUSIVE, &tty->flags) && !capable(CAP_SYS_ADMIN))
> +      return -EBUSY;
> +
>     tty->count++;
> 
>     WARN_ON(!tty->ldisc);
> @@ -2106,10 +2109,6 @@ retry_open:
>        retval = -ENODEV;
>     filp->f_flags = saved_flags;
> 
> -   if (!retval && test_bit(TTY_EXCLUSIVE, &tty->flags) &&
> -                  !capable(CAP_SYS_ADMIN))
> -      retval = -EBUSY;
> -
>     if (retval) {
>  #ifdef TTY_DEBUG_HANGUP
>        printk(KERN_DEBUG "%s: error %d in opening %s...\n", __func__,
> -- 
> 2.2.1
> 

Acked-by: Shreyas Bethur <shreyas.bethur@ni.com>

