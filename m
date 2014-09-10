Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaIJVWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbaIJVWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:22:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/6] KEYS: Reinstate EPERM for a key type name beginning
 with a '.'
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-kernel@vger.kernel.org, dhowells@redhat.com,
        linux-security-module@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 10 Sep 2014 22:22:06 +0100
Message-ID: <20140910212206.10752.21818.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reinstate the generation of EPERM for a key type name beginning with a '.' in
a userspace call.  Types whose name begins with a '.' are internal only.

The test was removed by:

	commit a4e3b8d79a5c6d40f4a9703abf7fe3abcc6c3b8d
	Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
	Date:   Thu May 22 14:02:23 2014 -0400
	Subject: KEYS: special dot prefixed keyring name bug fix

I think we want to keep the restriction on type name so that userspace can't
add keys of a special internal type.

Note that removal of the test causes several of the tests in the keyutils
testsuite to fail.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
---

 security/keys/keyctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index e26f860e5f2e..eff88a5f5d40 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -37,6 +37,8 @@ static int key_get_type_from_user(char *type,
 		return ret;
 	if (ret == 0 || ret >= len)
 		return -EINVAL;
+	if (type[0] == '.')
+		return -EPERM;
 	type[len - 1] = '\0';
 	return 0;
 }

