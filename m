Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab3JCER4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:17:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3JCERw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:17:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [ 17/57] mei: bus: stop wait for read during cl state transition
Date: Wed,  2 Oct 2013 21:08:43 -0700
Message-Id: <20131003040637.790715440@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit e2b31644e999e8bfe3efce880fb32840299abf41 upstream.

Bus layer omitted check for client state transition while waiting
for read completion
The client state transition may occur for example as result
of firmware initiated reset

Add mei_cl_is_transitioning wrapper to reduce the code
repetition.:

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/bus.c    |    5 ++++-
 drivers/misc/mei/client.h |    6 ++++++
 drivers/misc/mei/main.c   |   11 ++++-------
 3 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -295,10 +295,13 @@ int __mei_cl_recv(struct mei_cl *cl, u8
 
 	if (cl->reading_state != MEI_READ_COMPLETE &&
 	    !waitqueue_active(&cl->rx_wait)) {
+
 		mutex_unlock(&dev->device_lock);
 
 		if (wait_event_interruptible(cl->rx_wait,
-				(MEI_READ_COMPLETE == cl->reading_state))) {
+				cl->reading_state == MEI_READ_COMPLETE  ||
+				mei_cl_is_transitioning(cl))) {
+
 			if (signal_pending(current))
 				return -EINTR;
 			return -ERESTARTSYS;
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -76,6 +76,12 @@ static inline bool mei_cl_cmp_id(const s
 		(cl1->host_client_id == cl2->host_client_id) &&
 		(cl1->me_client_id == cl2->me_client_id);
 }
+static inline bool mei_cl_is_transitioning(struct mei_cl *cl)
+{
+	return (MEI_FILE_INITIALIZING == cl->state ||
+		MEI_FILE_DISCONNECTED == cl->state ||
+		MEI_FILE_DISCONNECTING == cl->state);
+}
 
 
 int mei_cl_flow_ctrl_creds(struct mei_cl *cl);
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -249,19 +249,16 @@ static ssize_t mei_read(struct file *fil
 		mutex_unlock(&dev->device_lock);
 
 		if (wait_event_interruptible(cl->rx_wait,
-			(MEI_READ_COMPLETE == cl->reading_state ||
-			 MEI_FILE_INITIALIZING == cl->state ||
-			 MEI_FILE_DISCONNECTED == cl->state ||
-			 MEI_FILE_DISCONNECTING == cl->state))) {
+				MEI_READ_COMPLETE == cl->reading_state ||
+				mei_cl_is_transitioning(cl))) {
+
 			if (signal_pending(current))
 				return -EINTR;
 			return -ERESTARTSYS;
 		}
 
 		mutex_lock(&dev->device_lock);
-		if (MEI_FILE_INITIALIZING == cl->state ||
-		    MEI_FILE_DISCONNECTED == cl->state ||
-		    MEI_FILE_DISCONNECTING == cl->state) {
+		if (mei_cl_is_transitioning(cl)) {
 			rets = -EBUSY;
 			goto out;
 		}


