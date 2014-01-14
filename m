Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaANXJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:09:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaANXJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:09:25 -0500
Date: Tue, 14 Jan 2014 15:10:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging: comedi: convert while loop to timeout in
 ni_mio_common.c
Message-ID: <20140114231003.GB7877@kroah.com>
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
 <1389735061-24626-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389735061-24626-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:31:01PM -0600, Chase Southwood wrote:
> This patch to ni_mio_common.c changes a simple while loop to a timeout,
> which is preferred.
> 
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 
> I removed the extra counter variable this time.  Greg, you mentioned that I could just look at the time that has expired to far, and exit and error out if that exceeds a limit.  Right now I'm just tracking how many times udelay is called, since that seems to conform more to other timeouts in this file, but did you instead want me to use some time function to keep track of actual real time that expires?

Please wrap your lines of text, as that's one very long line :)

The best way to do this is to do:
	unsigned long timeout;
	...
	timeout = jiffies + msec_to_jiffies(500);	/* Or how ever long you want to wait */
	do {
		do something...
		udelay(10);
	} while (time_before(jiffies, timeout);

	or switch the loop around and do:

	while (something hasn't happened) {
		if (time_after(jjiffies, timeout)) {
			we timed out, handle it here;
			break;
		}
		udelay(10);
	}

That's much better than having to count up a "number" and have to look
to see how long you are sleeping for to determine just exactly how long
you are going to have until the loop times out, as your code did.

Make sense?

greg k-h
