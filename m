Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3DLUxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:53:30 -0400
Received: from mx2.parallels.com ([199.115.105.18]:49254 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3DLUx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:53:29 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Steve Magnani <smagnani@iscandar.digidescorp.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: Re: [PATCH] sd: fix infinite kernel/udev loop on non-removable
 Medium Not Present
Thread-Topic: [PATCH] sd: fix infinite kernel/udev loop on non-removable
 Medium Not Present
Thread-Index: AQHON7+Yb22uKvpaL0m/J3KOnRYfupjThWmA
Date: Fri, 12 Apr 2013 20:53:27 +0000
Message-ID: <1365800007.1934.67.camel@dabdike>
References: <1365799488-16088-1-git-send-email-smagnani@iscandar.digidescorp.com>
In-Reply-To: <1365799488-16088-1-git-send-email-smagnani@iscandar.digidescorp.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.18.112.117]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <B04799218440DD4E93EDDD48A20D7717@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you resend this, cc'ing the linux-scsi@vger.kernel.org mailing
list?

Thanks,

James


On Fri, 2013-04-12 at 15:44 -0500, Steve Magnani wrote:
> Commit eface65c336eff420d70beb0fb6787a732e05ffb (2.6.38) altered
> set_media_not_present() in a way that prevents the sd driver from
> remembering that a non-removable device has reported "Medium Not Present".
> This condition can occur on hotplug of a (i.e.) USB Mass Storage device
> whose medium is offline due to an unrecoverable controller error,
> but which is otherwise capable of SCSI communication (to download new 
> microcode, etc.).
> 
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
>  	}
> 

