Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3DUAGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 20:06:11 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43163 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018Ab3DUAGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 20:06:10 -0400
Date: Sat, 20 Apr 2013 20:05:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mel Gorman <mgorman@suse.de>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130421000522.GA5054@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mel Gorman <mgorman@suse.de>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>
References: <20130402142717.GH32241@suse.de>
 <20130402150651.GB31577@thunk.org>
 <20130410105608.GC1910@suse.de>
 <20130410131245.GC4862@thunk.org>
 <20130411170402.GB11656@suse.de>
 <20130411183512.GA12298@thunk.org>
 <20130411213335.GE9379@quack.suse.cz>
 <20130412025708.GB7445@thunk.org>
 <20130412094731.GI11656@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412094731.GI11656@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As an update to this thread, we brought up this issue at LSF/MM, and
there is a thought that we should be able to solve this problem by
having lock_buffer() check to see if the buffer is locked due to a
write being queued, to have the priority of the write bumped up in the
write queues to resolve the priority inversion.  I believe Jeff Moyer
was going to look into this, if I remember correctly.

An alternate solution which I've been playing around adds buffer_head
flags so we can indicate that a buffer contains metadata and/or should
have I/O submitted with the REQ_PRIO flag set.

Adding a buffer_head flag for at least BH_Meta is probably a good
thing, since that way the blktrace will be properly annotated.
Whether we should keep the BH_Prio flag or rely on lock_buffer()
automatically raising the priority is, my feeling is that if
lock_buffer() can do the right thing, we should probably do it via
lock_buffer().  I have a feeling this might be decidedly non-trivial,
though, so perhaps we should just doing via BH flags?

	   	      	     	  	- Ted
