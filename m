Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbbAKPpD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 10:45:03 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:59181 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbbAKPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 10:45:00 -0500
MIME-Version: 1.0
In-Reply-To: <20150109230254.GA3528@kroah.com>
References: <20141204232951.GA13690@kroah.com> <1417754274-29769-1-git-send-email-tomvanbraeckel@gmail.com>
 <20150109230254.GA3528@kroah.com>
From: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Date: Sun, 11 Jan 2015 16:44:19 +0100
Message-ID: <CAJ7vePD63YK3vfF40efV7CxKKJiRaeCY5tD4UsEOgn8MJY9ONw@mail.gmail.com>
Subject: Re: [PATCH] misc: pass miscdevice through file's private_data
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        samu.p.onkalo@nokia.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Wait, didn't this break FUSE?  Or was that some other variant of this
> patch?

You're right. How come I missed this?

I traced back my steps and as stated, I had reviewed all relevant code in the
"drivers" folder. And therein lies the problem: I didn't think of reviewing the
code in the "fs" folder, hence I missed fuse. I also went over the history of
misc.c, but I used the default "git log", which pruned the reverted commits,
while I should have used git log --full-history.

I'm sorry I missed this... and I'm not giving up :-)

I spent the whole day re-doing the investigation, checking *all* relevant code
this time. The code in arch, fs, lib, net and virt uses misc_register, but most
code is safe because it either registers a custom open() file operation or it
doesn't rely on private_data being initialized to NULL when it didn't.

And yes, I did find *one* additional case that is affected; btrfs' transaction
starting and stopping ioctl code in fs/btrfs/super.c uses private_data to store
the transaction, and relies on the fact that it is NULL initially. This only
works because btrfs doesn't register a custom open() file operation for this
device file.

I'm currently testing out patches to make fuse and btrfs independent of this
subtle behavior of the misc subsystem. I'll send my patches to the fuse and
btrfs maintainers first and when they get accepted, I'll re-send this patch to
misc.

Kind regards and thanks for the feedback,

Tom Van Braeckel.
