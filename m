Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3EPPrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab3EPPre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:47:34 -0400
Date: Thu, 16 May 2013 17:43:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] usermodehelper: check subprocess_info->path != NULL
Message-ID: <20130516154355.GB19060@redhat.com>
References: <20130515201158.GA14606@redhat.com> <20130516154323.GA19060@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516154323.GA19060@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

argv_split(empty_or_all_spaces) happily succeeds, it simply returns
argc == 0 and argv[0] == NULL. Change call_usermodehelper_exec() to
check sub_info->path != NULL to avoid the crash.

This is the minimal fix, todo:

	- perhaps we should change argv_split() to return NULL or
	  change the callers.

	- kill or justify ->path[0] check

	- narrow the scope of helper_lock()

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/kmod.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 1296e72..8241906 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -569,6 +569,11 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	int retval = 0;
 
 	helper_lock();
+	if (!sub_info->path) {
+		retval = -EINVAL;
+		goto out;
+	}
+
 	if (sub_info->path[0] == '\0')
 		goto out;
 
-- 
1.5.5.1


