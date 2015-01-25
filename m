Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbbAYTIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:08:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbbAYSJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.14 93/98] netfilter: ipset: small potential read beyond the end of buffer
Date: Sun, 25 Jan 2015 10:07:51 -0800
Message-Id: <20150125180716.928934614@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 2196937e12b1b4ba139806d132647e1651d655df upstream.

We could be reading 8 bytes into a 4 byte buffer here.  It seems
harmless but adding a check is the right thing to do and it silences a
static checker warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1839,6 +1839,12 @@ ip_set_sockfn_get(struct sock *sk, int o
 	if (*op < IP_SET_OP_VERSION) {
 		/* Check the version at the beginning of operations */
 		struct ip_set_req_version *req_version = data;
+
+		if (*len < sizeof(struct ip_set_req_version)) {
+			ret = -EINVAL;
+			goto done;
+		}
+
 		if (req_version->version != IPSET_PROTOCOL) {
 			ret = -EPROTO;
 			goto done;


