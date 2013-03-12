Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3CLGIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:08:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:36395 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab3CLGIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:08:10 -0400
Date: Tue, 12 Mar 2013 17:09:06 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT][KEYS] fix race with concurrent install_user_keyrings()
Message-ID: <alpine.LRH.2.02.1303121707360.5527@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please apply.


The following changes since commit 7c6baa304b841673d3a55ea4fcf9a5cbf7a1674b:

  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-03-11 07:54:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

David Howells (1):
      keys: fix race with concurrent install_user_keyrings()

 security/keys/process_keys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 0da9dfdd2cd9889201bc6f6f43580c99165cd087
Author: David Howells <dhowells@redhat.com>
Date:   Tue Mar 12 16:44:31 2013 +1100

    keys: fix race with concurrent install_user_keyrings()
    
    This fixes CVE-2013-1792.
    
    There is a race in install_user_keyrings() that can cause a NULL pointer
    dereference when called concurrently for the same user if the uid and
    uid-session keyrings are not yet created.  It might be possible for an
    unprivileged user to trigger this by calling keyctl() from userspace in
    parallel immediately after logging in.
    
    Assume that we have two threads both executing lookup_user_key(), both
    looking for KEY_SPEC_USER_SESSION_KEYRING.
    
    	THREAD A			THREAD B
    	===============================	===============================
    					==>call install_user_keyrings();
    	if (!cred->user->session_keyring)
    	==>call install_user_keyrings()
    					...
    					user->uid_keyring = uid_keyring;
    	if (user->uid_keyring)
    		return 0;
    	<==
    	key = cred->user->session_keyring [== NULL]
    					user->session_keyring = session_keyring;
    	atomic_inc(&key->usage); [oops]
    
    At the point thread A dereferences cred->user->session_keyring, thread B
    hasn't updated user->session_keyring yet, but thread A assumes it is
    populated because install_user_keyrings() returned ok.
    
    The race window is really small but can be exploited if, for example,
    thread B is interrupted or preempted after initializing uid_keyring, but
    before doing setting session_keyring.
    
    This couldn't be reproduced on a stock kernel.  However, after placing
    systemtap probe on 'user->session_keyring = session_keyring;' that
    introduced some delay, the kernel could be crashed reliably.
    
    Fix this by checking both pointers before deciding whether to return.
    Alternatively, the test could be done away with entirely as it is checked
    inside the mutex - but since the mutex is global, that may not be the best
    way.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Reported-by: Mateusz Guzik <mguzik@redhat.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index a571fad..42defae 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -57,7 +57,7 @@ int install_user_keyrings(void)
 
 	kenter("%p{%u}", user, uid);
 
-	if (user->uid_keyring) {
+	if (user->uid_keyring && user->session_keyring) {
 		kleave(" = 0 [exist]");
 		return 0;
 	}
