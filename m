Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3CKVfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:35:24 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52651 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3CKVfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:35:22 -0400
Date: Mon, 11 Mar 2013 17:35:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Bryan Whitehead <driver@megahappy.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4 change in v3.3-rc2 broke user space
Message-ID: <20130311213520.GE15478@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Bryan Whitehead <driver@megahappy.net>,
	linux-kernel@vger.kernel.org
References: <CAA3XVTxhXqo5vJmUjmN1_GPZvftVoNcYGKm1WaVOJTuz3jMNqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA3XVTxhXqo5vJmUjmN1_GPZvftVoNcYGKm1WaVOJTuz3jMNqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 02:03:51PM -0700, Bryan Whitehead wrote:
> 
> The change is about a year old now but it is finally making its way
> into distribution binaries. As a user it sucks because "ext4" the
> "stable" fs basically breaks. Fortunately for myself I've used xfs as
> suggested by GlusterFS (older versions stated ext4/ext3 was fine).
> However, there are many installs (particularly older installs) that
> used ext4 and are finding they must now run outdated old kernels until
> they can completely reinstall their gluster cluster with non-ext4
> underlying filesystems.

GlusterFS is doing something fundamentally buggy; it is assuming that
high bits of the value returned "telldir" are zero.  This is
inherently non-portable.  This change was used to avoid hash collision
causing problems for applications using telldir/seekdir() on very
large file systems.

So the question was whether it was important to fix a bug for well
behaved, non-buggy applications, or to not fix this bug to accomodate
a buggy application (namely, Gluster).

There were some questions going back and forth about whether Gluster
could work around this non-potable, buggy use of telldir()/seekdir(),
and that's why nothing had been done for a while.

What we'll probably do to accomodate Gluster is to create a new
ext4-specifical ioctl(), which allows the process to get the old
telldir cookie format (i.e., EXT4_IOC_IM_A_BUGGY_APPLICATION :-).

						- Ted
