Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbaIQSDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:03:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbaIQSDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:03:39 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, ebiederm@xmission.com,
        stable@vger.kernel.org.#.v3.10-rc1+
Subject: [PATCH] audit: restore AUDIT_LOGINUID unset ABI
Date: Wed, 17 Sep 2014 14:03:01 -0400
Message-Id: <a2c1c2d57a0491ea6ea38a46b57e25d8e1560074.1410976788.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A regression was caused by commit 780a7654cee8:
	 audit: Make testing for a valid loginuid explicit.
(which in turn attempted to fix a regression caused by e1760bd)

When audit_krule_to_data() fills in the rules to get a listing, there was a
missing clause to convert back from AUDIT_LOGINUID_SET to AUDIT_LOGINUID.

This broke userspace by not returning the same information that was sent and
expected.

The rule:
	auditctl -a exit,never -F auid=-1
gives:
	auditctl -l
		LIST_RULES: exit,never f24=0 syscall=all
when it should give:
		LIST_RULES: exit,never auid=-1 (0xffffffff) syscall=all

Cc: stable@vger.kernel.org # v3.10-rc1+
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditfilter.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 40ed981..d0715a7 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -630,6 +630,13 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 			data->buflen += data->values[i] =
 				audit_pack_string(&bufp, krule->filterkey);
 			break;
+		case AUDIT_LOGINUID_SET:
+			if (!f->val) {
+				data->fields[i] = AUDIT_LOGINUID;
+				data->values[i] = AUDIT_UID_UNSET;
+				break;
+			}
+			/* fallthrough if set */
 		default:
 			data->values[i] = f->val;
 		}
-- 
1.7.1

