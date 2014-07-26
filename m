Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaGZTYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:24:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaGZTXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.15 094/109] random: check for increase of entropy_count because of signed conversion
Date: Sat, 26 Jul 2014 12:02:56 -0700
Message-Id: <20140726190226.684600027@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 79a8468747c5f95ed3d5ce8376a3e82e0c5857fc upstream.

The expression entropy_count -= ibytes << (ENTROPY_SHIFT + 3) could
actually increase entropy_count if during assignment of the unsigned
expression on the RHS (mind the -=) we reduce the value modulo
2^width(int) and assign it to entropy_count. Trinity found this.

[ Commit modified by tytso to add an additional safety check for a
  negative entropy_count -- which should never happen, and to also add
  an additional paranoia check to prevent overly large count values to
  be passed into urandom_read().  ]

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -641,7 +641,7 @@ retry:
 		} while (unlikely(entropy_count < pool_size-2 && pnfrac));
 	}
 
-	if (entropy_count < 0) {
+	if (unlikely(entropy_count < 0)) {
 		pr_warn("random: negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
 		WARN_ON(1);
@@ -980,7 +980,7 @@ static size_t account(struct entropy_sto
 		      int reserved)
 {
 	int entropy_count, orig;
-	size_t ibytes;
+	size_t ibytes, nfrac;
 
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
 
@@ -998,7 +998,17 @@ retry:
 	}
 	if (ibytes < min)
 		ibytes = 0;
-	if ((entropy_count -= ibytes << (ENTROPY_SHIFT + 3)) < 0)
+
+	if (unlikely(entropy_count < 0)) {
+		pr_warn("random: negative entropy count: pool %s count %d\n",
+			r->name, entropy_count);
+		WARN_ON(1);
+		entropy_count = 0;
+	}
+	nfrac = ibytes << (ENTROPY_SHIFT + 3);
+	if ((size_t) entropy_count > nfrac)
+		entropy_count -= nfrac;
+	else
 		entropy_count = 0;
 
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
@@ -1375,6 +1385,7 @@ urandom_read(struct file *file, char __u
 			    "with %d bits of entropy available\n",
 			    current->comm, nonblocking_pool.entropy_total);
 
+	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
 	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
 
 	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),


