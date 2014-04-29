Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbaD2Ogd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:36:33 -0400
Received: from mail.siteground.com ([67.19.240.234]:49602 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaD2Ogc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:36:32 -0400
X-Greylist: delayed 2832 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2014 10:36:32 EDT
Message-ID: <535FADDA.2070803@1h.com>
Date: Tue, 29 Apr 2014 16:49:14 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: containers@lists.linux-foundation.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
when using user namespaces I found a bug in the capability checks done by ioctl.

If someone tries to use chattr +i while in a different user namespace it will get the following:

ioctl(3, EXT2_IOC_SETFLAGS, 0x7fffa4fedacc) = -1 EPERM (Operation not permitted)

I'm proposing a fix to this, by replacing the capable(CAP_LINUX_IMMUTABLE) check with 
ns_capable(current_cred()->user_ns, CAP_LINUX_IMMUTABLE).

If you agree I can send patches for all filesystems.

I'm proposing the following patch:

---
  fs/ext4/ioctl.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d011b69..25683d0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -265,7 +265,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
                  * This test looks nicer. Thanks to Pauline Middelink
                  */
                 if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
-                       if (!capable(CAP_LINUX_IMMUTABLE))
+                       if (!ns_capable(current_cred()->user_ns, CAP_LINUX_IMMUTABLE))
                                 goto flags_out;
                 }

-- 
1.8.4


-- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
