Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab3AZCVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 21:21:46 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53964 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3AZCVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 21:21:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Aristeu Rozanski <aris@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <87ehh8it9s.fsf@xmission.com>
Date: Fri, 25 Jan 2013 18:21:00 -0800
In-Reply-To: <87ehh8it9s.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 25 Jan 2013 18:15:43 -0800")
Message-ID: <87zjzwhegj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+IvBqkwc9qjVInftI8X/l15O0fh5bvGUs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1895]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 2/6] userns: Allow any uid or gid mappings that don't overlap.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I initially wrote the code for /proc/<pid>/uid_map.  I was lazy
and avoided duplicate mappings by the simple expedient of ensuring the
first number in a new extent was greater than any number in the
previous extent.

Unfortunately that precludes a number of valid mappings, and someone
noticed and complained.  So use a simple check to ensure that ranges
in the mapping extents don't overlap.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/user_namespace.c |   45 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 24f8ec3..8b65083 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -520,6 +520,42 @@ struct seq_operations proc_projid_seq_operations = {
 	.show = projid_m_show,
 };
 
+static bool mappings_overlap(struct uid_gid_map *new_map, struct uid_gid_extent *extent)
+{
+	u32 upper_first, lower_first, upper_last, lower_last;
+	unsigned idx;
+
+	upper_first = extent->first;
+	lower_first = extent->lower_first;
+	upper_last = upper_first + extent->count - 1;
+	lower_last = lower_first + extent->count - 1;
+
+	for (idx = 0; idx < new_map->nr_extents; idx++) {
+		u32 prev_upper_first, prev_lower_first;
+		u32 prev_upper_last, prev_lower_last;
+		struct uid_gid_extent *prev;
+
+		prev = &new_map->extent[idx];
+
+		prev_upper_first = prev->first;
+		prev_lower_first = prev->lower_first;
+		prev_upper_last = prev_upper_first + prev->count - 1;
+		prev_lower_last = prev_lower_first + prev->count - 1;
+
+		/* Does the upper range intersect a previous extent? */
+		if ((prev_upper_first <= upper_last) &&
+		    (prev_upper_last >= upper_first))
+			return true;
+
+		/* Does the lower range intersect a previous extent? */
+		if ((prev_lower_first <= lower_last) &&
+		    (prev_lower_last >= lower_first))
+			return true;
+	}
+	return false;
+}
+
+
 static DEFINE_MUTEX(id_map_mutex);
 
 static ssize_t map_write(struct file *file, const char __user *buf,
@@ -532,7 +568,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	struct user_namespace *ns = seq->private;
 	struct uid_gid_map new_map;
 	unsigned idx;
-	struct uid_gid_extent *extent, *last = NULL;
+	struct uid_gid_extent *extent = NULL;
 	unsigned long page = 0;
 	char *kbuf, *pos, *next_line;
 	ssize_t ret = -EINVAL;
@@ -635,14 +671,11 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 		if ((extent->lower_first + extent->count) <= extent->lower_first)
 			goto out;
 
-		/* For now only accept extents that are strictly in order */
-		if (last &&
-		    (((last->first + last->count) > extent->first) ||
-		     ((last->lower_first + last->count) > extent->lower_first)))
+		/* Do the ranges in extent overlap any previous extents? */
+		if (mappings_overlap(&new_map, extent))
 			goto out;
 
 		new_map.nr_extents++;
-		last = extent;
 
 		/* Fail if the file contains too many extents */
 		if ((new_map.nr_extents == UID_GID_MAP_MAX_EXTENTS) &&
-- 
1.7.5.4

