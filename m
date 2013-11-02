Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3KBA37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 20:29:59 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53687 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3KBA36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 20:29:58 -0400
MIME-Version: 1.0
From: Jason Cipriani <jason.cipriani@gmail.com>
Date: Fri, 1 Nov 2013 20:29:26 -0400
Message-ID: <CAF1GSti2xbHGtBx4Qq8Br9unEM_GE8GJ99fzoRm6qKaun7MHZw@mail.gmail.com>
Subject: Correct parameter size for BLKSSZGET ioctl.
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In blkdiscard in util-linux, at least since version 2.23, the
following code is used to retrieve a device's physical sector size:

  uint64_t secsize;
  ioctl(fd, BLKSSZGET, &secsize);

On my machine (Ubuntu 12.04 -- 3.2.0-55-generic-pae #85-Ubuntu SMP Wed
Oct 2 14:03:15 UTC 2013 i686 i686 i386 GNU/Linux) this yields
incorrect results as it seems a 32-bit int is expected, this causes
subsequent sector alignment calculations in blkdiscard to be
incorrect, which in turn causes blkdiscards trim ioctl's to fail in
certain situations (or even worse, to trim the wrong blocks).

I have seen BLKSSZGET implemented in two places. In block/ioctl.c it
is implemented using put_int
(http://lxr.free-electrons.com/source/block/ioctl.c#L365) which works
on an "int" (which doesn't actually have a fixed size -- it is defined
by the particular C compiler). In block/compat_ioctl.c it is
implemented using compat_put_int, which ultimately operates on a
compat_int_t, which, for all platforms I looked at, is explicitly
defined to be a 32-bit type (e.g. "typedef s32 compat_int_t").

My goal is to determine if blkdiscard is incorrectly using a uint64_t,
or if the Ubuntu kernel is incorrectly using some 32-bit type.
Therefore I would like to know precisely what parameter ioctl 0x1268
(BLKSSZGET) is specified to take.

My question, then, is where is this specified? Currently I have only
found scattered implementations (many using the vague "int") of
ioctl.c and compat_ioctl.c, uncommented header declarations (e.g.
fs.h), and anecdotal evidence and claims.

In other words: What is the parameter size for BLKSSZGET and, more
importantly, *how do you know that*? Is blkdiscard broken, or is my
kernel's implementation broken? If I wrote a device driver that
supported this ioctl, what data type would I use? Surely at some point
in the past somebody decided that 0x1268 would retrieve the physical
sector size of a device, and documented that somewhere.

Please CC me on replies; I am not subscribed to this list.

Thanks,
Jason
