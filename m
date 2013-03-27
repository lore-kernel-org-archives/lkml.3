Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3C0QFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:05:21 -0400
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:38209 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab3C0QFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:05:19 -0400
X-Greylist: delayed 2054 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Mar 2013 12:05:18 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Change in behaviour when unmounting recursive bind mounts
Date: Wed, 27 Mar 2013 15:30:57 +0000
Message-ID: <2987308.JNKpYDEnfV@deuteros>
User-Agent: KMail/4.10.1 (Linux/3.8.3-103.fc17.x86_64; KDE/4.10.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Al, all,

Please have a look at the command sequence below, does it look right to you?

+ M1=testmp1
+ M2=testmp2
+ SM=submount
+ mkdir -p testmp1
+ mkdir -p testmp2
+ mount none -t tmpfs testmp1
+ mkdir -p testmp1/submount
+ mount none -t tmpfs testmp1/submount
+ strace -f -e trace=mount,umount mount testmp1 --rbind testmp2
mount("/dev/shm/testmp1", "/dev/shm/testmp2", 0x7fcd30b821e0, MS_MGC_VAL|
MS_BIND|MS_REC, NULL) = 0
+++ exited with 0 +++
+ strace -f -e trace=mount,umount umount -l testmp2
umount("/dev/shm/testmp2", MNT_DETACH)  = 0
+++ exited with 0 +++
+ mountpoint testmp1/submount
testmp1/submount is not a mountpoint
+ echo nay
nay
+ umount testmp2
umount: testmp2: not mounted
+ umount testmp1
+ rmdir testmp1
+ rmdir testmp2
rmdir: failed to remove `testmp2': Device or resource busy

Previously unmounting the recursive bind target would not unmount the source, 
which to me looks like a more sensible outcome. 

However what could be causing this weird behaviour puzzles me since I am not 
sure it is purely the kernel on it's own. When I first hit this problem some 
months ago unfortunately I did not have the time to dig deeper. However a 
mental note remained that I thought, at the time, it is possible some 
userspace change was a contributing factor.

Regards,

Tvrtko

