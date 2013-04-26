Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3DZRbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 13:31:08 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35659 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814Ab3DZRbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 13:31:05 -0400
Message-ID: <1366997459.16829.4.camel@dabdike>
Subject: Re: [PATCH RESEND^2] sd: fix infinite kernel/udev loop on
 non-removable Medium Not Present
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 26 Apr 2013 10:30:59 -0700
In-Reply-To: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
References: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 11:39 -0500, Steven J. Magnani wrote:
> Commit eface65c336eff420d70beb0fb6787a732e05ffb (2.6.38) altered
> set_media_not_present() in a way that prevents the sd driver from
> remembering that a non-removable device has reported "Medium Not Present".
> This condition can occur on hotplug of a (i.e.) USB Mass Storage device
> whose medium is offline due to an unrecoverable controller error,
> but which is otherwise capable of SCSI communication (to download new 
> microcode, etc.).

This actually sounds to be a bug somewhere in the device.  Only
removable devices are supposed to signal medium not present.

> Under these conditions, the changed code results in an infinite loop
> between the kernel and udevd. When udevd attempts to open the device
> in response to a change notification, a SCSI "Medium Not Present" error
> occurs which causes the kernel to signal another change. The cycle
> repeats until the device is unplugged, resulting in udevd consuming ever-
> increasing amounts of CPU and virtual memory.
> 
> Resolve this by remembering "media not present" whether the device has
> declared itself "removable" or not.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> --- a/drivers/scsi/sd.c	2013-04-12 14:16:12.252531097 -0500
> +++ b/drivers/scsi/sd.c	2013-04-12 14:21:55.197216521 -0500
> @@ -1298,10 +1298,8 @@ out:
>  
>  static void set_media_not_present(struct scsi_disk *sdkp)
>  {
> -	if (sdkp->media_present)
> +	if (sdkp->media_present) {
>  		sdkp->device->changed = 1;
> -
> -	if (sdkp->device->removable) {
>  		sdkp->media_present = 0;
>  		sdkp->capacity = 0;

I don't really like this change because it will affect TUR failure as
well, which looks like it would then zero the capacity of a
non-removable device which we aren't expecting.  Can we dig into what's
going wrong with the device first.  It sounds like it really is a
removable device and it just needs to be flagged that way (either that
or the USB SAT is so screwed up that we might need to apply other
blacklists)

James


