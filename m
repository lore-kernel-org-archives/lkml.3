Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557AbaGXT3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:29:46 -0400
Received: from imap.thunk.org ([74.207.234.97]:55169 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705AbaGXT3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:29:44 -0400
Date: Thu, 24 Jul 2014 15:29:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, jack@suse.cz
Subject: Re: Is warn_on() right reply for i/o error?
Message-ID: <20140724192938.GM6673@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, jack@suse.cz
References: <20140724152721.GA4771@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724152721.GA4771@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 05:27:22PM +0200, Pavel Machek wrote:
> Hi!
> 
> Just... I know, I should not be unscrewing hard drive cover while
> operating.
> 
> But on the other hand... WARN_ON() does not sound like right reply for
> a disk failure... right?

Actually, it can be worse than that.  If a hard drive disappears out
from under you while writeback is happening, it's possible to get
crashes in bdi_writeack_workfn() because you can have races between
bdi_unregister() and bdi_writeback_workfn(), since the latter requeues
itself and flush_delayed_work() can return while
bdi_writeback_workfn() is still executing.

This looks like it's a related problem, where the block device gets
unregistered (and this happens in the block device layer without it
telling the file system that the disk drive is about to disappear out
from under it), and occasionally, Bad Stuff Happens.  :-(

     	 	       	   	 	    - Ted

