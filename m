Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaBEUJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:09:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:55791 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaBEUJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:09:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Paul Moore <pmoore@redhat.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 203/213] cipso: don't follow a NULL pointer when setsockopt() is called
Date: Wed, 5 Feb 2014 15:02:38 -0500
Message-ID: <1391630568-49251-204-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <pmoore@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a9d0acf8d157c30374af76d43e7f05b5b108be0c upstream.

[ Upstream commit 89d7ae34cdda4195809a5a987f697a517a2a3177 ]

As reported by Alan Cox, and verified by Lin Ming, when a user
attempts to add a CIPSO option to a socket using the CIPSO_V4_TAG_LOCAL
tag the kernel dies a terrible death when it attempts to follow a NULL
pointer (the skb argument to cipso_v4_validate() is NULL when called via
the setsockopt() syscall).

This patch fixes this by first checking to ensure that the skb is
non-NULL before using it to find the incoming network interface.  In
the unlikely case where the skb is NULL and the user attempts to add
a CIPSO option with the _TAG_LOCAL tag we return an error as this is
not something we want to allow.

A simple reproducer, kindly supplied by Lin Ming, although you must
have the CIPSO DOI #3 configure on the system first or you will be
caught early in cipso_v4_validate():

	#include <sys/types.h>
	#include <sys/socket.h>
	#include <linux/ip.h>
	#include <linux/in.h>
	#include <string.h>

	struct local_tag {
		char type;
		char length;
		char info[4];
	};

	struct cipso {
		char type;
		char length;
		char doi[4];
		struct local_tag local;
	};

	int main(int argc, char **argv)
	{
		int sockfd;
		struct cipso cipso = {
			.type = IPOPT_CIPSO,
			.length = sizeof(struct cipso),
			.local = {
				.type = 128,
				.length = sizeof(struct local_tag),
			},
		};

		memset(cipso.doi, 0, 4);
		cipso.doi[3] = 3;

		sockfd = socket(AF_INET, SOCK_DGRAM, 0);
		#define SOL_IP 0
		setsockopt(sockfd, SOL_IP, IP_OPTIONS,
			&cipso, sizeof(struct cipso));

		return 0;
	}

CC: Lin Ming <mlin@ss.pku.edu.cn>
Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/cipso_ipv4.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index d5ef60963183..f8f338874719 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1727,8 +1727,10 @@ int cipso_v4_validate(const struct sk_buff *skb, unsigned char **option)
 		case CIPSO_V4_TAG_LOCAL:
 			/* This is a non-standard tag that we only allow for
 			 * local connections, so if the incoming interface is
-			 * not the loopback device drop the packet. */
-			if (!(skb->dev->flags & IFF_LOOPBACK)) {
+			 * not the loopback device drop the packet. Further,
+			 * there is no legitimate reason for setting this from
+			 * userspace so reject it if skb is NULL. */
+			if (skb == NULL || !(skb->dev->flags & IFF_LOOPBACK)) {
 				err_offset = opt_iter;
 				goto validate_return_locked;
 			}
-- 
1.8.5.2

