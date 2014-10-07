Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaJGNdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:33:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45542 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaJGNdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:33:41 -0400
Date: Tue, 7 Oct 2014 14:33:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Andrey Vagin <avagin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Message-ID: <20141007133339.GH7996@ZenIV.linux.org.uk>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <20141007133039.GG7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007133039.GG7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:30:40PM +0100, Al Viro wrote:
> On Tue, Oct 07, 2014 at 04:12:57PM +0400, Andrey Vagin wrote:
> > Another problem is that rootfs can't be hidden from a container, because
> > rootfs can't be moved or umounted.
> 
> ... which is a bug in mntns_install(), AFAICS.

Ability to get to exposed rootfs, that is.

> > Here is an example how to get access to rootfs:
> > fd = open("/proc/self/ns/mnt", O_RDONLY)
> > umount2("/", MNT_DETACH);
> > setns(fd, CLONE_NEWNS)
> > 
> > rootfs may contain data, which should not be avaliable in CT-s.
> 
> Indeed.

... and it looks like the above is what your mangled reproducer in previous
patch had been made of -
	fd = open("/proc/self/ns/mnt", O_RDONLY)
	umount2("/", MNT_DETACH);
	setns(fd, CLONE_NEWNS)
	umount2("/", MNT_DETACH);

IMO what it shows is setns() bug.  This "switch root/cwd, no matter what"
is wrong.
