Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3EGEAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:00:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab3EGD7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:59:00 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lYUXBsboI_gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=B40x7b9hoHAA:10 a=z11f-joXAAAA:8 a=VwQbUJbxAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=CJVq-v20pXUA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035849.140791177@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [049/126] target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition
 CDBs
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0049-target-Fix-incorrect-fallthrough-of-ALUA-Standby-Off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

[ Upstream commit 30f359a6f9da65a66de8cadf959f0f4a0d498bba ]

This patch fixes a bug where a handful of informational / control CDBs
that should be allowed during ALUA access state Standby/Offline/Transition
where incorrectly returning CHECK_CONDITION + ASCQ_04H_ALUA_TG_PT_*.

This includes INQUIRY + REPORT_LUNS, which would end up preventing LUN
registration when LUN scanning occured during these ALUA access states.

Cc: Hannes Reinecke <hare@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/target/target_core_alua.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 41641ba..61077ce 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -420,6 +420,7 @@ static inline int core_alua_state_standby(
 	case REPORT_LUNS:
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -462,6 +463,7 @@ static inline int core_alua_state_unavailable(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -502,6 +504,7 @@ static inline int core_alua_state_transition(
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
-- 
1.7.10.4


