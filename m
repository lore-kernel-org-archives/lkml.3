Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbaCHBTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:19:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaCHBHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 74/99] xen/io/ring.h: new macro to detect whether there are too many requests on the ring
Date: Fri,  7 Mar 2014 17:08:10 -0800
Message-Id: <20140308010613.967993980@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

commit 8d9256906a97c24e97e016482b9be06ea2532b05 upstream.

Backends may need to protect themselves against an insane number of
produced requests stored by a frontend, in case they iterate over
requests until reaching the req_prod value. There can't be more
requests on the ring than the difference between produced requests
and produced (but possibly not yet published) responses.

This is a more strict alternative to a patch previously posted by
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/xen/interface/io/ring.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/xen/interface/io/ring.h
+++ b/include/xen/interface/io/ring.h
@@ -188,6 +188,11 @@ struct __name##_back_ring {						\
 #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
     (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
 
+/* Ill-behaved frontend determination: Can there be this many requests? */
+#define RING_REQUEST_PROD_OVERFLOW(_r, _prod)               \
+    (((_prod) - (_r)->rsp_prod_pvt) > RING_SIZE(_r))
+
+
 #define RING_PUSH_REQUESTS(_r) do {					\
     wmb(); /* back sees requests /before/ updated producer index */	\
     (_r)->sring->req_prod = (_r)->req_prod_pvt;				\


