Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbaBEVKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:10:36 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47961 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbaBEUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tommi Rantala <tt.rantala@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 037/213] sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails
Date: Wed, 5 Feb 2014 14:59:52 -0500
Message-ID: <1391630568-49251-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tommi Rantala <tt.rantala@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit be364c8c0f17a3dd42707b5a090b318028538eb9 upstream.

Trinity (the syscall fuzzer) discovered a memory leak in SCTP,
reproducible e.g. with the sendto() syscall by passing invalid
user space pointer in the second argument:

 #include <string.h>
 #include <arpa/inet.h>
 #include <sys/socket.h>

 int main(void)
 {
         int fd;
         struct sockaddr_in sa;

         fd = socket(AF_INET, SOCK_STREAM, 132 /*IPPROTO_SCTP*/);
         if (fd < 0)
                 return 1;

         memset(&sa, 0, sizeof(sa));
         sa.sin_family = AF_INET;
         sa.sin_addr.s_addr = inet_addr("127.0.0.1");
         sa.sin_port = htons(11111);

         sendto(fd, NULL, 1, 0, (struct sockaddr *)&sa, sizeof(sa));

         return 0;
 }

As far as I can tell, the leak has been around since ~2003.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sctp/chunk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 3eab6db59a37..df773fcaaa03 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -282,7 +282,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 			goto errout;
 		err = sctp_user_addto_chunk(chunk, offset, len, msgh->msg_iov);
 		if (err < 0)
-			goto errout;
+			goto errout_chunk_free;
 
 		offset += len;
 
@@ -322,7 +322,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 		__skb_pull(chunk->skb, (__u8 *)chunk->chunk_hdr
 			   - (__u8 *)chunk->skb->data);
 		if (err < 0)
-			goto errout;
+			goto errout_chunk_free;
 
 		sctp_datamsg_assign(msg, chunk);
 		list_add_tail(&chunk->frag_list, &msg->chunks);
@@ -330,6 +330,9 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 
 	return msg;
 
+errout_chunk_free:
+	sctp_chunk_free(chunk);
+
 errout:
 	list_for_each_safe(pos, temp, &msg->chunks) {
 		list_del_init(pos);
-- 
1.8.5.2

