Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbaAFXJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:09:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085AbaAFWlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>,
        Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 103/129] ceph: fix null pointer dereference
Date: Mon,  6 Jan 2014 14:38:52 -0800
Message-Id: <20140106223902.549622631@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>

commit c338c07c51e3106711fad5eb599e375eadb6855d upstream.

When register_session() is given an out-of-range argument for mds,
ceph_mdsmap_get_addr() will return a null pointer, which would be given to
ceph_con_open() & be dereferenced, causing a kernel oops. This fixes bug #4685
in the Ceph bug tracker <http://tracker.ceph.com/issues/4685>.

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mds_client.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -414,6 +414,9 @@ static struct ceph_mds_session *register
 {
 	struct ceph_mds_session *s;
 
+	if (mds >= mdsc->mdsmap->m_max_mds)
+		return ERR_PTR(-EINVAL);
+
 	s = kzalloc(sizeof(*s), GFP_NOFS);
 	if (!s)
 		return ERR_PTR(-ENOMEM);


