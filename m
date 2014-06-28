Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbaF1Scg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:32:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaF1Rus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Don A. Bailey" <donb@securitymouse.com>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 3.14 106/110] lz4: fix another possible overrun
Date: Sat, 28 Jun 2014 10:47:43 -0700
Message-Id: <20140628174551.665017953@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4148c1f67abf823099b2d7db6851e4aea407f5ee upstream.

There is one other possible overrun in the lz4 code as implemented by
Linux at this point in time (which differs from the upstream lz4
codebase, but will get synced at in a future kernel release.)  As
pointed out by Don, we also need to check the overflow in the data
itself.

While we are at it, replace the odd error return value with just a
"simple" -1 value as the return value is never used for anything other
than a basic "did this work or not" check.

Reported-by: "Don A. Bailey" <donb@securitymouse.com>
Reported-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/lz4/lz4_decompress.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -108,6 +108,8 @@ static int lz4_uncompress(const char *so
 		if (length == ML_MASK) {
 			for (; *ip == 255; length += 255)
 				ip++;
+			if (unlikely(length > (size_t)(length + *ip)))
+				goto _output_error;
 			length += *ip++;
 		}
 
@@ -157,7 +159,7 @@ static int lz4_uncompress(const char *so
 
 	/* write overflow error detected */
 _output_error:
-	return (int) (-(((char *)ip) - source));
+	return -1;
 }
 
 static int lz4_uncompress_unknownoutputsize(const char *source, char *dest,


