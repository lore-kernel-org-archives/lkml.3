Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab3BVXLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 18:11:21 -0500
Received: from mail.openrapids.net ([64.15.138.104]:59582 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753819Ab3BVXLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 18:11:20 -0500
Date: Fri, 22 Feb 2013 18:11:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Ted Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: Julien Desfossez <julien.desfossez@efficios.com>,
        linux-kernel@vger.kernel.org
Subject: [BUG] Lenovo x230: SATA errors with 180GB Intel 520 SSD under
	heavy write load
Message-ID: <20130222231116.GA28058@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We spent a couple of days cornering what appears to be an issue with the
Intel 520 SSD drives in Lenovo x230 laptops. It was first showing up
on a clean Debian installation, while installing a guest operating
system into a VM. Looking around on forums, there appears to be some
people having issues with database workloads too. So I decided to create
a small user-space program to repoduce the problem. IMPORTANT: Before
you try it, be ready for a system crash. It's available at:

git://git.efficios.com/test-ssd.git

direct link to .c file:
https://git.efficios.com/?p=test-ssd.git;a=blob;f=test-ssd-write.c;hb=refs/heads/master

This program simply performs random-access-writes of 4Kb into a single
file.

Executive summary of our findings (the details are in the
test-ssd-write.c header in the git repo):

- We reproduced this issue on 4 x230 machines (all our x230 have 180GB
  Intel drives, and they are all affected),
- We took a SSD from one of the machines, moved it into an x200, and the
  problem still occurs,
- The problem seems to occur independently of the filesystem (reproduced
  on ext3 and ext4),
- Problem reproduced by test-ssd-write.c (git tree above): After less
  than 5 minutes of the heavy write workload, we get SATA errors and we
  need to cold reboot the machine to access the drive again. Example
  usage (don't forget to prepare for a computer freeze):

  ./test-ssd-write somefileondisk 209715200 1234 -z

  (see options by just running ./test-ssd-write)

The problem occurs with drive model SSDSC2BW180A3L, with both firmwares
LE1i and LF1i (those are Lenovo firmwares). We could reproduce the issue
on 3.2 (Debian), 3.5 (Debian), 3.7.9 (Arch) distribution kernels. We
could reproduce it with x230 BIOS G2ET90WW (2.50) 2012-20-12 and
G2ET86WW (2.06) 2012-11-13, but since it can be reproduced on a x200
too, it does not appear to be a BIOS issue.

We tried the program on a range of other SSD drives, one of those
including the same SandForce 2281 controller (details within
test-ssd-write.c header). So our current guess is that the Lenovo
firmware on the SSD might be part of the problem, but it might be good
if we could to confirm that Intel's firmwares work fine.

Thoughts, ideas, hints about who to contact on this issue would be very
much welcome,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
