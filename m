Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346Ab3BMSEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:04:34 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52277 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965035Ab3BMSDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:03:01 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steve French <smfrench@gmail.com>
Date: Wed, 13 Feb 2013 09:52:11 -0800
Message-Id: <1360777934-5663-82-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/SuUoAmv/OENkqMfrNt8cL1obsVkTFPPk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0077]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 82/85] cifs: Modify struct smb_vol to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Add two helper functions get_option_uid and get_option_gid to handle
the work of parsing uid and gids paramaters from the command line and
making kuids and kgids out of them.

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/cifs/cifsglob.h |   10 +++++-----
 fs/cifs/connect.c  |   50 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 04aa74e..e308e8b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -399,11 +399,11 @@ struct smb_vol {
 	char *iocharset;  /* local code page for mapping to and from Unicode */
 	char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* clnt nb name */
 	char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* srvr nb name */
-	uid_t cred_uid;
-	uid_t linux_uid;
-	gid_t linux_gid;
-	uid_t backupuid;
-	gid_t backupgid;
+	kuid_t cred_uid;
+	kuid_t linux_uid;
+	kgid_t linux_gid;
+	kuid_t backupuid;
+	kgid_t backupgid;
 	umode_t file_mode;
 	umode_t dir_mode;
 	unsigned secFlg;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5411694..9bd13a7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -987,6 +987,41 @@ static int get_option_ul(substring_t args[], unsigned long *option)
 	return rc;
 }
 
+static int get_option_uid(substring_t args[], kuid_t *result)
+{
+	unsigned long value;
+	kuid_t uid;
+	int rc;
+
+	rc = get_option_ul(args, &value);
+	if (rc)
+		return rc;
+
+	uid = make_kuid(current_user_ns(), value);
+	if (!uid_valid(uid))
+		return -EINVAL;
+
+	*result = uid;
+	return 0;
+}
+
+static int get_option_gid(substring_t args[], kgid_t *result)
+{
+	unsigned long value;
+	kgid_t gid;
+	int rc;
+
+	rc = get_option_ul(args, &value);
+	if (rc)
+		return rc;
+
+	gid = make_kgid(current_user_ns(), value);
+	if (!gid_valid(gid))
+		return -EINVAL;
+
+	*result = gid;
+	return 0;
+}
 
 static int cifs_parse_security_flavors(char *value,
 				       struct smb_vol *vol)
@@ -1424,47 +1459,42 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 		/* Numeric Values */
 		case Opt_backupuid:
-			if (get_option_ul(args, &option)) {
+			if (get_option_uid(args, &vol->backupuid)) {
 				cERROR(1, "%s: Invalid backupuid value",
 					__func__);
 				goto cifs_parse_mount_err;
 			}
-			vol->backupuid = option;
 			vol->backupuid_specified = true;
 			break;
 		case Opt_backupgid:
-			if (get_option_ul(args, &option)) {
+			if (get_option_gid(args, &vol->backupgid)) {
 				cERROR(1, "%s: Invalid backupgid value",
 					__func__);
 				goto cifs_parse_mount_err;
 			}
-			vol->backupgid = option;
 			vol->backupgid_specified = true;
 			break;
 		case Opt_uid:
-			if (get_option_ul(args, &option)) {
+			if (get_option_uid(args, &vol->linux_uid)) {
 				cERROR(1, "%s: Invalid uid value",
 					__func__);
 				goto cifs_parse_mount_err;
 			}
-			vol->linux_uid = option;
 			uid_specified = true;
 			break;
 		case Opt_cruid:
-			if (get_option_ul(args, &option)) {
+			if (get_option_uid(args, &vol->cred_uid)) {
 				cERROR(1, "%s: Invalid cruid value",
 					__func__);
 				goto cifs_parse_mount_err;
 			}
-			vol->cred_uid = option;
 			break;
 		case Opt_gid:
-			if (get_option_ul(args, &option)) {
+			if (get_option_gid(args, &vol->linux_gid)) {
 				cERROR(1, "%s: Invalid gid value",
 						__func__);
 				goto cifs_parse_mount_err;
 			}
-			vol->linux_gid = option;
 			gid_specified = true;
 			break;
 		case Opt_file_mode:
-- 
1.7.5.4

