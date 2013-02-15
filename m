Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974Ab3BOLF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:05:56 -0500
Received: from canardo.mork.no ([148.122.252.1]:56537 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3BOLFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:05:54 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Alex Courbot <acourbot@nvidia.com>
Cc: USB list <linux-usb@vger.kernel.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: usb_wwan_write() called while device still being resumed
Organization: m
References: <511CBCE8.9070204@nvidia.com> <87ehgivlmg.fsf@nemi.mork.no>
	<511DF09F.3070401@nvidia.com>
Date: Fri, 15 Feb 2013 12:05:08 +0100
In-Reply-To: <511DF09F.3070401@nvidia.com> (Alex Courbot's message of "Fri, 15
	Feb 2013 17:23:59 +0900")
Message-ID: <87r4khu9az.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Courbot <acourbot@nvidia.com> writes:

> Unfortunately it does not, and fails the same way. On the other hand,
> I do not see the issue when doing the following:
>
> diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
> index e4fad5e..1490029 100644
> --- a/drivers/usb/serial/usb_wwan.c
> +++ b/drivers/usb/serial/usb_wwan.c
> @@ -238,8 +238,6 @@ int usb_wwan_write(struct tty_struct *tty, struct
> usb_serial_port *port,
>                     usb_pipeendpoint(this_urb->pipe), i);
>
>                 err =
> usb_autopm_get_interface_async(port->serial->interface);
> -               if (err < 0)
> -                       break;
>
>                 /* send the data */
>                 memcpy(this_urb->transfer_buffer, buf, todo);
>
> After doing this I don't see this issue anymore. It looks wrong
> though. But it seems to work despite the obvious unbalance in autopm
> calls that results.
>
> If I understand you correctly, usb_wwan_write() failing here is not a
> problem in itself, and the ack should just be sent again later?

That was what I thought looking (obviously too) briefly through this.

Most errors from usb_autopm_get_interface_async will be translated to
EIO before being returned by serial_write.  I believe the userspace
application should deal with that.  But maybe it just gives up?  Should
we return EAGAIN or something instead?

I don't know.  I am pretty clueless about these things...

But looking again, trying to guess why it works fine if you just ignore
the error. I believe that is because you then end up hitting this until
the interface is fully resumed:

		if (intfdata->suspended) {
			usb_anchor_urb(this_urb, &portdata->delayed);
			spin_unlock_irqrestore(&intfdata->susp_lock, flags);
                }

>> that should not cause the modem to stop working.
>
> Actually it might also be that the network stack ends up in a bad
> state and remains stuck in it. I don't think the modem by itself is
> affected. All I observe is that no network traffic takes place after
> this. I'm not familiar enough with networking to make any stronger
> assumption.

> FWIW, when usb_autopm_get_interface_async() returns -EACCES, the power
> parameters of port->serial->interface->dev are as follows:
>
> disable_depth = 1
> is_suspended = 1
> runtime_status = 2 (RPM_SUSPENDED)

Yes, that makes pm_runtime_get() return -EACCES.

I am way out of my league here, but I wonder if pm_runtime_get()
shouldn't return -EINPROGRESS instead if there is a queued resume
request or an ongoing resume, regardless of disable_depth?

Maybe something like the completely untested:

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 3148b10..38e19ba 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -512,6 +512,9 @@ static int rpm_resume(struct device *dev, int rpmflags)
 	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
 	    && dev->power.runtime_status == RPM_ACTIVE)
 		retval = 1;
+	else if (rpmflags & RPM_ASYNC && dev->power.request_pending &&
+		 dev->power.request == RPM_REQ_RESUME)
+		retval = -EINPROGRESS;
 	else if (dev->power.disable_depth > 0)
 		retval = -EACCES;
 	if (retval)
---
usb_autopm_get_interface_async() will interprete EINPROGRESS as success,
so that would prevent this problem.


Bjørn
