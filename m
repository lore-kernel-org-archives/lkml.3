Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289Ab3DOCoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:44:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934190Ab3DOCn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [ 16/27] target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs
Date: Sun, 14 Apr 2013 19:43:15 -0700
Message-Id: <20130415024232.569495413@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 30f359a6f9da65a66de8cadf959f0f4a0d498bba upstream.

This patch fixes a bug where a handful of informational / control CDBs
that should be allowed during ALUA access state Standby/Offline/Transition
where incorrectly returning CHECK_CONDITION + ASCQ_04H_ALUA_TG_PT_*.

This includes INQUIRY + REPORT_LUNS, which would end up preventing LUN
registration when LUN scanning occured during these ALUA access states.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_alua.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -408,6 +408,7 @@ static inline int core_alua_state_standb
 	case REPORT_LUNS:
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -450,6 +451,7 @@ static inline int core_alua_state_unavai
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -490,6 +492,7 @@ static inline int core_alua_state_transi
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:


