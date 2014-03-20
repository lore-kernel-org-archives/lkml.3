Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbaCTL36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:29:58 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36041 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaCTL3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:29:55 -0400
MIME-Version: 1.0
In-Reply-To: <532AAE7B.2030501@parallels.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<1395256011-2423-4-git-send-email-dh.herrmann@gmail.com>
	<20140320084748.GK1728@moon>
	<532AAE7B.2030501@parallels.com>
Date: Thu, 20 Mar 2014 12:29:54 +0100
Message-ID: <CANq1E4SLp5Smxf3VbjT0hq0UrWWDf0RxudbQTA1G=sW1ecQk-g@mail.gmail.com>
Subject: Re: [PATCH 3/6] shm: add memfd_create() syscall
From: David Herrmann <dh.herrmann@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Mar 20, 2014 at 10:01 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
> On 03/20/2014 12:47 PM, Cyrill Gorcunov wrote:
>> If I'm not mistaken in something obvious, this looks similar to /proc/pid/map_files
>> feature, Pavel?
>
> It is, but the map_files will work "in the opposite direction" :) In the memfd
> case one first gets an FD, then mmap()s it; in the /proc/pis/map_files case one
> should first mmap() a region, then open it via /proc/self/map_files.
>
> But I don't know whether this matters.

Yes, you can replace memfd_create() so far with:
  p = mmap(NULL, size, ..., MAP_ANON | MAP_SHARED, -1, 0);
  sprintf(path, "/proc/self/map_files/%lx-%lx", p, p + size);
  fd = open(path, O_RDWR);

However, map_files is only enabled with CONFIG_CHECKPOINT_RESTORE, the
/proc/pid/map_files/ directory is root-only (at least I get EPERM if
non-root), it doesn't provide the "name" argument which is very handy
for debugging, it doesn't explicitly support sealing (it requires
MAP_ANON to be backed by shmem) and it's a very weird API for
something this simple.

Thanks
David
