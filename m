Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3A2LaC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:30:02 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47659 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3A2L37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:29:59 -0500
From: Igor Lukyanov <igor@lukyanov.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Follow up: multiple heavy-loaded KVM guests cause NULL pointer in CFS (kernel v 3.7.4)
Date: Tue, 29 Jan 2013 15:29:55 +0400
Message-Id: <8D1CC287-DA03-4B22-95D0-DCA72442B3E4@lukyanov.org>
Cc: peterz@infradead.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
A bit analysis in addition to my previous message.
The problem is that we receive NULL pointer dereference errors from inside of CFS (upstream kernel version 3.2-3.7) while running heavy loaded kvm-virtualized guests on 2-numa node server.

Null pointers are always met in  pick_next_task_fair() method, with the following call traces:

1st case (confirmed in 3 tests):
http://xdel.ru/downloads/oops-default-kvmintel.txt (1 trace)
http://xdel.ru/downloads/oops-old-qemu.txt (2nd and 3rd traces)

2nd case (confirmed in 1 test):
http://imgur.com/QUmszYj
http://imgur.com/zhqLrCy
http://imgur.com/TZipg7F (4nd trace, sorry for images)


I'm not familiar with kernel internal arch, but seems that in 1st case
cfs_rq->nr_running != 0 && __pick_first_entity(struct cfs_rq *cfs_rq) == null
OR se->run_node is null.

and in 2nd case it seems that cfs_rq->tasks_timeline seems to be null.

I tried to mind map calls, here is a scheme http://imgur.com/bvEFX5h
Bug is exposed randomly while running cpu-consuming operations (like installation or simultaneous start of multiple virtual machines) on multi-numa node server with cpu cgroups enabled.
Tested and confirmed on 3.2, 3.4, 3.7 kernels.


I see 3 possible sources of described problem:
1. External code (qemu-kvm or cgroups) that breaks internal state of scheduler.
Have not idea whether it's possible or not for 3rd party kernel module (like kvm or cgroups) to break internal state of scheduler. 

2. Scheduler 
The bug is very rare and exposes only on heavy-loaded multi-numa server.
So it's virtually possible that bug exists and was not detected earlier just due to it's rarity.

3.  Hardware 
Very unlikely, as the bug is stably detected with same call trace and no other symptoms of hardware problem are exposed.

Thank you for help.
--
wbr, Igor Lukyanov