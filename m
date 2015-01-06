Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbbAFPZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:25:06 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:48615 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbbAFPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:25:04 -0500
Date: Tue, 6 Jan 2015 10:24:59 -0500
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 percpu/for-3.20] percpu_ref: implement
 percpu_ref_is_dying()
Message-ID: <20150106152459.GE3077@htj.dyndns.org>
References: <20150106152347.GD3077@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106152347.GD3077@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement percpu_ref_is_dying() which tests whether the ref is dying
or dead.  This is useful to determine the current state when a
percpu_ref is used as a cyclic on/off switch via kill and reinit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
Hello,

This will be used by the scheduled cgroup writeback support.  I'm
applying these two to percpu/for-3.20.

Thanks.

 include/linux/percpu-refcount.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -295,6 +295,20 @@ static inline void percpu_ref_put(struct
 }
 
 /**
+ * percpu_ref_is_dying - test whether a percpu refcount is dying or dead
+ * @ref: percpu_ref to test
+ *
+ * Returns %true if @ref is dying or dead.
+ *
+ * This function is safe to call as long as @ref is between init and exit
+ * and the caller is responsible for synchronizing against state changes.
+ */
+static inline bool percpu_ref_is_dying(struct percpu_ref *ref)
+{
+	return ref->percpu_count_ptr & __PERCPU_REF_DEAD;
+}
+
+/**
  * percpu_ref_is_zero - test whether a percpu refcount reached zero
  * @ref: percpu_ref to test
  *
