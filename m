Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3DQEYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 00:24:04 -0400
Received: from intranet.asianux.com ([58.214.24.6]:35133 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3DQEYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 00:24:02 -0400
X-Spam-Score: -100.8
Message-ID: <516E23B8.8030700@asianux.com>
Date: Wed, 17 Apr 2013 12:23:20 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] kernel: auditfilter: resource management, tree and watch
 will memory leak when failure occurs
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <2119919725.12278128.1365628773876.JavaMail.root@redhat.com> <516637BB.90606@asianux.com> <5167D6FC.3070504@asianux.com> <516D2718.2010205@asianux.com> <516D2A11.2080502@asianux.com> <516E0BC3.6020302@asianux.com>
In-Reply-To: <516E0BC3.6020302@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  in function audit_data_to_entry:
    when failure occurs, need check and free tree and watch.
    or memory leak.

  test:
    plan:
      test command:
        "auditctl -a exit,always -w /etc -F auid=-1"
        (on fedora17, need modify auditctl to let "-w /etc" has effect)
      running:
        under fedora17 x86_64, 2 CPUs 3.20GHz, 2.5GB RAM.
        let 15 auditctl processes continue running at the same time.
      monitor command: 
        watch -d -n 1 "cat /proc/meminfo | awk '{print \$2}' \
          | head -n 4 | xargs \
          | awk '{print \"used \",\$1 - \$2 - \$3 - \$4}'"

    result:
      for original version:
        will use up all memory, within 3 hours.
        kill all auditctl, the memory still does not free.
      for new version (apply this patch):
        after 14 hours later, not find issues.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/auditfilter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f9fc54b..2674368 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -594,6 +594,10 @@ exit_nofree:
 	return entry;
 
 exit_free:
+	if (entry->rule.watch)
+		audit_put_watch(entry->rule.watch); /* matches initial get */
+	if (entry->rule.tree)
+		audit_put_tree(entry->rule.tree); /* that's the temporary one */
 	audit_free_rule(entry);
 	return ERR_PTR(err);
 }
-- 
1.7.7.6
