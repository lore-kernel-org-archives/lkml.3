Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217Ab3IDHEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab3IDHEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:04:10 -0400
Message-ID: <1378278241.26292.60.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH 4/5] uas: add dead request list
From: Gerd Hoffmann <kraxel@redhat.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:USB ATTACHED SCSI" <linux-scsi@vger.kernel.org>,
        "open list:USB MASS STORAGE..." 
	<usb-storage@lists.one-eyed-alien.net>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 04 Sep 2013 09:04:01 +0200
In-Reply-To: <20130903173908.GA4965@xanatos>
References: <1378121129-32594-1-git-send-email-kraxel@redhat.com>
	 <1378121129-32594-5-git-send-email-kraxel@redhat.com>
	 <20130903173908.GA4965@xanatos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 2013-09-03 at 10:39 -0700, Sarah Sharp wrote:
> Don't you need to send an ABORT TASK message to the device to cancel the
> outstanding request for that stream ID?  I don't see that in this code.
> I see lots of URB cancellation code, but nothing to remove the request
> from the device-side queue.

It is there.  uas_eh_abort_handler() cancels a single request.  There is
also uas_eh_device_reset_handler() which will try a LOGICAL UNIT RESET.

Those might not work though, depending on the failure mode.  If your
usb3 streams stop working you can't cancel scsi requests that way.

> Or does it simply ensure that SCSI bus reset works?

The scsi layer invokes the uas_eh_bus_reset_handler() as last resort,
when everything else fails.  So, yes, there we'll have the sledge hammer
approach to recover: cancel all usb urbs, abort all requests, full usb
device reset + re-initialization.  But we hardly have another chance
when the less invasive methods to cancel a requests didn't work ...

> Plus, as Joe mentioned, this code is full of BUG_ON(), which is not
> friendly to users, and doesn't increase my confidence that the driver is
> ready to have CONFIG_BROKEN removed.

Huh?  Why you are thinking BUG_ON() is a indicator for bad code quality?
I'm using BUG_ON() like assert() in userspace, i.e. they are extra
sanity checks which should never ever trigger.

I can switch them to less disruptive WARN_ON() if that is the preferred
way these says.

cheers,
  Gerd


