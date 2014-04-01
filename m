Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaDAQJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44443 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaDAQJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 60/86] net: unix socket code abuses csum_partial
Date: Tue,  1 Apr 2014 09:08:13 -0700
Message-Id: <1396368519-12728-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/unix/af_unix.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index fdf0900..72f4e97 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -160,9 +160,8 @@ static inline void unix_set_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 
 static inline unsigned int unix_hash_fold(__wsum n)
 {
-	unsigned int hash = (__force unsigned int)n;
+	unsigned int hash = (__force unsigned int)csum_fold(n);
 
-	hash ^= hash>>16;
 	hash ^= hash>>8;
 	return hash&(UNIX_HASH_SIZE-1);
 }
-- 
1.8.3.2

