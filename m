Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaDQUXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:23:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33371 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaDQUWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:22:45 -0400
Date: Thu, 17 Apr 2014 21:22:37 +0100
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
Message-ID: <20140417202237.GA18016@ZenIV.linux.org.uk>
References: <87fvlm860e.fsf_-_@x220.int.ebiederm.org>
 <20140409232423.GB18016@ZenIV.linux.org.uk>
 <87lhva5h4k.fsf@x220.int.ebiederm.org>
 <20140413053956.GM18016@ZenIV.linux.org.uk>
 <87zjjp3e7w.fsf@x220.int.ebiederm.org>
 <87ppkl1xb7.fsf@x220.int.ebiederm.org>
 <20140413215242.GP18016@ZenIV.linux.org.uk>
 <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you tried to profile something like umount -l on a large mount tree?
You variant causes a shitstorm of
	schedule work
	switch to workqueue
	do actual fs shutdown
	wake umount(8) up
	get through wait_for_completion()
for every bleeding vfsmount in there.  And no, it's *not* guaranteed to
be dominated by fs shutdown time.  Here's the case where it definitely
won't be:
	mkdir /tmp/a
	mount --rbind / /tmp/a
	umount -l /tmp/a

All vfsmounts involved are killed off with no fs shutdown.  And that's
*not* a rare case - exit of the last process in namespace is very likely
to look that way too.

That's far too heavy.
