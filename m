Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095AbaGZIZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:25:01 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55358 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaGZIY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:24:58 -0400
X-Originating-IP: 78.210.48.61
Date: Sat, 26 Jul 2014 10:24:32 +0200
From: Guillaume =?iso-8859-1?Q?CL=C9MENT?= <gclement@baobob.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Guillaume Clement <gclement@baobob.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: vt6655: fix direct dereferencing of user pointer
Message-ID: <20140726082429.GA3121@pleinair.baobob.org>
References: <20140725123301.GZ13737@mwanda>
 <1406292443-11734-1-git-send-email-gclement@baobob.org>
 <53D2E3BD.1000208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D2E3BD.1000208@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Malcolm,

On Sat, Jul 26, 2014 at 12:09:49AM +0100, Malcolm Priestley wrote:
> Hi Guillaume
>
> On 25/07/14 13:47, Guillaume Clement wrote:
> > Sparse reported that the data from tagSCmdRequest is given by
> > userspace, so it should be tagged as such.
> extra is not in user space
>

All right.

This is still confusing to me because, taking the SIOCSIWGENIE ioctl as
an example, in device_main.c, we have this code:

rc = iwctl_siwgenie(dev, NULL, &(wrq->u.data), wrq->u.data.pointer);

Here the extra parameter is the last one, wrq->u.data.pointer.

I was led to believe that wrq->u.data.pointer is in userspace (this was
reported by sparse actually) because the pointer field in data is
actually defined as __user.


I can understand it's not though, if it was pre-processed by another
function. Or if that pointer was never given by userspace in the first
place (if so, why would it be inside a __user pointer) ?


> All Wireless Extensions ioctl extra calls originate from
> ioctl_standard_iw_point in wext-core.
>
> Either through ioctl or iw_handler

After digging into the code a bit more, I think that there may still be
an issue. Are we really going through ioctl_standard_iw_point in this
specific case ?

In the iwctl_handler definition, we have no handler because of:

   (iw_handler) NULL,                   // SIOCSIWGENIE


In the wireless_process_ioctl function, the returned handler should be
NULL if I understand correctly. I believe we're going through the "old
API" part with ndo_do_ioctl being called, which is consistent with the
fact that the code I showed earlier comes from that big switch in
device_ioctl in device_main.c.

This means we don't go to ioctl_standard_call, that would have called
ioctl_standard_iw_point, the function that should have done the
copy_from_user.

I didn't see a copy_from_user of the pointer field in the paths that I
think lead to device_ioctl in device_main.c.



Maybe the proper fix should have been to copy the content of
wrq->u.data.pointer to some buffer before calling iwctl_siwgenie, and
let this function not taking __user data?

This way, the driver is still ready to be converted to iw_handler
because it keeps the proper signature.


> All these functions should have been converted to iw_handler.

Yes certainly, but with no access to the real hardware for testing, I'd
rather not make deep changes like this for now.
