Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532AbaCUAEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965473AbaCUAEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 125/149] net: unix socket code abuses csum_partial
Date: Thu, 20 Mar 2014 17:04:48 -0700
Message-Id: <20140321000441.289039505@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/unix/af_unix.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -161,9 +161,8 @@ static inline void unix_set_secdata(stru
 
 static inline unsigned int unix_hash_fold(__wsum n)
 {
-	unsigned int hash = (__force unsigned int)n;
+	unsigned int hash = (__force unsigned int)csum_fold(n);
 
-	hash ^= hash>>16;
 	hash ^= hash>>8;
 	return hash&(UNIX_HASH_SIZE-1);
 }


