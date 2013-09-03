Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab3ICDpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:45:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41330 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3ICDpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:45:21 -0400
Message-ID: <52255B4A.6070804@oracle.com>
Date: Mon, 02 Sep 2013 20:45:14 -0700
From: Chuck Anderson <chuck.anderson@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Dan Duval <dan.duval@oracle.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] audit: fix soft lockups and udevd errors when audit is
 overrun
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two patches that follow in separate emails resolve soft lockups and
udevd reported errors that prevented a large memory 3.8 system from booting.

The patches are based on 3.11-rc7.

I believe it is the same issue recently posted as:

   [RFC] audit: avoid soft lockup in audit_log_start()
   https://lkml.org/lkml/2013/8/28/626

The first patch:

   audit: fix soft lockups due to loop in audit_log_start() when 
audit_backlog_limit exceeded

fixes a bug in kernel/audit that caused many soft lockups during boot:

   BUG: soft lockup - CPU#66 stuck for 22s! [udevd:9559]
   RIP: 0010:[<ffffffff810d1d06>]  [<ffffffff810d1d06>] 
audit_log_start+0xe6/0x350
   Call Trace:
    [<ffffffff8108ea30>] ? try_to_wake_up+0x2d0/0x2d0
    [<ffffffff810d8d6f>] audit_log_exit+0x3f/0x590
    [<ffffffff810d975d>] __audit_syscall_exit+0x28d/0x2c0
    [<ffffffff815e0440>] sysret_audit+0x17/0x21

The second patch:

   audit: Two efficiency fixes for audit mechanism

prevents these and similar error messages repeated often during boot:

   udevd[876]: worker [887] unexpectedly returned with status 0x0100
   udevd[876]: worker [887] failed while handling 
'/devices/pci0000:00/0000:00:03.0/0000:40:00.0'
   udevd[876]: worker [880] unexpectedly returned with status 0x0100
   udevd[876]: worker [880] failed while handling 
'/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1'

   udevadm settle - timeout of 180 seconds reached, the event queue 
contains:
     /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1 (3995)
     /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT3F0D:00 (4034)

   audit: audit_backlog=258 > audit_backlog_limit=256
   audit: audit_lost=1 audit_rate_limit=0 audit_backlog_limit=256
