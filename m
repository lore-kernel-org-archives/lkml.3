Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab3BZX52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760104Ab3BZX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 040/150] KEYS: Revert one application of "Fix unreachable code" patch
Date: Tue, 26 Feb 2013 15:54:57 -0800
Message-Id: <20130226235528.366051213@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit fe9453a1dcb5fb146f9653267e78f4a558066f6f upstream.

A patch to fix some unreachable code in search_my_process_keyrings() got
applied twice by two different routes upstream as commits e67eab39bee2
and b010520ab3d2 (both "fix unreachable code").

Unfortunately, the second application removed something it shouldn't
have and this wasn't detected by GIT.  This is due to the patch not
having sufficient lines of context to distinguish the two places of
application.

The effect of this is relatively minor: inside the kernel, the keyring
search routines may search multiple keyrings and then prioritise the
errors if no keys or negative keys are found in any of them.  With the
extra deletion, the presence of a negative key in the thread keyring
(causing ENOKEY) is incorrectly overridden by an error searching the
process keyring.

So revert the second application of the patch.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/keys/process_keys.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -367,6 +367,8 @@ key_ref_t search_my_process_keyrings(str
 
 		switch (PTR_ERR(key_ref)) {
 		case -EAGAIN: /* no key */
+			if (ret)
+				break;
 		case -ENOKEY: /* negative key */
 			ret = key_ref;
 			break;


