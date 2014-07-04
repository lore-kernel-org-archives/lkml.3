Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031279AbaGDW1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:27:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760802AbaGDWWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:22:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>,
        "Don A. Bailey" <donb@securitymouse.com>
Subject: [PATCH 3.14 53/59] lz4: add overrun checks to lz4_uncompress_unknownoutputsize()
Date: Fri,  4 Jul 2014 15:19:42 -0700
Message-Id: <20140704221542.066435608@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221539.544876024@linuxfoundation.org>
References: <20140704221539.544876024@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4a3a99045177369700c60d074c0e525e8093b0fc upstream.

Jan points out that I forgot to make the needed fixes to the
lz4_uncompress_unknownoutputsize() function to mirror the changes done
in lz4_decompress() with regards to potential pointer overflows.

The only in-kernel user of this function is the zram code, which only
takes data from a valid compressed buffer that it made itself, so it's
not a big issue.  But due to external kernel modules using this
function, it's better to be safe here.

Reported-by: Jan Beulich <JBeulich@suse.com>
Cc: "Don A. Bailey" <donb@securitymouse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/lz4/lz4_decompress.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -192,6 +192,8 @@ static int lz4_uncompress_unknownoutputs
 			int s = 255;
 			while ((ip < iend) && (s == 255)) {
 				s = *ip++;
+				if (unlikely(length > (size_t)(length + s)))
+					goto _output_error;
 				length += s;
 			}
 		}
@@ -232,6 +234,8 @@ static int lz4_uncompress_unknownoutputs
 		if (length == ML_MASK) {
 			while (ip < iend) {
 				int s = *ip++;
+				if (unlikely(length > (size_t)(length + s)))
+					goto _output_error;
 				length += s;
 				if (s == 255)
 					continue;
@@ -284,7 +288,7 @@ static int lz4_uncompress_unknownoutputs
 
 	/* write overflow error detected */
 _output_error:
-	return (int) (-(((char *) ip) - source));
+	return -1;
 }
 
 int lz4_decompress(const unsigned char *src, size_t *src_len,


