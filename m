Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbaKLBds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:33:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264AbaKLBdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:33:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.17 268/319] PM / Sleep: fix async suspend_late/freeze_late error handling
Date: Wed, 12 Nov 2014 10:16:46 +0900
Message-Id: <20141112011037.108296110@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 246ef766743618a7cab059d6c4993270075b173e upstream.

If an asynchronous suspend_late or freeze_late callback fails
during the SUSPEND, FREEZE or QUIESCE phases, we don't propagate the
corresponding error correctly, in effect ignoring the error and
continuing the suspend-to-ram/hibernation. During suspend-to-ram this
could leave some devices without a valid saved context, leading to a
failure to reinitialize them during resume. During hibernation this
could leave some devices active interfeering with the creation /
restoration of the hibernation image. Also this could leave the
corresponding devices without a valid saved context and failure to
reinitialize them during resume.

Fixes: de377b397272 (PM / sleep: Asynchronous threads for suspend_late)
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1266,6 +1266,8 @@ static int dpm_suspend_late(pm_message_t
 	}
 	mutex_unlock(&dpm_list_mtx);
 	async_synchronize_full();
+	if (!error)
+		error = async_error;
 	if (error) {
 		suspend_stats.failed_suspend_late++;
 		dpm_save_failed_step(SUSPEND_SUSPEND_LATE);


