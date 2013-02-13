Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956Ab3BMRxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:53:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53688 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964923Ab3BMRxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:53:02 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>
Date: Wed, 13 Feb 2013 09:50:56 -0800
Message-Id: <1360777934-5663-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18V52/OJmQFUQz9E9WGBRJGWb8+e8LG0Yo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0089]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 07/85] 9p: Add 'u' and 'g' format specifies for kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

This allows concentrating all of the conversion to and from kuids and
kgids into the format needed by the 9p protocol into one location.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/9p/protocol.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 3d33ecf..c289c6c 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -85,6 +85,8 @@ pdu_write_u(struct p9_fcall *pdu, const char __user *udata, size_t size)
 	d - int32_t
 	q - int64_t
 	s - string
+	u - numeric uid
+	g - numeric gid
 	S - stat
 	Q - qid
 	D - data blob (int32_t size followed by void *, results are not freed)
@@ -163,6 +165,26 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
 					(*sptr)[len] = 0;
 			}
 			break;
+		case 'u': {
+				kuid_t *uid = va_arg(ap, kuid_t *);
+				__le32 le_val;
+				if (pdu_read(pdu, &le_val, sizeof(le_val))) {
+					errcode = -EFAULT;
+					break;
+				}
+				*uid = make_kuid(&init_user_ns,
+						 le32_to_cpu(le_val));
+			} break;
+		case 'g': {
+				kgid_t *gid = va_arg(ap, kgid_t *);
+				__le32 le_val;
+				if (pdu_read(pdu, &le_val, sizeof(le_val))) {
+					errcode = -EFAULT;
+					break;
+				}
+				*gid = make_kgid(&init_user_ns,
+						 le32_to_cpu(le_val));
+			} break;
 		case 'Q':{
 				struct p9_qid *qid =
 				    va_arg(ap, struct p9_qid *);
@@ -377,6 +399,20 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
 					errcode = -EFAULT;
 			}
 			break;
+		case 'u': {
+				kuid_t uid = va_arg(ap, kuid_t);
+				__le32 val = cpu_to_le32(
+						from_kuid(&init_user_ns, uid));
+				if (pdu_write(pdu, &val, sizeof(val)))
+					errcode = -EFAULT;
+			} break;
+		case 'g': {
+				kgid_t gid = va_arg(ap, kgid_t);
+				__le32 val = cpu_to_le32(
+						from_kgid(&init_user_ns, gid));
+				if (pdu_write(pdu, &val, sizeof(val)))
+					errcode = -EFAULT;
+			} break;
 		case 'Q':{
 				const struct p9_qid *qid =
 				    va_arg(ap, const struct p9_qid *);
-- 
1.7.5.4

