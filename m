Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3ISMiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:38:21 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58626 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3ISMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:38:20 -0400
Date: Thu, 19 Sep 2013 07:38:12 -0500
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] sysfs: implement sysfs_remove()
Message-ID: <20130919123812.GA4467@mtj.dyndns.org>
References: <1379538938-5032-1-git-send-email-tj@kernel.org>
 <87pps5dr3f.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pps5dr3f.fsf@tw-ebiederman.twitter.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Eric.

On Thu, Sep 19, 2013 at 05:48:52AM -0500, Eric W. Biederman wrote:
> There are two very big problems with this direction.
> 1) It violates the principle of least surprise.  In particular it messes
>    up the mental model of people like Al Viro.  Which can easily lead to
>    code breaking during routine maintenance because of unexpecte
>    semantics.

The interface is already and inherently different from the usual file
removal operation.  If we were to follow the rm semantics, we would
have to fail sysfs_remove_dir() if the node has any child.  The
current behavior is actually more surprising because it creates
dangling child directories - it is neither "rmdir" or "rm -rf".  I
don't think enforcing "rmdir" semantics is useful for sysfs so the
next best thing is to go for "rm -rf".

> 2) Recursive removal is not safe.  There are very weird and somewhat
>    pathological cases where sysfs directories are removed out of order
>    aka parent before sibling, and (if my memory holds) recursive removal
>    takes this from a little bit ugly to actually breaking things.

The case is already handled in the patch series for kobject users.
kobjects just hold an extra ref on sysfs_dirent until it gets
released.  Note that this is something peculiar about kobject based
interface because it has fundamental distinction between "a
sysfs_dirent which has a kobject associated" and the rest, and wants
to treat the former specially.  That is all good and dandy for
kobjects but that logic should stay with kobject.

Also note that the current implementation kinda conflates the
distinction between kobject-associated nodes and others with the
distinction between directories and files.  This used to be okay
because only kobjects could create directories; however, with groups,
this no longer is the case and groups require explicit deletions
although they are not associated with kobjects, which leads
essentially unnecessary boilerplates - just count how many
remove_group calls we have in the tree - and naturally some instances
missing those calls and dangling and leaving those dirents without
anyway to reach them - they don't have kobjects associated with them.

> For long term maintenance and simplicity I believe we will be in much
> better shape if we take directory removal in the opposite direction, and
> fix the small number of issues with the users and don't support any kind
> of recursive removal.

If you're suggesting that we should do "rmdir" semantics, you're
suggesting adding a *LOT* of boilerplate code to *all* users of sysfs,
which is extremely tedious and error-prone in a way which will be
difficult to track down.  We need to make it easier to use, not the
other way around.

I think all this mostly comes from the way we conjoined kobject and
sysfs and then getting confused about the distinction between kobjects
and directories.  The only special thing we need for kobject handling
is allowing parent kobjects to be removed before its descendants as
kobjects lifetime rules are weird and doesn't enforce any ordering
according to its hierarchical organization, but if you put that one
aside, we actually do want recursive removal.  You never want to
require the destruction paths tedious.  That always leads to
wide-spread bugs.

Thanks.

-- 
tejun
