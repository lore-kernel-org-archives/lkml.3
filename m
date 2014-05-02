Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaEBXG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 19:06:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32901 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaEBXG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 19:06:56 -0400
Date: Sat, 3 May 2014 00:06:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140502230653.GK18016@ZenIV.linux.org.uk>
References: <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
 <20140502055127.GH18016@ZenIV.linux.org.uk>
 <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
 <20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
 <20140502224022.GJ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502224022.GJ18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 11:40:22PM +0100, Al Viro wrote:
> On Fri, May 02, 2014 at 02:18:43PM -0700, Linus Torvalds wrote:
> > On Fri, May 2, 2014 at 2:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > There's more of the "delete from shrink list not owned by us" in select parent.
> > > Proposed patch appended.
> > 
> > Ahh. Clearly this needs more work before I pull.
> 
> *nod*
> 
> Besides, I want to put Miklos' "don't bother with RCU in shrink_dentry_list()"
> in there as soon as select_collect() has been dealt with.  I don't think
> that the currently posted patch for select_collect() is right, though -
> see my reply to parent posting.  Basically, I think we should treat "it's
> on the shrink list already" as "increment data->found and keep going".  IOW,
> 	if (on shrink list) {
> 		data->found++;
> 	} else {
> 		if (on lru list)
> 			d_lru_del
> 		if (refcount is zero) {
> 			d_shrink_add
> 			data->found++;
> 		}
> 	}
> 	if (data->found)
> 		ret = need_resched() ? D_WALK_QUIT : D_WALK_NORETRY;

While we are at it - BUG() in umount_collect() is probably a bad idea.
At that point we are holding ->s_umount, so it guarantees that a lot
of stuff from that point on will get stuck.  Starting with sync(2).
And I really doubt that damage from WARN() instead will be more...
