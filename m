Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaLABJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:09:12 -0500
Received: from gardel.0pointer.net ([85.214.157.71]:43464 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaLABJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:09:10 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Nov 2014 20:09:10 EST
Date: Mon, 1 Dec 2014 02:03:43 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Richard Weinberger <richard@nod.at>
Cc: Dave Chinner <david@fromorbit.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        "systemd-devel@lists.freedesktop.org" 
	<systemd-devel@lists.freedesktop.org>
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
Message-ID: <20141201010343.GB18495@gardel-login>
References: <1416958612-7448-1-git-send-email-richard@nod.at>
 <20141130205430.GD16151@dastard>
 <547B8731.90305@nod.at>
 <20141201001849.GJ9561@dastard>
 <547BB929.3020805@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547BB929.3020805@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01.12.14 01:41, Richard Weinberger (richard@nod.at) wrote:

> CC'ing systemd folks.
> 
> Lennart, can you please explain why you need CONFIG_FHANDLE for systemd?
> Maybe I'm reading the source horrible wrong.

For two usecases:

a) Being able to detect if something is a mount point. The traditional
   way to do this is by stat()ing the dir in question and its parent
   and comparing st_dev. That logic is not able to detect bind mounts
   however, if destination and the place the mount is at are actually
   on the same file system... Thus we check the mount id too, if we
   can get our hands on it. This actually fixes real-life
   problems. For example time-based recursive clean-up logic in /tmp,
   where it is desirable that the clean up stops at
   submounts. However, we had reports where the clean-up fucked up
   people's home directories because they mounted them for some reason
   into some subdir in /tmp and they had /tmp and /home on the same
   fs.

b) Because we sometimes want to know the mount options used for
   specific file systems. For that you want to correlate
   /proc/self/mountinfo with a path in the fs. You can of course try
   to do path prefix matching and then fuck things up as soon as
   people do weird mounts on top of each other. Or you can use use the
   mount id name_to_handle tells you and look it up in
   /proc/self/mountinfo, and everything is clean and reliable.

We have no interest in the actual fhandle data. If you give us some
other syscall to figure out the mount id, we'd be delighted to use it
instead.

udev uses the logic described in b) to determine if /dev is a devtmpfs
instance. Since devtmpfs has the same fs magic as any other tmpfs we
cannot use the statfs() magic stuff to detect this case.

Lennart
