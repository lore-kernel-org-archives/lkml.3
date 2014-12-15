Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaLOVdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:33:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45273 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaLOVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:33:15 -0500
Date: Mon, 15 Dec 2014 21:33:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.18 15/19] move d_rcu from overlapping d_child to
 overlapping d_alias
Message-ID: <20141215213312.GV22149@ZenIV.linux.org.uk>
References: <20141214201823.543296369@linuxfoundation.org>
 <20141214201823.978185416@linuxfoundation.org>
 <20141215154650.GA6542@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215154650.GA6542@vader>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:46:50AM -0500, Josh Boyer wrote:
> On Sun, Dec 14, 2014 at 12:21:26PM -0800, Greg Kroah-Hartman wrote:
> >3.18-stable review patch.  If anyone has any objections, please let me know.
> >
> >------------------
> >
> >From: Al Viro <viro@zeniv.linux.org.uk>
> >
> >commit 946e51f2bf37f1656916eb75bd0742ba33983c28 upstream.
> >
> >Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> >Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I noticed you don't have this (and the child commit) queued for 3.17.y.
> The backport wasn't exactly straight-forward because of the d_external
> stuff, but I took a swing at it.  After that, the other commit was a
> quick cherry-pick.
> 
> Al, does the below look correct for a backport on top of 3.17.6?  It
> builds, but I haven't tested it yet.

-       WARN_ON(!hlist_unhashed(&dentry->d_alias));
+       WARN_ON(!hlist_unhashed(&dentry->d_u.d_alias));
i

in __d_free() is definitely *not* correct - where do you think has __d_free
address come from?  Right, dentry->d_u.d_rcu.func...  Those checks belong
in dentry_free(), before call_rcu() is called...
