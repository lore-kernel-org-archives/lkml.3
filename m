Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbbAGCby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:31:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034AbbAGCQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.17 47/73] userns: Document what the invariant required for safe unprivileged mappings.
Date: Tue,  6 Jan 2015 18:16:08 -0800
Message-Id: <20150107021558.965052679@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 0542f17bf2c1f2430d368f44c8fcf2f82ec9e53e upstream.

The rule is simple.  Don't allow anything that wouldn't be allowed
without unprivileged mappings.

It was previously overlooked that establishing gid mappings would
allow dropping groups and potentially gaining permission to files and
directories that had lesser permissions for a specific group than for
all other users.

This is the rule needed to fix CVE-2014-8989 and prevent any other
security issues with new_idmap_permitted.

The reason for this rule is that the unix permission model is old and
there are programs out there somewhere that take advantage of every
little corner of it.  So allowing a uid or gid mapping to be
established without privielge that would allow anything that would not
be allowed without that mapping will result in expectations from some
code somewhere being violated.  Violated expectations about the
behavior of the OS is a long way to say a security issue.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -812,7 +812,9 @@ static bool new_idmap_permitted(const st
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
-	/* Allow mapping to your own filesystem ids */
+	/* Don't allow mappings that would allow anything that wouldn't
+	 * be allowed without the establishment of unprivileged mappings.
+	 */
 	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {


