Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab3GZMEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:04:36 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50574 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406Ab3GZMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:04:35 -0400
X-AuditID: 85900ec0-d60ccb900000151e-15-51f265cf4315
Message-ID: <51F265D0.1070405@hitachi.com>
Date: Fri, 26 Jul 2013 21:04:32 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Kazuo Ito <kzpn200@gmail.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, kay@vrfy.org,
        davem@davemloft.net, itoukzo@nttdata.co.jp
Subject: Re: [RESEND RFC PATCH 0/5] Add a hash value for each line in /dev/kmsg
References: <20130725083730.20349.50797.stgit@localhost.localdomain> <CAEBb_QCkTc++pOpv83xdgnZgeUDa1-QK8McY6yqwe2wZN3zt5g@mail.gmail.com>
In-Reply-To: <CAEBb_QCkTc++pOpv83xdgnZgeUDa1-QK8McY6yqwe2wZN3zt5g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2013/07/25 23:56), Kazuo Ito wrote:> Hello,
>
> On Thu, Jul 25, 2013 at 5:37 PM, Hidehiro Kawai <
> hidehiro.kawai.ez@hitachi.com> wrote:
>
>>  .gitignore                        |    1
>>  Makefile                          |    7 +
>>  drivers/base/core.c               |   57 ++-------
>>  drivers/usb/storage/debug.c       |    2
>>  include/asm-generic/vmlinux.lds.h |    5 +
>>  include/linux/device.h            |   73 +++++++----
>>  include/linux/kmsghash.h          |   19 +++
>>  include/linux/printk.h            |   31 ++++-
>>  kernel/printk.c                   |   81 +++++++++---
>>  lib/Kconfig.debug                 |   22 +++
>>  lib/dynamic_debug.c               |    4 -
>>  net/core/dev.c                    |    2
>>  scripts/Makefile                  |    1
>>  scripts/link-vmlinux.sh           |    5 +
>>  scripts/msghash/.gitignore        |    1
>>  scripts/msghash/Makefile          |    7 +
>>  scripts/msghash/msghash.c         |  241
>> +++++++++++++++++++++++++++++++++++++
>>  scripts/msghash/msghash.sh        |   45 +++++++
>>  tools/include/tools/jhash.h       |  192 +++++++++++++++++++++++++++++
>>  19 files changed, 698 insertions(+), 98 deletions(-)
>>  create mode 100644 include/linux/kmsghash.h
>>  create mode 100644 scripts/msghash/.gitignore
>>  create mode 100644 scripts/msghash/Makefile
>>  create mode 100644 scripts/msghash/msghash.c
>>  create mode 100755 scripts/msghash/msghash.sh
>>  create mode 100644 tools/include/tools/jhash.h
>>
>
> As for one that once tried to implement a similar idea (in vein
> at LinuxCon Japan a couple of years ago), I heartily welcome this patch
> while feeling amount of changes might be perceived to be too much,
> requiring some tradeoff analysis with other implementation options.

I agreed.  The current implementation has advantages and drawbacks,
and there are some implementation options.  We have to find a convincing
way.

> This patch precalculates hash values and wraps
> callers of printk around in macros so that it hardly ever
> causes runtime overhead, it could avoid hash collisions
> if needs be, and many creative uses of printk
> can be dealt with, in particular nested formats in %pV,
> which was my downfall... The cost is numbers of required changes.
>
> Calculating hash values in vprink_* would make spreading changes
> across all the printk-derived functions and macros unnecessary,
> but would preclude use of elaborate hash functions and, in cases
> like dev_printk(), would require a way to find or extract
> an appropriate format string. The latter requires complex pattern
> matching, lots of guess-work, has to deal with %pV, and will never
> be perfect.

Actually, in my first prototype implementation (but not published),
hash values are calculated dynamically when vprintk_emit is called.
Changed lines are less than this implementation, and it can also
handle %pV cases.  But as you say, extracting messages and
calculating hashes preliminarily is the difficult part.  I thought
this difficulty will make people not use this feature.  So I took
a way manipulating metadata in printk macros.

Regards,
--
Hidehiro Kawai
Hitachi, Yokohama Research Laboratory
Linux Technology Center

