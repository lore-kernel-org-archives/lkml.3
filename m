Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab3JKTkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:40:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909Ab3JKTkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 070/110] sparc64: Fix buggy strlcpy() conversion in ldom_reboot().
Date: Fri, 11 Oct 2013 12:38:50 -0700
Message-Id: <20131011193815.473850633@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 2bd161a605f1f84a5fc8a4fe8410113a94f79355 ]

Commit 117a0c5fc9c2d06045bd217385b2b39ea426b5a6 ("sparc: kernel: using
strlcpy() instead of strcpy()") added a bug to ldom_reboot in
arch/sparc/kernel/ds.c

-		strcpy(full_boot_str + strlen("boot "), boot_command);
+				     strlcpy(full_boot_str + strlen("boot "), boot_command,
+				     			     sizeof(full_boot_str + strlen("boot ")));

That last sizeof() expression evaluates to sizeof(size_t) which is
not what was intended.

Also even the corrected:

     sizeof(full_boot_str) + strlen("boot ")

is not right as the destination buffer length is just plain
"sizeof(full_boot_str)" and that's what the final argument
should be.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/ds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -844,7 +844,7 @@ void ldom_reboot(const char *boot_comman
 
 		strcpy(full_boot_str, "boot ");
 		strlcpy(full_boot_str + strlen("boot "), boot_command,
-			sizeof(full_boot_str + strlen("boot ")));
+			sizeof(full_boot_str));
 		len = strlen(full_boot_str);
 
 		if (reboot_data_supported) {


