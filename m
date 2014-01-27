Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaA0Qmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:42:46 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:51732 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaA0Qmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:42:44 -0500
Date: Mon, 27 Jan 2014 10:39:39 -0600
From: Andrew Ruder <andy@aeruder.net>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] reproducable ubifs reboot assert and corruption
Message-ID: <20140127163939.GA27809@gmail.com>
Mail-Followup-To: Richard Weinberger <richard.weinberger@gmail.com>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20140122051510.GB17284@gmail.com>
 <CAFLxGvwmzftdQKSjjjwpFLS8g3EJqMrQ2gU2scBsh2MvG7Wyyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwmzftdQKSjjjwpFLS8g3EJqMrQ2gU2scBsh2MvG7Wyyw@mail.gmail.com>
User-Agent: Mutt/1.5.21+155 (d3096e8796e7) (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 04:02:15PM +0100, Richard Weinberger wrote:
> So ubifs_bgt0_0 stops and the fun begins.
> Can you trigger the issue also by unmounting /mnt?
> I.e umount -l /mnt
> The background thread should only stop after all io is done...

Did some experiments last week to see if I could trigger the bug with
full debug messages enabled.  Biggest problem is that I don't have
non-volatile memory available, serial logging slows it down too much to
trigger the bug, and the reboot tends to shut down any attempt to
offload the log to capture the relevant messages.

That being said, I was able to trigger the bug with the following:

[root@buildroot ~]# (sleep 5 ; while ! mount -o remount,ro /mnt ; do true ; done ; echo remount > /dev/kmsg ; sleep 5 ; echo reboot > /dev/kmsg ; reboot ) &
[2] 564
[root@buildroot ~]# fsstress -p 10 -n 10 -X -d /mnt/fsstress -l 0

In my log I can see the "remount" message and 100ms later I can see the
first ubifs assert.  I've attached the relevant portion of the logs
below from the first time I see LEB 44 mentioned through the asserts.
I've put the logs on the web due to concerns of flooding the mailing
list with 100's of kB in attachments.

https://gist.github.com/aeruder/8651928

ubi_corruption.txt is the kernel log
afterwards.txt is the console log with the ensuing issue with ubifs

I also have logs of the recovery process in the Linux kernel later on,
(still takes 2 mounts), an image of the MTD device, and would be happy
to try anything or enable any additional debug messages.

> Can you also please find out whether fssstress is still running when
> reboot takes action?

Thanks for taking a look.  I'm reading everything I can find about ubifs
to see if I can make some headway into understanding what is going on
but filesytems are definitely not my forte :).

Cheers,
Andrew Ruder
