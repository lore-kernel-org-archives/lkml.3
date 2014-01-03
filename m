Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaACQIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:08:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaACQIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:08:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 7/7] Fix uninitialised variable warning in mei-amt-version.c
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Date: Fri, 03 Jan 2014 16:08:12 +0000
Message-ID: <20140103160812.8153.74401.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:

	Documentation/misc-devices/mei/mei-amt-version.c: In function 'main':
	Documentation/misc-devices/mei/mei-amt-version.c:103:5: warning: 'acmd.fd' is used uninitialized in this function [-Wuninitialized]
	  if (cl->fd != -1)
	     ^
	Documentation/misc-devices/mei/mei-amt-version.c:443:21: note: 'acmd.fd' was declared here
	  struct amt_host_if acmd;
			     ^

The call chain:

	-->main()
	   -->amt_host_if_init()
	      -->mei_init()
	         -->mei_deinit()

results in this on the first time through because main()::acmd has not yet
been initialised.

To fix this, acmd.fd needs to be initialised to -1.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tomas Winkler <tomas.winkler@intel.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 Documentation/misc-devices/mei/mei-amt-version.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/misc-devices/mei/mei-amt-version.c b/Documentation/misc-devices/mei/mei-amt-version.c
index 49e4f770864a..7027a8da0ba0 100644
--- a/Documentation/misc-devices/mei/mei-amt-version.c
+++ b/Documentation/misc-devices/mei/mei-amt-version.c
@@ -440,7 +440,7 @@ out:
 int main(int argc, char **argv)
 {
 	struct amt_code_versions ver;
-	struct amt_host_if acmd;
+	struct amt_host_if acmd = { .mei_cl.fd = -1 };
 	unsigned int i;
 	uint32_t status;
 	int ret;

