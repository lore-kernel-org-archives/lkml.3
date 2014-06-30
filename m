Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaF3MIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:08:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52010 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 016/181] net/compat: Fix minor information leak in siocdevprivate_ioctl()
Date: Mon, 30 Jun 2014 13:50:37 +0200
Message-Id: <e45145b6eb158405fe5cbbcce0a206d3b3090842.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 417c3522b3202dacce4873cfb0190459fbce95c5 upstream.

We don't need to check that ifr_data itself is a valid user pointer,
but we should check &ifr_data is.  Thankfully the copy of ifr_name is
checked, so this can only leak a few bytes from immediately above the
user address limit.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/socket.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index dc57dae20a9a..c8ca896a9a5a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3023,19 +3023,16 @@ static int siocdevprivate_ioctl(struct net *net, unsigned int cmd,
 	if (copy_from_user(&tmp_buf[0], &(u_ifreq32->ifr_ifrn.ifrn_name[0]),
 			   IFNAMSIZ))
 		return -EFAULT;
-	if (__get_user(data32, &u_ifreq32->ifr_ifru.ifru_data))
+	if (get_user(data32, &u_ifreq32->ifr_ifru.ifru_data))
 		return -EFAULT;
 	data64 = compat_ptr(data32);
 
 	u_ifreq64 = compat_alloc_user_space(sizeof(*u_ifreq64));
 
-	/* Don't check these user accesses, just let that get trapped
-	 * in the ioctl handler instead.
-	 */
 	if (copy_to_user(&u_ifreq64->ifr_ifrn.ifrn_name[0], &tmp_buf[0],
 			 IFNAMSIZ))
 		return -EFAULT;
-	if (__put_user(data64, &u_ifreq64->ifr_ifru.ifru_data))
+	if (put_user(data64, &u_ifreq64->ifr_ifru.ifru_data))
 		return -EFAULT;
 
 	return dev_ioctl(net, cmd, u_ifreq64);
-- 
2.0.0

