Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaL1Uo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 15:44:59 -0500
Received: from mout.web.de ([212.227.15.14]:52585 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaL1Uo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 15:44:58 -0500
Message-ID: <54A06BC4.5030200@users.sourceforge.net>
Date: Sun, 28 Dec 2014 21:44:52 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 4/8] fs/9p: One function call less in v9fs_fid_xattr_get()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net>
In-Reply-To: <54A01326.3050306@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:lExkPD1PsC8A4CSh0Rw4W4otp1B4fTPNYPjeaaoqUKqG5SUAuoz
 7WS9KEwsnPButPFigfIJvWfL2+Czf9/Dl/e4R/qoPzW2tA7t4a2LDmkI5pXveCkhZtxn+KQ
 mGBvUAQ/p12bxxxD6Uldcp4m/c1P0UFUqHfpreSoBBfta/4uZHRCeadiotW4uWpVsdk8tWh
 o44oOeXW4DHzDzBnb5F5A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 28 Dec 2014 09:05:25 +0100

The p9_client_clunk() function was called in one case by the
v9fs_fid_xattr_get() function during error handling even if the passed
variable "attr_fid" contained a null pointer.

Let us delete an unnecessary variable assignment there and return from
this implementation directly after a failure detection for
a p9_client_xattrwalk() call.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/9p/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index 8e72269..05ef790 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -34,8 +34,7 @@ ssize_t v9fs_fid_xattr_get(struct p9_fid *fid, const char *name,
 		retval = PTR_ERR(attr_fid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_attrwalk failed %zd\n",
 			 retval);
-		attr_fid = NULL;
-		goto error;
+		return retval;
 	}
 	if (!buffer_size) {
 		/* request to get the attr_size */
-- 
2.2.1

