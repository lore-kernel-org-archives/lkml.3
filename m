Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab3CMSw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:52:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54570 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab3CMSw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:52:57 -0400
Date: Wed, 13 Mar 2013 18:52:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
Message-ID: <20130313185249.GL21522@ZenIV.linux.org.uk>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
 <CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
 <20130312222350.GK21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312222350.GK21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:23:50PM +0000, Al Viro wrote:

> I'll post a review tonight or tomorrow.  FWIW, I was not too happy with
> it the last time I looked, but I'll obviously need to reread the whole
> thing.

OK...  Here's the first pass at that:

* use of xattrs for whiteouts/opaque is a Bloody Bad Idea(tm).  That's one
thing you definitely can share with unionmount.  In particular, the games
with creds you have to pull off in ovl_do_lookup() are very clear indications
that xattr is simply a wrong interface for that.

* I don't see anything that would protect you from attacker playing silly
buggers with upper layer; mount it r/w elsewhere and do some renames...
Note that your ->lookup() relies on having the result of ovl_lookup_real()
remain the child of dentry we'd passed it as the first argument.  What's
there to guarantee that it will remain such?  The similar question goes for
malicious modifications of xattrs...  For that matter, what's to prevent
the same sucker mounted as upper layer in two places, with two unrelated lower
layers?  AFAICS, things will break rather badly if that happens, and I'm not
sure if you avoid deadlocks in such scenario...  Interfering with copyup
in progress is also possible.

* I think you might have an unpleasant problem in your ->setattr(); suppose
you've got through the checks in notify_change() and ovl_setattr() got called.
With ATTR_SIZE present.  OK, you do a truncated copyup; fair enough.  But
then you do notify_change() on upper layer dentry to do the rest of the job.
What happens if that fails?  Moreover, what's to prevent it being e.g. opened
by another process *before* you get around to that notify_change() part?

* ->follow_link():  Why the hell do you bother with struct ovl_link_data???
Just to avoid calling ovl_dentry_real() in ovl_put_link()?

BTW, a random note:
        if (err)
                return ERR_PTR(err);

        return NULL;
is a weird way to spell return ERR_PTR(err) - ERR_PTR(0) *is* NULL, TYVM,
and we rely on that in a lot of places.
