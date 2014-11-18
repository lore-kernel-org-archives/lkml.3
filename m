Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbaKROvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:51:49 -0500
Received: from mout.web.de ([212.227.17.11]:51390 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbaKROvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:51:44 -0500
Message-ID: <546B5CF3.1070203@users.sourceforge.net>
Date: Tue, 18 Nov 2014 15:51:31 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] fs-proc: One function call less in proc_sys_lookup()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:BlANFqZ3m6hbh2MvUN7Id+aSr6ODqKA+S+CIZfb4CrWRlhA6PME
 d02Fa/1r3RQ/FwkU44zQKtOKt4uL/+gZtRayx0FxV/SA+HP4q9wOPqAlDmitgSfek0KOIQn
 lKpY5GttMUQXn4SKATVJgwL0pGPnh6UmNHOTM+3ByhqtWoWUpRw02Yge+AoioTkGqa5pZtr
 0vc2hQJJBLMwbty9r5UEA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 18 Nov 2014 15:42:43 +0100

The sysctl_head_finish() function was called in an inefficient way by the
implementation of the proc_sys_lookup() function in case of a lookup failure.
The corresponding source code was improved by deletion of an unnecessary
null pointer check and a few adjustments for jump labels.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/proc/proc_sysctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f92d5dd..6606aaf 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -457,21 +457,21 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 		ret = sysctl_follow_link(&h, &p, current->nsproxy);
 		err = ERR_PTR(ret);
 		if (ret)
-			goto out;
+			goto inode_failure;
 	}
 
 	err = ERR_PTR(-ENOMEM);
 	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
 	if (!inode)
-		goto out;
+		goto inode_failure;
 
 	err = NULL;
 	d_set_d_op(dentry, &proc_sys_dentry_operations);
 	d_add(dentry, inode);
 
+inode_failure:
+	sysctl_head_finish(h);
 out:
-	if (h)
-		sysctl_head_finish(h);
 	sysctl_head_finish(head);
 	return err;
 }
-- 
2.1.3

