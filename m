Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaDRA6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:58:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34340 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaDRA6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:58:05 -0400
Date: Fri, 18 Apr 2014 01:58:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15
Message-ID: <20140418005801.GF18016@ZenIV.linux.org.uk>
References: <87zjjp3e7w.fsf@x220.int.ebiederm.org>
 <87ppkl1xb7.fsf@x220.int.ebiederm.org>
 <20140413215242.GP18016@ZenIV.linux.org.uk>
 <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
 <20140417202237.GA18016@ZenIV.linux.org.uk>
 <87tx9rwsz4.fsf@x220.int.ebiederm.org>
 <20140417221203.GC18016@ZenIV.linux.org.uk>
 <20140418003725.GE18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418003725.GE18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 01:37:26AM +0100, Al Viro wrote:
> IOW, workqueue is not the right tool here.  OTOH, it looks like we do have
> a problem with kernel/acct.c vs. umount; it just requires a race between
> auto-closing and acct_process_in_ns().  It's narrow, so it doesn't bite
> us all the time, but it's there...  Damn, it had been a long time since
> I really looked at that code ;-/
> 
> Actually, there's another reason why workqueue is bogus - we call
> do_acct_process(), same as we do on acct(NULL) (which might or might
> not be a good idea), but at least with do that from the context of
> real process doing umount(2).  Doing that from workqueue is going to
> produce a really bogus record...

Egads...  Why the hell are we forming (almost) the same record again
and again for every pidns the process belongs to?  Sure, we want
pid/ppid/uid/gid munged, but the rest of it?

And there's something else wrong here - what happens if the last process
in a namespace where we have accounting going on just plain exits?
All mounts in that namespace get dissolved.  Which leads to acct being
autoclosed.  From the context of a process that already has done
acct_process().

Do we ever want to write an acct record on autoclose-on-umount?  Do we
want that record of umount(8) we would've missed otherwise (along with
those of all other still living processes - those we *will* miss anyway)?

Linus, do you have objections against dropping that behaviour?  In theory,
some tools might look at the last record in acct file to figure out what
has stopped the sucker (accton vs. umount), so it's a user-visible change,
but...
