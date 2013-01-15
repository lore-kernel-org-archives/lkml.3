Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab3AOW3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:29:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:41576 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757832Ab3AOW3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sven Geggus <lists@fuchsschwanzdomain.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 062/221] svcrpc: Revert "sunrpc/cache.h: replace simple_strtoul"
Date: Tue, 15 Jan 2013 10:49:49 -0800
Message-Id: <20130115185002.528495378@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 621eb19ce1ec216e03ad354cb0c4061736b2a436 upstream.

Commit bbf43dc888833ac0539e437dbaeb28bfd4fbab9f "sunrpc/cache.h: replace
simple_strtoul" introduced new range-checking which could cause get_int
to fail on unsigned integers too large to be represented as an int.

We could parse them as unsigned instead--but it turns out svcgssd is
actually passing down "-1" in some cases.  Which is perhaps stupid, but
there's nothing we can do about it now.

So just revert back to the previous "sloppy" behavior that accepts
either representation.

Reported-by: Sven Geggus <lists@fuchsschwanzdomain.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sunrpc/cache.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -217,6 +217,8 @@ extern int qword_get(char **bpp, char *d
 static inline int get_int(char **bpp, int *anint)
 {
 	char buf[50];
+	char *ep;
+	int rv;
 	int len = qword_get(bpp, buf, sizeof(buf));
 
 	if (len < 0)
@@ -224,9 +226,11 @@ static inline int get_int(char **bpp, in
 	if (len == 0)
 		return -ENOENT;
 
-	if (kstrtoint(buf, 0, anint))
+	rv = simple_strtol(buf, &ep, 0);
+	if (*ep)
 		return -EINVAL;
 
+	*anint = rv;
 	return 0;
 }
 


