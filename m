Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaCTEV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:21:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42027 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaCTEV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:21:57 -0400
Date: Thu, 20 Mar 2014 04:21:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Max Kellermann <mk@cm4all.com>, max@duempel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/namespace: don't clobber mnt_hash.next while
 umounting [v2]
Message-ID: <20140320042155.GY18016@ZenIV.linux.org.uk>
References: <20140319213754.GA25719@rabbit.intern.cm-ag>
 <20140319213945.25858.14175.stgit@rabbit.intern.cm-ag>
 <20140320034829.GW18016@ZenIV.linux.org.uk>
 <CA+55aFzsD3cvmQN_JFRkiNrQ=0G474_fi0Ki5hCyonxd8vw=pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzsD3cvmQN_JFRkiNrQ=0G474_fi0Ki5hCyonxd8vw=pA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 09:02:33PM -0700, Linus Torvalds wrote:
> Quite frankly, if that's the main issue, then may I suggest aiming to
> use a 'hlist' instead of a doubly-linked list? Those have the
> advantage that they are NULL-terminated.
> 
> Yeah, hlists have some disadvantages too, which might not make them
> work in this case, but really, for mnt_hash? hlists are generally
> *exactly* what you want for hash lists, because the head is smaller.
> And because of the NULL termination rather than having the head used
> in the middle of a circular list, you don't get the termination
> problems when moving entries across chains.
> 
> I did not look whether there was some reason a hlist isn't appropriate
> here. Maybe you can tell me.

Er...  I have, actually, right in the part you've snipped ;-)

<unsnip>
I would prefer to deal with (1) by turning mnt_hash into hlist; the problem
with that is __lookup_mnt_last().  That sucker is only called under
mount_lock, so RCU issues do not play there, but it's there and it
complicates things.  There might be a way to get rid of that thing for
good, but that's more invasive than what I'd be happy with for backports.
</unsnip>

hlist _is_ better, no questions there, but surgery required to deal with
__lookup_mnt_last()[1] is too invasive for backports and even more so -
for -final.  I would prefer to have the merge window happen after LSF/MM,
obviously, but I thought you wanted to open it this Sunday?

[1] that is, with cases like "/tmp/b is a slave of /tmp/a, bind foo on
/tmp/b/c, then bind bar on /tmp/a/c, then umount /tmp/a/c".  The only
kinda-sorta sane semantics we'd been able to come up with is what
we do right now and that's where __lookup_mnt_last() has come from.
