Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab3IDCAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:00:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55598 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934083Ab3IDCAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:00:15 -0400
Date: Wed, 4 Sep 2013 03:00:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, rui.xiang@huawei.com,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] autofs4 - fix device ioctl mount lookup
Message-ID: <20130904020013.GF13318@ZenIV.linux.org.uk>
References: <20130904005456.5025.94309.stgit@perseus.fritz.box>
 <20130904010301.GE13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904010301.GE13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 02:03:02AM +0100, Al Viro wrote:

> Ewwww...   NAK in that form.  Just what will happen if the last component
> given to that sucker will be . or .., for starters?  Or a symlink, with
> '/' added to it to force following the damn thing?

OK, in more details:
	* we are changing a user-visible ABI here - kern_path() with
LOOKUP_FOLLOW had been there since the introduction of that misc
device (OK, it used to be path_lookup(), but that changes nothing).
IOW, we used to follow symlinks there, now we do not.
	* pathname may end on more than one slash.  Modified that
way, the code won't do anything good (not to mention that d_lookup()
on an empty string is an interesting torture test for fs/dcache.c;
probably you'll just find nothing, but normally the function is never
called with such arguments, so...).  In any case it's an ABI change.
	* pathname may end with something/. or something/..; again,
d_lookup() won't find you anything now, so we have an ABI change.

That aside, I'm really not happy with this kind of games; this stuff clearly
belongs in fs/namei.c where we can simply see the last component.  Doing that
on the level of "let's scan the pathname for slashes, etc." is just plain
wrong.  Let's step back for a minute here; what are you trying to do?
You have a pathname that should resolve to a mountpoint, without triggering
automount (or crossing into the mountpoint, for that matter) and you want
struct path for the bottom of that mount stack?  Or is it something
completely different?
