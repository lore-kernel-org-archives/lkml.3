Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaAPQYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:24:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbaAPQYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:24:42 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, riel@redhat.com, aarcange@redhat.com,
        aquini@redhat.com, mst@redhat.com, rusty@rustcorp.com.au,
        vdavydov@parallels.com, amit.shah@redhat.com, dfediuck@redhat.com,
        agl@us.ibm.com
Subject: [RFC PATCH 2/4] vmpressure in-kernel: hack
Date: Thu, 16 Jan 2014 11:24:03 -0500
Message-Id: <1389889445-3855-3-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1389889445-3855-1-git-send-email-lcapitulino@redhat.com>
References: <1389889445-3855-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luiz capitulino <lcapitulino@redhat.com>

1. Allow drivers to register private data
2. Allow drivers to pass css=NULL
3. Pass level to the callback

Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 include/linux/vmpressure.h |  3 ++-
 mm/vmpressure.c            | 13 +++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index 9102e53..de416b6 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -42,7 +42,8 @@ extern int vmpressure_register_event(struct cgroup_subsys_state *css,
 				     struct eventfd_ctx *eventfd,
 				     const char *args);
 extern int vmpressure_register_kernel_event(struct cgroup_subsys_state *css,
-					    void (*fn)(void));
+				     	    void (*fn)(void *data, int level),
+					    void *data);
 extern void vmpressure_unregister_event(struct cgroup_subsys_state *css,
 					struct cftype *cft,
 					struct eventfd_ctx *eventfd);
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 730e7c1..4ed0e85 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -132,9 +132,10 @@ static enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
 struct vmpressure_event {
 	union {
 		struct eventfd_ctx *efd;
-		void (*fn)(void);
+		void (*fn)(void *data, int level);
 	};
 	enum vmpressure_levels level;
+	void *data;
 	bool kernel_event;
 	struct list_head node;
 };
@@ -152,7 +153,7 @@ static bool vmpressure_event(struct vmpressure *vmpr,
 
 	list_for_each_entry(ev, &vmpr->events, node) {
 		if (ev->kernel_event) {
-			ev->fn();
+			ev->fn(ev->data, level);
 		} else if (vmpr->notify_userspace && level >= ev->level) {
 			eventfd_signal(ev->efd, 1);
 			signalled = true;
@@ -352,21 +353,25 @@ int vmpressure_register_event(struct cgroup_subsys_state *css,
  * well-defined cgroup aware interface.
  */
 int vmpressure_register_kernel_event(struct cgroup_subsys_state *css,
-				      void (*fn)(void))
+				     void (*fn)(void *data, int level), void *data)
 {
-	struct vmpressure *vmpr = css_to_vmpressure(css);
+	struct vmpressure *vmpr;
 	struct vmpressure_event *ev;
 
+	vmpr = css ? css_to_vmpressure(css) : memcg_to_vmpressure(NULL);
+
 	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
 	if (!ev)
 		return -ENOMEM;
 
 	ev->kernel_event = true;
+	ev->data = data;
 	ev->fn = fn;
 
 	mutex_lock(&vmpr->events_lock);
 	list_add(&ev->node, &vmpr->events);
 	mutex_unlock(&vmpr->events_lock);
+
 	return 0;
 }
 
-- 
1.8.1.4

