Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaBEVCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:02:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:54603 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaBEUFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:09 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 059/213] net/tun: fix ioctl() based info leaks
Date: Wed, 5 Feb 2014 15:00:14 -0500
Message-ID: <1391630568-49251-60-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a117dacde0288f3ec60b6e5bcedae8fa37ee0dfc upstream.

The tun module leaks up to 36 bytes of memory by not fully initializing
a structure located on the stack that gets copied to user memory by the
TUNGETIFF and SIOCGIFHWADDR ioctl()s.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/tun.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7b4a88b2f696..c777d8ebdaa8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1177,9 +1177,11 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	int sndbuf;
 	int ret;
 
-	if (cmd == TUNSETIFF || _IOC_TYPE(cmd) == 0x89)
+	if (cmd == TUNSETIFF || _IOC_TYPE(cmd) == 0x89) {
 		if (copy_from_user(&ifr, argp, ifreq_len))
 			return -EFAULT;
+	} else
+		memset(&ifr, 0, sizeof(ifr));
 
 	if (cmd == TUNGETFEATURES) {
 		/* Currently this just means: "what IFF flags are valid?".
-- 
1.8.5.2

