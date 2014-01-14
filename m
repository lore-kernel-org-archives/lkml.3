Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaANROy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:14:54 -0500
Received: from ns.iliad.fr ([212.27.33.1]:59496 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaANROr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:14:47 -0500
Message-ID: <52D57086.1000508@freebox.fr>
Date: Tue, 14 Jan 2014 18:14:46 +0100
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: livelock during MD device open
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,

I have recently been trying to find the cause a livelock occurring during MD 
device open.

The livelock happens when a process tries to open an MD device for the
first time and another opens the same MD device and sends an invalid
ioctl:

Process 1				Process 2
---------				---------

md_alloc()
   mddev_find()
   -> returns a new mddev with
      hold_active == UNTIL_IOCTL
   add_disk()
   -> sends KOBJ_ADD uevent

					(sees KOBJ_ADD uevent for device)
					md_open()
					md_ioctl(INVALID_IOCTL)
					-> returns ENODEV and clears
					   mddev->hold_active
					md_release()
					  md_put()
					  -> deletes the mddev as
					     hold_active is 0

md_open()
   mddev_find()
   -> returns a newly
     allocated mddev with
     mddev->gendisk == NULL
-> returns with ERESTARTSYS
    (kernel restarts the open syscall)


As to how to fix this, I see two possibilities:

- don't set hold_active to 0 if err is -ENODEV in the abort_unlock
   path in md_ioctl().

- check cmd parameter early in md_ioctl() and return -ENOTTY if the
   cmd parameter is not a valid MD ioctl.

Please advise on the preferred way to fix this, I'll be glad to send a
patch for whatever is the preferred solution.

I have also a simple C program that I can send should you want to reproduce 
the issue.

Regards,

-- 
Nicolas Schichan
Freebox SAS
