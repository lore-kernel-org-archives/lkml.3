Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab3APDF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:05:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3APDF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:05:26 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
	<CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
	<CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
	<CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
	<CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
	<CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
	<CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
	<CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
Date: Wed, 16 Jan 2013 11:05:22 +0800
Message-ID: <CACVXFVMi2nrPT8F08xb5ZG0wzq326oqW7xOqo+_8AOvPSWMvoA@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 1:36 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Because it's not just sd.c that uses async_schedule(), and would need
> the async synchronize. It's floppy.c, it's generic scsi scanning (so
> scsi tapes etc), and it's libata-core.c.

As discussed previously, only the module which will populate device
node for user space inside async func may require the synchronization,
so that the below

                modprobe A
                mount /dev/XXX /mnt

script can't be broken, and that should be the original bug report:

           https://bugzilla.kernel.org/attachment.cgi?id=20937

For other modules, looks the synchonization isn't needed, at least there
are lots of other async(work, kthread, ...) things which is scheduled in
driver probe() and no any synchronize is added after the module init()
completes inside loading module. Do we need to add that sync
for all async things inside loading module?

So looks only sd.c and floppy.c are to be synchronized suppose
some sync interfaces are introduced, doesn't it?


Thanks
--
Ming Lei
