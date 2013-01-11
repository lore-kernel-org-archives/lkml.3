Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3AKLLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:11:40 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44614 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3AKLLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:11:39 -0500
Message-ID: <50EFF366.2000303@suse.cz>
Date: Fri, 11 Jan 2013 12:11:34 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Florian Westphal <fw@strlen.de>
CC: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, gregkh@linuxfoundation.org,
        frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
References: <20130110144626.GA26279@breakpoint.cc> <20130110155058.12f66e73@bob.linux.org.uk> <20130110162907.GB26279@breakpoint.cc> <50EEF8FD.9000004@suse.cz> <20130110224554.1724a791@bob.linux.org.uk> <50EF45DF.4010905@suse.cz>
In-Reply-To: <50EF45DF.4010905@suse.cz>
X-Enigmail-Version: 1.5
Content-Type: multipart/mixed;
 boundary="------------070803030608080503060808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070803030608080503060808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 01/10/2013 11:51 PM, Jiri Slaby wrote:
> On 01/10/2013 11:45 PM, Alan Cox wrote:
>> So we should just fix TIOCGPTN on a pty with no suitable name answer to
>> return -EINVAL
> 
> Yes, I agree as I'm expressed in my second mail. Sorry for the confusion.

Does the attached patch help?

-- 
js
suse labs

--------------070803030608080503060808
Content-Type: text/x-patch;
 name="0001-pty-return-EINVAL-for-TIOCGPTN-for-BSD-ptys.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-pty-return-EINVAL-for-TIOCGPTN-for-BSD-ptys.patch"

>From e7f1242ca1d8d6a17c87a85091cc977d2040ef15 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 11 Jan 2013 12:06:27 +0100
Subject: [PATCH] pty: return EINVAL for TIOCGPTN for BSD ptys

Commit bbb63c514a3464342967237a51a21ea8f61ab951 (drivers:tty:fix up
ENOIOCTLCMD error handling) changed the default return value from tty
ioctl to be ENOTTY and not EINVAL. This is appropriate.

But in case of TIOCGPTN for the old BSD ptys glibc started failing
because it expects EINVAL to be returned. Only then it continues to
obtain the pts name the other way around.

So fix this case by explicit return of EINVAL in this case.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Florian Westphal <fw@strlen.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/pty.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d04c39d..d2fd6f0 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -441,6 +441,8 @@ static int pty_bsd_ioctl(struct tty_struct *tty,
 		return pty_get_pktmode(tty, (int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
+	case TIOCGPTN: /* TTY returns ENOTTY, but glibc expects EINVAL here */
+		return -EINVAL;
 	}
 	return -ENOIOCTLCMD;
 }
-- 
1.8.1


--------------070803030608080503060808--
