Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3LTJnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:43:12 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56156 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab3LTJlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:41:37 -0500
X-AuditID: 85900ec0-cff26b9000001514-bf-52b410cfed0b
Subject: [PATCH 0/2] [BUGFIX] printk: Fix message continuation breakage
 involved with structured printk
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Date: Fri, 20 Dec 2013 18:41:34 +0900
Message-ID: <20131220094134.24233.2969.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set fixes message continuation breakage involved with structured
printk. A SCSI driver may output two continuation error messages like
    scmd_printk("foo");
    printf("bar\n");
Here, scmd_printk() is structured printk with key/value dictionary information.
Structured printk became to forcibly start a new line from commit c313af14, so
those SCSI continuation error messages are divided as follows:
    [1234.567890] sd 2:0:0:0: [sdb] foo
    [1234.567893] bar                    <---- Divided
However, the SCSI driver may expect following continuation error messages:
    [1234.567893] sd 2:0:0:0: [sdb] foo bar
When user tools handle the error messages, that divided message will create
some inconveniences.

This patch set makes structured printk with dictionary information not start a
new line. Moreover, when multiple structured printk messages are continued,
this patch outputs those multiple dictionary information when we read /dev/kmsg.

Thanks!

---

Yoshihiro YUNOMAE (2):
      printk: Add dictionary information in structure cont
      printk: Delete LOG_NEWLINE flag for structured printk


 kernel/printk/printk.c |   70 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 25 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
