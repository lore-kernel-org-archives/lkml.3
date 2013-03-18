Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982Ab3CRVuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:50:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab3CRVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 56/75] net/sctp: Validate parameter size for SCTP_GET_ASSOC_STATS
Date: Mon, 18 Mar 2013 14:07:19 -0700
Message-Id: <20130318210514.288751131@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Guenter Roeck <linux@roeck-us.net>

commit 726bc6b092da4c093eb74d13c07184b18c1af0f1 upstream.

Building sctp may fail with:

In function ‘copy_from_user’,
    inlined from ‘sctp_getsockopt_assoc_stats’ at
    net/sctp/socket.c:5656:20:
arch/x86/include/asm/uaccess_32.h:211:26: error: call to
    ‘copy_from_user_overflow’ declared with attribute error: copy_from_user()
    buffer size is not provably correct

if built with W=1 due to a missing parameter size validation
before the call to copy_from_user.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5653,6 +5653,9 @@ static int sctp_getsockopt_assoc_stats(s
 	if (len < sizeof(sctp_assoc_t))
 		return -EINVAL;
 
+	/* Allow the struct to grow and fill in as much as possible */
+	len = min_t(size_t, len, sizeof(sas));
+
 	if (copy_from_user(&sas, optval, len))
 		return -EFAULT;
 
@@ -5686,9 +5689,6 @@ static int sctp_getsockopt_assoc_stats(s
 	/* Mark beginning of a new observation period */
 	asoc->stats.max_obs_rto = asoc->rto_min;
 
-	/* Allow the struct to grow and fill in as much as possible */
-	len = min_t(size_t, len, sizeof(sas));
-
 	if (put_user(len, optlen))
 		return -EFAULT;
 


