Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3KENpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:45:40 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:26544 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab3KENpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:45:39 -0500
Subject: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
To: ptesarik@suse.cz, d.hatayama@jp.fujitsu.com,
        kumagai-atsushi@mxc.nes.nec.co.jp
From: Jingbai Ma <jingbai.ma@hp.com>
Cc: bhe@redhat.com, tom.vaden@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        anderson@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com
Date: Tue, 05 Nov 2013 21:45:32 +0800
Message-ID: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set intend to exclude unnecessary hugepages from vmcore dump file.

This patch requires the kernel patch to export necessary data structures into
vmcore: "kexec: export hugepage data structure into vmcoreinfo"
http://lists.infradead.org/pipermail/kexec/2013-November/009997.html

This patch introduce two new dump levels 32 and 64 to exclude all unused and
active hugepages. The level to exclude all unnecessary pages will be 127 now.

            |         cache    cache                    free    active
      Dump  |  zero   without  with     user    free    huge    huge
      Level |  page   private  private  data    page    page    page
     -------+----------------------------------------------------------
         0  |
         1  |   X
         2  |           X
         4  |           X        X
         8  |                            X
        16  |                                    X
        32  |                                            X
        64  |                                            X       X
       127  |   X       X        X       X       X       X       X

example:
To exclude all unnecessary pages:
makedumpfile -c --message-level 23 -d 127 /proc/vmcore /var/crash/kdump

To exclude all unnecessary pages but keep active hugepages:
makedumpfile -c --message-level 23 -d 63 /proc/vmcore /var/crash/kdump

---

Jingbai Ma (3):
      makedumpfile: hugepage filtering: add hugepage filtering functions
      makedumpfile: hugepage filtering: add excluding hugepage messages
      makedumpfile: hugepage filtering: add new dump levels for manual page


 makedumpfile.8 |  170 +++++++++++++++++++++++++++--------
 makedumpfile.c |  272 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 makedumpfile.h |   19 ++++
 print_info.c   |   12 +-
 print_info.h   |    2 
 5 files changed, 431 insertions(+), 44 deletions(-)

--

