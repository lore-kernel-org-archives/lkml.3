Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaC3XkC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:40:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36452 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbaC3XZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Anton Blanchard" <anton@samba.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.365740697@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 164/200] net: unix socket code abuses csum_partial
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 0a13404dd3bf4ea870e3d96270b5a382edca85c0 upstream.

The unix socket code is using the result of csum_partial to
hash into a lookup table:

	unix_hash_fold(csum_partial(sunaddr, len, 0));

csum_partial is only guaranteed to produce something that can be
folded into a checksum, as its prototype explains:

 * returns a 32-bit number suitable for feeding into itself
 * or csum_tcpudp_magic

The 32bit value should not be used directly.

Depending on the alignment, the ppc64 csum_partial will return
different 32bit partial checksums that will fold into the same
16bit checksum.

This difference causes the following testcase (courtesy of
Gustavo) to sometimes fail:

#include <sys/socket.h>
#include <stdio.h>

int main()
{
	int fd = socket(PF_LOCAL, SOCK_STREAM|SOCK_CLOEXEC, 0);

	int i = 1;
	setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &i, 4);

	struct sockaddr addr;
	addr.sa_family = AF_LOCAL;
	bind(fd, &addr, 2);

	listen(fd, 128);

	struct sockaddr_storage ss;
	socklen_t sslen = (socklen_t)sizeof(ss);
	getsockname(fd, (struct sockaddr*)&ss, &sslen);

	fd = socket(PF_LOCAL, SOCK_STREAM|SOCK_CLOEXEC, 0);

	if (connect(fd, (struct sockaddr*)&ss, sslen) == -1){
		perror(NULL);
		return 1;
	}
	printf("OK\n");
	return 0;
}

As suggested by davem, fix this by using csum_fold to fold the
partial 32bit checksum into a 16bit checksum before using it.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -149,8 +149,8 @@ static inline void unix_set_secdata(stru
 
 static inline unsigned unix_hash_fold(__wsum n)
 {
-	unsigned hash = (__force unsigned)n;
-	hash ^= hash>>16;
+	unsigned int hash = (__force unsigned int)csum_fold(n);
+
 	hash ^= hash>>8;
 	return hash&(UNIX_HASH_SIZE-1);
 }

