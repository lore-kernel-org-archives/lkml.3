Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab3BNKMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:12:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43582 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab3BNKMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:12:18 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 06/13] vmcore: modify vmcore clean-up function to free buffer
 on 2nd kernel
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:12:16 +0900
Message-ID: <20130214101216.22466.52389.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vmcore object has buffer on 2nd kernel if it has VMCORE_2ND_KERNEL
type, which needs to be freed.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 7e3f922..77e0a0e 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -735,6 +735,15 @@ void vmcore_cleanup(void)
 		struct vmcore *m;
 
 		m = list_entry(pos, struct vmcore, list);
+
+		switch (m->type) {
+		case VMCORE_OLD_MEMORY:
+			break;
+		case VMCORE_2ND_KERNEL:
+			free_pages((unsigned long)m->buf, get_order(m->size));
+			break;
+		}
+
 		list_del(&m->list);
 		kfree(m);
 	}

