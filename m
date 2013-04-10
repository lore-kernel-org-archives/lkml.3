Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936197Ab3DJNNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:13:35 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:33192 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab3DJNNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:13:33 -0400
Date: Wed, 10 Apr 2013 09:12:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130410131245.GC4862@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
	Jiri Slaby <jslaby@suse.cz>
References: <20130402142717.GH32241@suse.de>
 <20130402150651.GB31577@thunk.org>
 <20130410105608.GC1910@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410105608.GC1910@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 11:56:08AM +0100, Mel Gorman wrote:
> During major activity there is likely to be "good" behaviour
> with stalls roughly every 30 seconds roughly corresponding to
> dirty_expire_centiseconds. As you'd expect, the flusher thread is stuck
> when this happens.
> 
>   237 ?        00:00:00 flush-8:0
> [<ffffffff811a35b9>] sleep_on_buffer+0x9/0x10
> [<ffffffff811a35ee>] __lock_buffer+0x2e/0x30
> [<ffffffff8123a21f>] do_get_write_access+0x43f/0x4b0

If we're stalling on lock_buffer(), that implies that buffer was being
written, and for some reason it was taking a very long time to
complete.

It might be worthwhile to put a timestamp in struct dm_crypt_io, and
record the time when a particular I/O encryption/decryption is getting
queued to the kcryptd workqueues, and when they finally squirt out.

Something else that might be worth trying is to add WQ_HIGHPRI to the
workqueue flags and see if that makes a difference.

	  	    	   	- Ted
