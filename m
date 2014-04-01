Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaDAEOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:14:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaDAEOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:14:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.13 12/22] make prepend_name() work correctly when called with negative *buflen
Date: Mon, 31 Mar 2014 21:08:42 -0700
Message-Id: <20140401040706.285713373@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040703.045139933@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit e825196d48d2b89a6ec3a8eff280098d2a78207e upstream.

In all callchains leading to prepend_name(), the value left in *buflen
is eventually discarded unused if prepend_name() has returned a negative.
So we are free to do what prepend() does, and subtract from *buflen
*before* checking for underflow (which turns into checking the sign
of subtraction result, of course).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2833,9 +2833,9 @@ static int prepend_name(char **buffer, i
 	u32 dlen = ACCESS_ONCE(name->len);
 	char *p;
 
-	if (*buflen < dlen + 1)
-		return -ENAMETOOLONG;
 	*buflen -= dlen + 1;
+	if (*buflen < 0)
+		return -ENAMETOOLONG;
 	p = *buffer -= dlen + 1;
 	*p++ = '/';
 	while (dlen--) {


