Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab3HEUXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:23:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35673 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3HEUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:23:52 -0400
Date: Mon, 5 Aug 2013 23:23:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: ozwpan: Increment port number for new
 device.
Message-ID: <20130805202338.GO5051@mwanda>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
 <1375724415-10801-3-git-send-email-rupesh.gujare@atmel.com>
 <20130805175302.GJ5051@mwanda>
 <51FFF244.9000604@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FFF244.9000604@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 07:43:16PM +0100, Rupesh Gujare wrote:
> On 05/08/13 18:53, Dan Carpenter wrote:
> >On Mon, Aug 05, 2013 at 06:40:13PM +0100, Rupesh Gujare wrote:
> >>This patch fixes crash issue when there is quick cycle of
> >>de-enumeration & enumeration due to loss of wireless link.
> >>
> >>It is found that sometimes new device (or coming back device)
> >>returns very fast, even before USB core read out hub status,
> >>resulting in allocation of same port, which results in unstable
> >>system & crash.
> >>
> >>Above issue is resolved by making sure that we always assign
> >>new port to new device, making sure that USB core reads correct
> >>hub status.
> >>
> >This feels like papering over the problem.  Surely the real fix
> >would be to improve the reference counting.
> >
> >This patch is probably effective but it makes the code more subtle
> >and it shows that we don't really understand what we are doing with
> >regards to reference counting.
> >
> >
> 
> Probably this is easier way to fix issue, since we don't have
> reference count for ports & we rely on flags to check port status.
> Any suggestions are appreciated.

To be honest, I wish someone would just go through and make this
look more like kernel style.  It's very ugly to look at.  Even a
very cursory patch series would make a big difference:

[patch 1/6] Add a blank line between declaractions and code.
[patch 2/6] Add a blank line between functions
[patch 3/6] Make oz_hcd_pd_arrived() return a struct pointer (instead of a void pointer)
[patch 4/6] Make oz_hcd_pd_departed() take a struct pointer
[patch 5/6] Swap arguments of oz_ep_alloc() to match kmalloc()
[patch 6/6] Remove unneeded initializers

Also it's better to separate the success path from the failure path
because it means fewer intend levels.  The way oz_hcd_pd_arrived()
looks now it's easy to think we free "ep" but actually we do this
spaghetti thing of setting it to NULL on success.  This function
should just be:

	frob();
	frob();
	ret = frob();
	if (ret)
		goto err_put;
	frob();
	frob();
	ret = frob();
	if (ret)
		goto err_free_ep;
	frob();
	frob();
	put();
	return hport;

err_free_ep:
	free_ep();
err_put:
	put();
	return NULL;

But instead it is:

	frob();
	ret = frob();
	if (ret) {
		unlock();
		goto out;
	}
	frob();
	ret = frob();
	if (ret success) {
		frob();
		frob();
		ep = NULL;
		frob();
		unlock();
		frob();
	} else {
		unlock();
	}
out:
	if (ep)
		free_ep();
	put();
	return something;

In the second example most of the code is indented.  It's so hard
to read because there are unlocks scattered throughout.  Meanwhile,
if you separate success and failure then there are only two unlocks,
one for success and one for failure.

In the current code you have to set "ep" to NULL on the success path
and then test it and or free it.  If you separate them out then it's
obvious that "ep" is not freed on success.

If you separate them out then it's clear that we return NULL on
failure.  In the current code you have to scroll back to the start
of the function.

Obviously it's not an emergency to fix any of these style issues but
it will need to be addressed eventually before it moves out of
staging.  I think as well that just cleaning things up helps to
fix bugs.

regards,
dan carpenter
