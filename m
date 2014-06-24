Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaFXQAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:00:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965180AbaFXP4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Don A. Bailey" <donb@securitymouse.com>
Subject: [PATCH 3.15 49/61] lz4: ensure length does not wrap
Date: Tue, 24 Jun 2014 11:51:32 -0400
Message-Id: <20140624154955.023232981@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 206204a1162b995e2185275167b22468c00d6b36 upstream.

Given some pathologically compressed data, lz4 could possibly decide to
wrap a few internal variables, causing unknown things to happen.  Catch
this before the wrapping happens and abort the decompression.

Reported-by: "Don A. Bailey" <donb@securitymouse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/lz4/lz4_decompress.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -72,6 +72,8 @@ static int lz4_uncompress(const char *so
 			len = *ip++;
 			for (; len == 255; length += 255)
 				len = *ip++;
+			if (unlikely(length > (size_t)(length + len)))
+				goto _output_error;
 			length += len;
 		}
 


