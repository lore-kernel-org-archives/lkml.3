Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422896Ab3DFNQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:16:03 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59791 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422801Ab3DFNQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:16:00 -0400
Date: Sat, 6 Apr 2013 09:15:14 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130406131514.GB7816@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jiri Slaby <jslaby@suse.cz>, Mel Gorman <mgorman@suse.de>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linux-MM <linux-mm@kvack.org>
References: <20130402142717.GH32241@suse.de>
 <20130402150651.GB31577@thunk.org>
 <20130402151436.GC31577@thunk.org>
 <20130403101925.GA7341@suse.de>
 <515F4DA3.2000000@suse.cz>
 <20130405231635.GA6521@thunk.org>
 <515FCEEC.9070504@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515FCEEC.9070504@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 09:29:48AM +0200, Jiri Slaby wrote:
> 
> I'm not sure, as I am using -next like for ever. But sure, there was a
> kernel which didn't ahve this problem.

Any chance you could try rolling back to 3.2 or 3.5 to see if you can
get a starting point?  Even a high-level bisection search would be
helpful to give us a hint.

>Ok,
>  dd if=/dev/zero of=xxx
>is enough instead of "kernel update".

Was the dd running in the VM or in the host OS?  Basically, is running
the VM required?

> Nothing, just VM (kernel update from console) and mplayer2 on the host.
> This is more-or-less reproducible with these two.

No browser or anything else running that might be introducing a stream
of fsync()'s?

>     jbd2/sda5-8-10969 [000] ....   403.679552: jbd2_run_stats: dev
>259,655360 tid 348895 wait 0 request_delay 0 running 5000 locked 1040
>flushing 0 logging 112 handle_count 148224 blocks 1 blocks_logged 2

>      jbd2/md2-8-959   [000] ....   408.111339: jbd2_run_stats: dev 9,2
>tid 382991 wait 0 request_delay 0 running 5156 locked 2268 flushing 0
>logging 124 handle_count 5 blocks 1 blocks_logged 2

OK, so this is interesting.  The commit is stalling for 1 second in
the the transaction commit on sda5, and then very shortly thereafter
for 2.2 seconds on md2, while we are trying to lock down the
transaction.  What that means is that we are waiting for all of the
transaction handles opened against that particular commit to complete
before we can let the transaction commit proceed.

Is md2 sharing the same disk spindle as sda5?  And to which disk were
you doing the "dd if=/dev/zero of=/dev/XXX" command?

If I had to guess what's going on, the disk is accepting a huge amount
of writes to its track buffer, and then occasionally it is going out
to lunch trying to write all of this data to the disk platter.  This
is not (always) happening when we do the commit (with its attended
cache flush command), but in a few cases, we are doing a read command
which is getting stalled.  There are a few cases where we start a
transaction handle, and then discover that we need to read in a disk
block, and if that read stalls for a long period of time, it will hold
the transaction handle open, and this will in turn stall the commit.

If you were to grab a blocktrace, I suspect that is what you will
find; that it's actually a read command which is stalling at some
point, correlated with when we are trying to start transaction commit.

       		       	       	   	     - Ted
