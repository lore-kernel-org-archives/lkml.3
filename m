Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaC2SNE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:13:04 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:49255 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaC2SNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:13:01 -0400
Date: Sat, 29 Mar 2014 14:12:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexandre Demers <alexandre.f.demers@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Regression, bisected 9e30cc] "sysfs, kernfs: no need to
 kern_mount() sysfs from sysfs_init()" prevents system from booting correctly
Message-ID: <20140329181258.GF5553@htj.dyndns.org>
References: <CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com>
 <20140314140804.GG12613@htj.dyndns.org>
 <CAPEhTTG3kCDk2V9dbCB5mATKt2nyVj9iiv9g5MTOEbqYrpPefg@mail.gmail.com>
 <20140317201346.GE17373@mtj.dyndns.org>
 <5327AAA8.2080703@gmail.com>
 <53322777.3030703@gmail.com>
 <20140326131800.GA7171@htj.dyndns.org>
 <CAPEhTTGyA7SjedwL8Mv-ZDEY_doucW3thPr==xyOemm3+Vp=Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPEhTTGyA7SjedwL8Mv-ZDEY_doucW3thPr==xyOemm3+Vp=Cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Thu, Mar 27, 2014 at 01:47:53PM -0400, Alexandre Demers wrote:
> I'll do my best, but I just don't have enough time right now for
> everything I have to do at home and dig this bug. I may be able to
> look at it in the next couple of days though, or it may go somewhere
> next week... That being said, I tried yesterday to have a better idea
> and I thank you for the "ScrLck" trick, I didn't know that it was
> working. Nevertheless I didn't find anything.
>
> It seems as if the transition from the temporary kernel's fs to the
> hard disk's fs is not done correctly. If I boot with a working kernel
> after that, I can't find any trace of where it was trying to copy the
> files or of any partition being full. Could it be filling the RAM
> until it reaches its maximum capacity (16GB to fill before hitting the
> limit and throwing the errors)? That would explain at least why it
> takes so much time before the flood of errors begins...

That could definitely be the case.  I'd really like to get to the
bottom of it.  It's really curious that there aren't more people
reporting the same problem.  Can you please try whether the following
patch makes the regression go away?

Thanks!

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index a66ad61..a3223e2 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -75,5 +75,7 @@ int __init sysfs_init(void)
 		return err;
 	}
 
+	WARN_ON(IS_ERR(kern_mount(&sysfs_fs_type)));
+
 	return 0;
 }
