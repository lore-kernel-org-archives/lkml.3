Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbaGCXGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 19:06:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaGCXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 19:06:46 -0400
Date: Thu, 3 Jul 2014 16:11:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>
Cc: stable@kernel.org, "Don A. Bailey" <donb@securitymouse.com>
Subject: [PATCH] lz4: add overrun checks to lz4_uncompress_unknownoutputsize()
Message-ID: <20140703231103.GA4081@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Jan points out that I forgot to make the needed fixes to the
lz4_uncompress_unknownoutputsize() function to mirror the changes done
in lz4_decompress() with regards to potential pointer overflows.

The only in-kernel user of this function is the zram code, which only
takes data from a valid compressed buffer that it made itself, so it's
not a big issue.  But due to external kernel modules using this
function, it's better to be safe here.

Reported-by: Jan Beulich <JBeulich@suse.com>
Cc: "Don A. Bailey" <donb@securitymouse.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index b74da447e81e..7a85967060a5 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -192,6 +192,8 @@ static int lz4_uncompress_unknownoutputsize(const char *source, char *dest,
 			int s = 255;
 			while ((ip < iend) && (s == 255)) {
 				s = *ip++;
+				if (unlikely(length > (size_t)(length + s)))
+					goto _output_error;
 				length += s;
 			}
 		}
@@ -232,6 +234,8 @@ static int lz4_uncompress_unknownoutputsize(const char *source, char *dest,
 		if (length == ML_MASK) {
 			while (ip < iend) {
 				int s = *ip++;
+				if (unlikely(length > (size_t)(length + s)))
+					goto _output_error;
 				length += s;
 				if (s == 255)
 					continue;
@@ -284,7 +288,7 @@ static int lz4_uncompress_unknownoutputsize(const char *source, char *dest,
 
 	/* write overflow error detected */
 _output_error:
-	return (int) (-(((char *) ip) - source));
+	return -1;
 }
 
 int lz4_decompress(const unsigned char *src, size_t *src_len,
