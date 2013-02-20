Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935334Ab3BTMY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:24:27 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1507 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935006Ab3BTMYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:24:24 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Shankar Brahadeeswaran" <shankoo77@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
cc: devel@driverdev.osuosl.org, "Cruz Julian Bishop" <cruzjbishop@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Hugh Dickins" <hughd@google.com>,
        "Konstantin Khlebnikov" <khlebnikov@openvz.org>,
        "Shankar Brahadeeswaran" <shankoo77@gmail.com>
Subject: [PATCH 1/1] staging: android: ashmem: get_name,set_name not to
 hold ashmem_mutex
Date: Wed, 20 Feb 2013 17:53:59 +0530
Message-ID: <1361363039-11984-2-git-send-email-shankoo77@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1361363039-11984-1-git-send-email-shankoo77@gmail.com>
References: <1361363039-11984-1-git-send-email-shankoo77@gmail.com>
MIME-Version: 1.0
X-WSS-ID: 7D3A607E23C895433-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
There exists a path in ashmem driver that could lead to acquistion
of mm->mmap_sem, ashmem_mutex in reverse order. This could lead
to deadlock in the system.
For Example, assume that mmap is called on a ashmem region
in the context of a thread say T1.
 sys_mmap_pgoff (1. acquires mm->mmap_sem)
  |
   --> mmap_region
 	|
         ----> ashmem_mmap (2. acquires asmem_mutex)
 Now if there is a context switch after 1 and before 2,
 and if another thread T2 (that shares the mm struct) invokes an
 ioctl say ASHMEM_GET_NAME, this can lead to the following path

ashmem_ioctl
  |
  -->get_name (3. acquires ashmem_mutex)
	|
	---> copy_to_user (4. acquires the mm->mmap_sem)
Note that the copy_to_user could lead to a valid fault if no
physical page is allocated yet for the user address passed.
Now T1 has mmap_sem and is waiting for ashmem_mutex.
and T2 has the ashmem_mutex and is waiting for mmap_sem
Thus leading to deadlock.

Solution:
Do not call copy_to_user or copy_from_user while holding the
ahsmem_mutex. Instead copy this to a local buffer that lives
in the stack while holding this lock. This will maintain data
integrity as well never reverse the lock order.

Testing:
Created a unit test case to reproduce the problem.
Used the same to test this fix on kernel version 3.4.0
Ported the same patch to 3.8

Signed-off-by: Shankar Brahadeeswaran <shankoo77@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/android/ashmem.c |   44 ++++++++++++++++++++++++++++---------
 1 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 634b9ae..9c30ead 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -414,8 +414,7 @@ out:
 static int set_name(struct ashmem_area *asma, void __user *name)
 {
 	int ret = 0;
-
-	mutex_lock(&ashmem_mutex);
+	char local_name[ASHMEM_NAME_LEN];
 
 	/* cannot change an existing mapping's name */
 	if (unlikely(asma->file)) {
@@ -423,9 +422,22 @@ static int set_name(struct ashmem_area *asma, void __user *name)
 		goto out;
 	}
 
-	if (unlikely(copy_from_user(asma->name + ASHMEM_NAME_PREFIX_LEN,
-				    name, ASHMEM_NAME_LEN)))
+	/*
+	 * Holding the ashmem_mutex while doing a copy_from_user might cause
+	 * an data abourt which would try to access mmap_sem. If another
+	 * thread has invoked ashmem_mmap then it will be holding the
+	 * semaphore and will be waiting for ashmem_mutex, there by leading to
+	 * deadlock. We'll release the mutex  and take the name to a local
+	 * variable that does not need protection and later copy the local
+	 * variable to the structure member with lock held.
+	 */
+	if (unlikely(copy_from_user(local_name, name, ASHMEM_NAME_LEN))) {
 		ret = -EFAULT;
+		return ret;
+	}
+	mutex_lock(&ashmem_mutex);
+	memcpy(asma->name + ASHMEM_NAME_PREFIX_LEN,
+		local_name, ASHMEM_NAME_LEN);
 	asma->name[ASHMEM_FULL_NAME_LEN-1] = '\0';
 
 out:
@@ -437,26 +449,36 @@ out:
 static int get_name(struct ashmem_area *asma, void __user *name)
 {
 	int ret = 0;
+	size_t len;
+	/*
+	 * Have a local variable to which we'll copy the content
+	 * from asma with the lock held. Later we can copy this to the user
+	 * space safely without holding any locks. So even if we proceed to
+	 * wait for mmap_sem, it won't lead to deadlock.
+	 */
+	char local_name[ASHMEM_NAME_LEN];
 
 	mutex_lock(&ashmem_mutex);
 	if (asma->name[ASHMEM_NAME_PREFIX_LEN] != '\0') {
-		size_t len;
 
 		/*
 		 * Copying only `len', instead of ASHMEM_NAME_LEN, bytes
 		 * prevents us from revealing one user's stack to another.
 		 */
 		len = strlen(asma->name + ASHMEM_NAME_PREFIX_LEN) + 1;
-		if (unlikely(copy_to_user(name,
-				asma->name + ASHMEM_NAME_PREFIX_LEN, len)))
-			ret = -EFAULT;
+		memcpy(local_name, asma->name + ASHMEM_NAME_PREFIX_LEN, len);
 	} else {
-		if (unlikely(copy_to_user(name, ASHMEM_NAME_DEF,
-					  sizeof(ASHMEM_NAME_DEF))))
-			ret = -EFAULT;
+		len = sizeof(ASHMEM_NAME_DEF);
+		memcpy(local_name, ASHMEM_NAME_DEF, len);
 	}
 	mutex_unlock(&ashmem_mutex);
 
+	/*
+	 * Now we are just copying from the stack variable to userland
+	 * No lock held
+	 */
+	if (unlikely(copy_to_user(name, local_name, len)))
+		ret = -EFAULT;
 	return ret;
 }
 
-- 
1.7.6


