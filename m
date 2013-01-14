Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab3ANVkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:40:08 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:54115 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab3ANVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:40:05 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] s390: kvm/sigp.c: fix memory leakage
Date: Mon, 14 Jan 2013 22:39:54 +0100
Message-Id: <1358199594-15594-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable inti should be freed in the branch CPUSTAT_STOPPED.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/s390/kvm/sigp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 461e841..1c48ab2 100644
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
1.7.9.5

