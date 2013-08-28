Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3H1EA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 00:00:29 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40072 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941Ab3H1EA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 00:00:27 -0400
Message-ID: <1377662419.2005.12.camel@dabdike>
Subject: Re: [PATCH v5 1/4] [SCSI] sg: use rwsem to solve race during
 exclusive open
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: joern@logfs.org, dgilbert@interlog.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Aug 2013 08:00:19 +0400
In-Reply-To: <1374468033-8947-2-git-send-email-vaughan.cao@oracle.com>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
	 <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
	 <1374468033-8947-2-git-send-email-vaughan.cao@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 12:40 +0800, Vaughan Cao wrote:
> A race condition may happen if two threads are both trying to open the same sg
> with O_EXCL simultaneously. It's possible that they both find fsds list is
> empty and get_exclude(sdp) returns 0, then they both call set_exclude() and
> break out from wait_event_interruptible and resume open.
> 
> Now use rwsem to protect this process. Exclusive open gets write lock and
> others get read lock. The lock will be held until file descriptor is closed.
> This also leads 'exclude' only a status rather than a check mark.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>

This produces a couple of unused variable warnings which will excite the
static checkers, so I've removed them:

drivers/scsi/sg.c: In function ‘sg_open’:
drivers/scsi/sg.c:268:6: warning: unused variable ‘res’ [-Wunused-variable]
drivers/scsi/sg.c: In function ‘sg_remove_sfp’:
drivers/scsi/sg.c:2138:20: warning: unused variable ‘sdp’ [-Wunused-variable]

Plus this:

> @@ -331,16 +331,19 @@ sg_open(struct inode *inode, struct file *filp)
>         if ((sfp = sg_add_sfp(sdp, dev)))
>                 filp->private_data = sfp;
>         else {
> -               if (flags & O_EXCL) {
> -                       set_exclude(sdp, 0);    /* undo if error */
> -                       wake_up_interruptible(&sdp->o_excl_wait);
> -               }
>                 retval = -ENOMEM;
> -               goto error_out;
> +               goto sem_out;
>         }
>         retval = 0;
> -error_out:
> +
>         if (retval) {
> +sem_out:
> +               if (flags & O_EXCL) {

Is insane code. You're adding a label to jump around setting retval=0
(which is completely superfluous: retval is already provably zero at
this point because of the check after retval =
scsi_autopm_get_device(sdp->device))

The sane way to write this is

	if ((sfp = sg_add_sfp(sdp, dev)))
		filp->private_data = sfp;
	else {
		retval = -ENOMEM;

		if (flags & O_EXCL) {
...

James


