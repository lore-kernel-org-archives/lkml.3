Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbbAVM0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:26:48 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:45969 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbAVM0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:26:45 -0500
Date: Thu, 22 Jan 2015 07:26:40 -0500
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122122640.GA25645@htj.dyndns.org>
References: <20150121171953.823177070@goodmis.org>
 <20150121230007.GA10389@kroah.com>
 <20150122042330.GU29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122042330.GU29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al.

On Thu, Jan 22, 2015 at 04:23:30AM +0000, Al Viro wrote:
> I would recommend against that - kernfs is overburdened by their need to
> accomodate cgroup weirdness.  IMO it's not a good model for anything, other

That's not true.  The two big items where sysfs is complicated are the
custom revocation implementation and namespace support, both of which
come from its sysfs lineage.  The revocation implementation had an
update to better support cgroup but the new interface is more generic
than before and necessary if it wants to support self-removing files
along with the said revocation support.

One complexity actually added for cgroup is in the mount path because
cgroup needs to be able to create or match superblocks dynamically
during mount time and that doesn't really jive well with how
superblocks are managed in the vfs layer.  This part is ugly and
intentially left that way.  This really should be cgroup specific (and
we can't shed it at the moment) and shouldn't be used elsewhere.
IIRC, you had some complaints about this and I wonder whether that's
what shaped your opinion, but this is entirely isolated.  Just use
kernfs_mount() and ignore the @new_fs_created param.

Overall, kernfs is basically the actual filesystem part of sysfs.
None of the fundamentals changed while separating out kernfs out of
sysfs.  You may not like kernfs but then wouldn't improving it a far
better strategy over long haul?  I really don't think we need yet
another pseudo vfs based filesystem in kernel and unless tracingfs is
doing something crazy kernfs should be able to serve as a common
foundation.

Thanks.

-- 
tejun
