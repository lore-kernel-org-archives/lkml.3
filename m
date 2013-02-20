Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935464Ab3BTO1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:27:43 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3445 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758613Ab3BTO1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:27:40 -0500
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
Subject: [PATCH V2 1/1] staging: android: ashmem: get_name,set_name not
 to hold ashmem_mutex
Date: Wed, 20 Feb 2013 19:57:08 +0530
Message-ID: <1361370428-30632-2-git-send-email-shankoo77@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1361370428-30632-1-git-send-email-shankoo77@gmail.com>
References: <1361363039-11984-2-git-send-email-shankoo77@gmail.com>
 <1361370428-30632-1-git-send-email-shankoo77@gmail.com>
MIME-Version: 1.0
X-WSS-ID: 7D3A035323C965878-01-01
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
 drivers/staging/android/ashmem.c |   56 ++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 634b9ae..497d044 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -413,50 +413,66 @@ out:
 
 static int set_name(struct ashmem_area *asma, void __user *name)
 {
-	int ret = 0;
-
-	mutex_lock(&ashmem_mutex);
+	char local_name[ASHMEM_NAME_LEN];
 
 	/* cannot change an existing mapping's name */
-	if (unlikely(asma->file)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (unlikely(asma->file))
+		return -EINVAL;
 
-	if (unlikely(copy_from_user(asma->name + ASHMEM_NAME_PREFIX_LEN,
-				    name, ASHMEM_NAME_LEN)))
-		ret = -EFAULT;
-	asma->name[ASHMEM_FULL_NAME_LEN-1] = '\0';
+	/*
+	 * Holding the ashmem_mutex while doing a copy_from_user might cause
+	 * an data abourt which would try to access mmap_sem. If another
+	 * thread has invoked ashmem_mmap then it will be holding the
+	 * semaphore and will be waiting for ashmem_mutex, there by leading to
+	 * deadlock. We'll release the mutex  and take the name to a local
+	 * variable that does not need protection and later copy the local
+	 * variable to the structure member with lock held.
+	 */
+	if (unlikely(copy_from_user(local_name, name, ASHMEM_NAME_LEN)))
+		return -EFAULT;
 
-out:
+	mutex_lock(&ashmem_mutex);
+	memcpy(asma->name + ASHMEM_NAME_PREFIX_LEN,
+		local_name, ASHMEM_NAME_LEN);
+	asma->name[ASHMEM_FULL_NAME_LEN-1] = '\0';
 	mutex_unlock(&ashmem_mutex);
 
-	return ret;
+	return 0;
 }
 
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


