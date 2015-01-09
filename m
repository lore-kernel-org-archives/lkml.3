Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbbAII2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:28:14 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11914 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbbAII2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:28:11 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e5-54af911985f7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] PM / QoS: Use lockdep asserts to find missing hold of
 power.lock
Date: Fri, 09 Jan 2015 09:27:58 +0100
Message-id: <1420792078-14132-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420792078-14132-1-git-send-email-k.kozlowski@samsung.com>
References: <1420792078-14132-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xq7qSE9eHGGxbxmLRvHg9m8XrF4YW
	s6bsZbK4vGsOm8Xn3iOMFndPHWWzOHP6EqsDu8fiPS+ZPPbPXcPuseVqO4tH35ZVjB4rVn9n
	9/i8SS6ALYrLJiU1J7MstUjfLoErY+Ha6oJ2jop/T96xNTA+Yeti5OSQEDCRWDdhKiuELSZx
	4d56oDgXh5DAUkaJWd+mgSWEBPqYJL638IPYbALGEpuXLwErEhG4xijx4PkDZpAEs4ChxM93
	f9hBbGGBcInPWxcygdgsAqoSPbteAA3i4OAVcJfY8aEWYpmcxMljk8Hmcwp4SEw4eJMdYpe7
	xJH2LvYJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE1pcdjIuPWR1iFOBgVOLh
	3aG6PkSINbGsuDL3EKMEB7OSCK+sJVCINyWxsiq1KD++qDQntfgQIxMHp1QD4+Z9H20UMlI0
	opTE7Dqywme+7LxcKH6ha/ffppLlSeeZ93a95NhcPeVvQPHabRz60e7CT/Pk/xR+n/+S+zxj
	+4fYDPfEyjiro/cXrtpqeZYtVrjx0aTGb4IT79ub/gq5MTfnrVbhuoYX587vZn9Wa3Mzzomr
	/dWal4wH2LIP2T+cmqTqmKN0TImlOCPRUIu5qDgRACnz71wLAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lockdep asserts for holding the dev->power.lock to non-static
functions which require this. They could be used outside of the file so
asserts may help in detecting locking misuse.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/base/power/qos.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/power/qos.c b/drivers/base/power/qos.c
index a8fe4c1a8d07..e56d538d039e 100644
--- a/drivers/base/power/qos.c
+++ b/drivers/base/power/qos.c
@@ -64,6 +64,8 @@ enum pm_qos_flags_status __dev_pm_qos_flags(struct device *dev, s32 mask)
 	struct pm_qos_flags *pqf;
 	s32 val;
 
+	lockdep_assert_held(&dev->power.lock);
+
 	if (IS_ERR_OR_NULL(qos))
 		return PM_QOS_FLAGS_UNDEFINED;
 
@@ -104,6 +106,8 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_flags);
  */
 s32 __dev_pm_qos_read_value(struct device *dev)
 {
+	lockdep_assert_held(&dev->power.lock);
+
 	return IS_ERR_OR_NULL(dev->power.qos) ?
 		0 : pm_qos_read_value(&dev->power.qos->resume_latency);
 }
-- 
1.9.1

