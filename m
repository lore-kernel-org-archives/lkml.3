Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab3DBWoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:44:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395Ab3DBWMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 090/124] iwlwifi: dvm: dont send HCMD in restart flow
Date: Tue,  2 Apr 2013 15:11:12 -0700
Message-Id: <20130402221114.566302878@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 2d5d50ee596361566f7f84300117cba7d7672bc5 upstream.

There is a race between the restart flow and the workers.
The workers are cancelled after the fw is already killed
and might send HCMD when there is fw to handle them.
Simply check that there is a fw to which the HCMD can be
sent before actually sending it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/lib.c   |    9 +++++++++
 drivers/net/wireless/iwlwifi/dvm/ucode.c |    4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -1262,6 +1262,15 @@ int iwl_dvm_send_cmd(struct iwl_priv *pr
 	}
 
 	/*
+	 * This can happen upon FW ASSERT: we clear the STATUS_FW_ERROR flag
+	 * in iwl_down but cancel the workers only later.
+	 */
+	if (!priv->ucode_loaded) {
+		IWL_ERR(priv, "Fw not loaded - dropping CMD: %x\n", cmd->id);
+		return -EIO;
+	}
+
+	/*
 	 * Synchronous commands from this op-mode must hold
 	 * the mutex, this ensures we don't try to send two
 	 * (or more) synchronous commands at a time.
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -450,6 +450,8 @@ int iwl_load_ucode_wait_alive(struct iwl
 		return -EIO;
 	}
 
+	priv->ucode_loaded = true;
+
 	/*
 	 * This step takes a long time (60-80ms!!) and
 	 * WoWLAN image should be loaded quickly, so
@@ -474,8 +476,6 @@ int iwl_load_ucode_wait_alive(struct iwl
 		return ret;
 	}
 
-	priv->ucode_loaded = true;
-
 	return 0;
 }
 


