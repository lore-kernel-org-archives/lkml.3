Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaBJUTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:19:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34561 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaBJTli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:41:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cong Ding <dinggnu@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 001/124] KVM: s390: kvm/sigp.c: fix memory leakage
Date: Mon, 10 Feb 2014 11:39:01 -0800
Message-Id: <1392061264-28124-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Ding <dinggnu@gmail.com>

commit a046b816a4587c7898772af7cc7e6798cc8b56dd upstream.

the variable inti should be freed in the branch CPUSTAT_STOPPED.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kvm/sigp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 566ddf6..1278873 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -137,8 +137,10 @@ static int __inject_sigp_stop(struct kvm_s390_local_interrupt *li, int action)
 	inti->type = KVM_S390_SIGP_STOP;
 
 	spin_lock_bh(&li->lock);
-	if ((atomic_read(li->cpuflags) & CPUSTAT_STOPPED))
+	if ((atomic_read(li->cpuflags) & CPUSTAT_STOPPED)) {
+		kfree(inti);
 		goto out;
+	}
 	list_add_tail(&inti->list, &li->list);
 	atomic_set(&li->active, 1);
 	atomic_set_mask(CPUSTAT_STOP_INT, li->cpuflags);
-- 
1.8.3.2

