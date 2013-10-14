Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab3JNSon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:44:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3JNSol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:44:41 -0400
Message-ID: <525C3B92.5060700@canonical.com>
Date: Mon, 14 Oct 2013 11:44:34 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>
CC: SECURITY SUBSYSTEM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] apparmor: fix memleak of the profile hash
References: <525906EE.90409@canonical.com> <alpine.LRH.2.02.1310150220160.6053@tundra.namei.org> <525C39E2.4030507@canonical.com>
In-Reply-To: <525C39E2.4030507@canonical.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1235523

This fixes the following kmemleak trace:
unreferenced object 0xffff8801e8c35680 (size 32):
  comm "apparmor_parser", pid 691, jiffies 4294895667 (age 13230.876s)
  hex dump (first 32 bytes):
    e0 d3 4e b5 ac 6d f4 ed 3f cb ee 48 1c fd 40 cf  ..N..m..?..H..@.
    5b cc e9 93 00 00 00 00 00 00 00 00 00 00 00 00  [...............
  backtrace:
    [<ffffffff817a97ee>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811ca9f3>] __kmalloc+0x103/0x290
    [<ffffffff8138acbc>] aa_calc_profile_hash+0x6c/0x150
    [<ffffffff8138074d>] aa_unpack+0x39d/0xd50
    [<ffffffff8137eced>] aa_replace_profiles+0x3d/0xd80
    [<ffffffff81376937>] profile_replace+0x37/0x50
    [<ffffffff811e9f2d>] vfs_write+0xbd/0x1e0
    [<ffffffff811ea96c>] SyS_write+0x4c/0xa0
    [<ffffffff817ccb1d>] system_call_fastpath+0x1a/0x1f
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 345bec0..705c287 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -610,6 +610,7 @@ void aa_free_profile(struct aa_profile *profile)
 	aa_put_dfa(profile->policy.dfa);
 	aa_put_replacedby(profile->replacedby);
 
+	kzfree(profile->hash);
 	kzfree(profile);
 }
 
-- 
1.8.3.2

