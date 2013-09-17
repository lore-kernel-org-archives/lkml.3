Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3IQCkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 22:40:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56937 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3IQCkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 22:40:42 -0400
Date: Tue, 17 Sep 2013 03:40:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Aditya Kali <adityakali@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        anatol@google.com
Subject: Re: [RFC] vfs: avoid sb->s_umount lock while changing bind-mount
 flags
Message-ID: <20130917024040.GH13318@ZenIV.linux.org.uk>
References: <1379353350-11320-1-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379353350-11320-1-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 10:42:30AM -0700, Aditya Kali wrote:
> During remount of a bind mount (mount -o remount,bind,ro,... /mnt/mntpt),
> we currently take down_write(&sb->s_umount). This causes the remount
> operation to get blocked behind writes occuring on device (possibly
> mounted somewhere else). We have observed that simply trying to change
> the bind-mount from read-write to read-only can take several seconds
> becuase writeback is in progress. Looking at the code it seems to me that
> we need s_umount lock only around the do_remount_sb() call.
> vfsmount_lock seems enough to protect the flag change on the mount.
> So this patch fixes the locking so that changing of flags can happen
> outside the down_write(&sb->s_umount).

What's to prevent mount -o remount,ro /mnt and mount -o remount,rw,nodev /mnt
racing and ending up with that sucker rw and without nodev?  As for
lock_mount... nope - we carefully do *not* hold namespace_sem over any kind
of fs operations.  Anything getting stuck while holding it will have
really nasty consequences.

So ->s_umount here is inelegant, but alternatives sucks worse...
