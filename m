Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaECWsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 18:48:40 -0400
Received: from mail.siteground.com ([67.19.240.234]:44596 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaECWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 18:48:39 -0400
Message-ID: <5365723D.7030303@1h.com>
Date: Sun, 04 May 2014 01:48:29 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, davidlohr@hp.com, n-horiguchi@ah.jp.nec.com,
        Greg KH <gregkh@linuxfoundation.org>, manfred@colorfullife.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] IPC initialize shmmax and shmall from the current value not
 the default
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are creating new IPC namespace that should be cloned from the current namespace it is a good idea to copy the 
values of the current shmmax and shmall to the new namespace.

Copying the values of the init_ipc_ns would allow us to create new ipc namespaces with different values without granting 
them privileges to change those values.

Here is the proposed patch:

---
  ipc/shm.c | 9 +++++++--
  1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 7a51443..b7a4728 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -74,8 +74,13 @@ static int sysvipc_shm_proc_show(struct seq_file *s, void *it);

  void shm_init_ns(struct ipc_namespace *ns)
  {
-       ns->shm_ctlmax = SHMMAX;
-       ns->shm_ctlall = SHMALL;
+       if (ns == &init_ipc_ns) {
+               ns->shm_ctlmax = SHMMAX;
+               ns->shm_ctlall = SHMALL;
+       } else {
+               ns->shm_ctlmax = init_ipc_ns.shm_ctlmax;
+               ns->shm_ctlall = init_ipc_ns.shm_ctlall;
+       }
         ns->shm_ctlmni = SHMMNI;
         ns->shm_rmid_forced = 0;
         ns->shm_tot = 0;
-- 
1.8.4

-- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
