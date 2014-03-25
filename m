Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaCYHTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 03:19:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36303 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaCYHTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 03:19:08 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-5a-53312de93afc
Message-id: <53312DE7.6040803@samsung.com>
Date: Tue, 25 Mar 2014 08:19:03 +0100
From: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: linux-kernel@vger.kernel.org
Cc: j.pielaszkie@samsung.com
Subject: Fwd: [SMACK]Problem with user naespace
References: <53304E00.3060405@samsung.com>
In-reply-to: <53304E00.3060405@samsung.com>
X-Forwarded-Message-Id: <53304E00.3060405@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t/xq7ovdQ2DDaZ/N7BY9modo8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+PgjhfMBRfNK2Y3r2dsYFyg2cXIySEhYCLx
	/NEuFghbTOLCvfVsILaQwFJGiQtvOSHsz4wSSyfKdTFycPAKaElM7hMDCbMIqEqseLGeFcRm
	EzCVuLljMiOILSoQITF34mawMbwCghI/Jt8DGy8ioCCxufcZWD2zgIzE4omHweqFBfQl7r6d
	ygyxSkti5sdesHpOAW2J/VNOsICslRAwk1j1KA6i1UziUcs6ZghbXmLzmrfMExgFZyHZNgtJ
	2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihITp1x2MS49ZHWIU4GBU4uHdYGoQ
	LMSaWFZcmXuIUYKDWUmEl1/HMFiINyWxsiq1KD++qDQntfgQIxMHp1QDo+lSE8MDG0sLcx37
	VGP0Hv75V+lweMPp/rctwQv9q+f/qlKsX771hM8Ljh2lJmWptY+3XVhlP/lG39PLq68mLllW
	9jtyw3RJ1qMrvU9lCXn1rJ22axNjZNLs/mz7yeK7mcurJgvV+hfY3yrdqavu9eFd/gTN400m
	0b7W7FfFwn1az+fNeNS/UYmlOCPRUIu5qDgRALpPXM4xAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

     I have problem with starting lxc containers when SMACK is enabled
on the host. The issue appears when systemd try start user session in
the container. In such case systemd reports error that has not
permissions to set SMACK label. In my test configuration lxc container
has full separation (all namespaces are enabled - including user namespace).
     The issue is common. The problem is due to lack of permissions of
the task to write into /proc/self/sttr/current file even the task has
active CAP_MAC_ADMIN capability. Regarding to may tests the issue is
connected to user namespace.

     I have prepared patch (see below). The patch was tested and created
on kernel 3.10.

 From 1d42d88fccafb7a9fa279588bc827163484a7852 Mon Sep 17 00:00:00 2001
From: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
Date: Mon, 24 Mar 2014 14:11:58 +0100
Subject: [PATCH] [PATCH] Enable user namespace in SMACK

SMACK: Enable user namespace

- Bug/Issue:
The issue has been found when we tried to setup lxc container.
We tried to setup the container with active all linux namespaces
(including user namespace). On the host as LSM was enabled SMACK.

We have found that "systemd" was not able to setup user sessiondue
to lack of permissions to write into /proc/self/attr/currentfile.

We have found general issue that any privileged process with
enabled CAP_MAC_ADMIN cannot write into /proc/self/attr/currentfile.

- Cause:
SMACK to check the task capabilities uses capable().

- Solution:
The fix replaces usage capable() by ns_capable().

Becuase SMACK uses globally defined rules usage ns_capable()
was limited to places where requested by task operation
are connected to himself. All operation that modify global SMACK
rules remain unchanged - SMACK still to test capabilities
calls capable(). It means that operation on smackfs remain
unchanged - operation are allowed only by host.

Change-Id: I0bb28fa02943dd7ccb38dda2c8a37dcce2d551b2
Signed-off-by: Jacek Pielaszkiewicz <j.pielaszkie@samsung.com>
---
  security/smack/smack.h        | 13 +++++++++++++
  security/smack/smack_access.c |  2 +-
  security/smack/smack_lsm.c    | 16 ++++++++--------
  3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index d072fd3..9f9d5e7 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -319,6 +319,19 @@ static inline int smack_privileged(int cap)
  }

  /*
+ * Is the task privileged and allowed to privileged
+ * by the onlycap rule in user namespace.
+ */
+static inline int smack_privileged_ns(int cap)
+{
+       if (!ns_capable(current_user_ns(), cap))
+               return 0;
+       if (smack_onlycap == NULL || smack_onlycap == smk_of_current())
+               return 1;
+       return 0;
+}
+
+/*
   * logging functions
   */
  #define SMACK_AUDIT_DENIED 0x1
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 14293cd..07d25f5 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -230,7 +230,7 @@ int smk_curacc(char *obj_label, u32 mode, struct
smk_audit_info *a)
         /*
          * Allow for priviliged to override policy.
          */
-       if (rc != 0 && smack_privileged(CAP_MAC_OVERRIDE))
+       if (rc != 0 && smack_privileged_ns(CAP_MAC_OVERRIDE))
                 rc = 0;

  out_audit:
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index cdbf92b..3cc6842 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -226,7 +226,7 @@ static int smack_syslog(int typefrom_file)
         int rc = 0;
         struct smack_known *skp = smk_of_current();

-       if (smack_privileged(CAP_MAC_OVERRIDE))
+       if (smack_privileged_ns(CAP_MAC_OVERRIDE))
                 return 0;

          if (smack_syslog_label != NULL && smack_syslog_label != skp)
@@ -842,7 +842,7 @@ static int smack_inode_setxattr(struct dentry
*dentry, const char *name,
             strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
             strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
             strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
-               if (!smack_privileged(CAP_MAC_ADMIN))
+               if (!smack_privileged_ns(CAP_MAC_ADMIN))
                         rc = -EPERM;
                 /*
                  * check label validity here so import wont fail on
@@ -852,7 +852,7 @@ static int smack_inode_setxattr(struct dentry
*dentry, const char *name,
                     smk_import(value, size) == NULL)
                         rc = -EINVAL;
         } else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
-               if (!smack_privileged(CAP_MAC_ADMIN))
+               if (!smack_privileged_ns(CAP_MAC_ADMIN))
                         rc = -EPERM;
                 if (size != TRANS_TRUE_SIZE ||
                     strncmp(value, TRANS_TRUE, TRANS_TRUE_SIZE) != 0)
@@ -950,7 +950,7 @@ static int smack_inode_removexattr(struct dentry
*dentry, const char *name)
             strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
             strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0 ||
             strcmp(name, XATTR_NAME_SMACKMMAP)) {
-               if (!smack_privileged(CAP_MAC_ADMIN))
+               if (!smack_privileged_ns(CAP_MAC_ADMIN))
                         rc = -EPERM;
         } else
                 rc = cap_inode_removexattr(dentry, name);
@@ -1342,7 +1342,7 @@ static int smack_file_send_sigiotask(struct
task_struct *tsk,
         /* we don't log here as rc can be overriden */
         skp = smk_find_entry(file->f_security);
         rc = smk_access(skp, tkp->smk_known, MAY_WRITE, NULL);
-       if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
+       if (rc != 0 && has_ns_capability(tsk, current_user_ns(),
CAP_MAC_OVERRIDE))
                 rc = 0;

         smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
@@ -2924,7 +2924,7 @@ static int smack_setprocattr(struct task_struct
*p, char *name,
         if (p != current)
                 return -EPERM;

-       if (!smack_privileged(CAP_MAC_ADMIN))
+       if (!smack_privileged_ns(CAP_MAC_ADMIN))
                 return -EPERM;

         if (value == NULL || size == 0 || size >= SMK_LONGLABEL)
@@ -2980,7 +2980,7 @@ static int smack_unix_stream_connect(struct sock
*sock,
         smk_ad_setfield_u_net_sk(&ad, other);
  #endif

-       if (!smack_privileged(CAP_MAC_OVERRIDE)) {
+       if (!smack_privileged_ns(CAP_MAC_OVERRIDE)) {
                 skp = ssp->smk_out;
                 rc = smk_access(skp, osp->smk_in, MAY_WRITE, &ad);
         }
@@ -3018,7 +3018,7 @@ static int smack_unix_may_send(struct socket
*sock, struct socket *other)
         smk_ad_setfield_u_net_sk(&ad, other->sk);
  #endif

-       if (smack_privileged(CAP_MAC_OVERRIDE))
+       if (smack_privileged_ns(CAP_MAC_OVERRIDE))
                 return 0;

         skp = ssp->smk_out;
-- 
1.8.3.2


I will be grateful for comments


Best regards

Jacek Pielaszkiewicz



