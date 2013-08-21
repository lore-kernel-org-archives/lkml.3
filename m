Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3HUPwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:52:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50230 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3HUPwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:52:36 -0400
Message-ID: <5214E23B.9060608@oracle.com>
Date: Wed, 21 Aug 2013 10:52:27 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin LaHaise <bcrl@kvack.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the aio tree
References: <20130821174522.3af60c89647476d2aab5f47c@canb.auug.org.au>
In-Reply-To: <20130821174522.3af60c89647476d2aab5f47c@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Stephen,

There's another problem after the merge. Now that buf is passed into
aio_run_iocb(), ki_iter is no longer needed. It's not getting
initialized and causes an oops.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
- ---
 fs/aio.c            | 4 ++--
 include/linux/aio.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 59b46cd..9f783e3 100644
- --- a/fs/aio.c
+++ b/fs/aio.c
@@ -1281,11 +1281,11 @@ rw_common:
 		break;
 
 	case IOCB_CMD_READ_ITER:
- -		ret = aio_read_iter(req, req->ki_iter);
+		ret = aio_read_iter(req, (void *)buf);
 		break;
 
 	case IOCB_CMD_WRITE_ITER:
- -		ret = aio_write_iter(req, req->ki_iter);
+		ret = aio_write_iter(req, (void *)buf);
 		break;
 
 	case IOCB_CMD_FDSYNC:
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 4fab377..c08d3ed 100644
- --- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -54,7 +54,6 @@ struct kiocb {
 	 * this is the underlying eventfd context to deliver events to.
 	 */
 	struct eventfd_ctx	*ki_eventfd;
- -	struct iov_iter		*ki_iter;
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
- -- 
1.8.3.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSFOI7AAoJEDaohF61QIxkuW4P/3XIggPvVE3ZypC2Qno9UwtB
KXCVu0A0eLNbA6tB82vCWaQ7IblazoCOAex74qpGGrSB4ReS8yJDHkqnFR1aK8i4
Jyi2EONVUzAq5ijH9amZQfFWwcXBsH6nb2uEcv/xQ2/lc1hPCl3kIy/fKYVRWfYB
7YfX5J3VQnrI28B8NEccfqtTdQlYGp7VaRbh9dKVsudjBZZW9LAMkNcWoFuJzL9l
mAtubeUSaq9F7Dp6p/8whXyh5Ue2jPKo2m87B1et9Y5RN+K45uX3hTUJcAdKY72k
p9U4KNTCFG5o5FfsxI62B3/41R7KeOSe0PvILmb822vxLBnQWgF+fTScswKDDUcP
BFLoKE0WeCgzBiIPLEHaxJZSW7wUJqYAYGrnHRM8yFjJHUMDkWjiNN/597MDbijF
5BBj+gLN2GiBxKQcjtZRTXpUZ2pThLhPYpz/REtS134wz3Hp+ftsytHISCeUUoso
Icf8qd+JmggLOugdXg0gq7LAAc7Wnm91TJ79jsXFc7HPRBKl7AflS3e5poSQoy+Y
YZfVCUWV8LAnnB/fa9JobCIajIOebhhODpd5Y1hcqd9YDrqzhF3KlwyQkAmy9e2x
kX2dvHcumSNkYzWmQnP8Yol7oDWA9XXaL0nYRKDkpy/3F9+pCeheO1bY7tUnMD9F
34UQznE6M8rRkgiRKGDe
=WSg+
-----END PGP SIGNATURE-----
