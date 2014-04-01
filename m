Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaDASRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:17:08 -0400
Received: from mail1.windriver.com ([147.11.146.13]:47054 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaDASRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:17:06 -0400
Message-ID: <533B0288.2020304@windriver.com>
Date: Tue, 1 Apr 2014 14:16:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Len Brown <len.brown@intel.com>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Arne Bockholdt <linux-kernel@bockholdt.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Regression in intel_idle on Avaton/Rangely Mohon Peak board
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

I've got an eval board with a 1.7GHz Avaton/C2000 that hangs at boot
shortly after the idle driver registration -- typically 1/2 dozen
dmesg lines later, around rtc init, or net stack init.

It may be that this early board/early bios makes it a non-issue for
mainline, but I figured I'd better mention it anyway.

Problem starts with commit v3.12-rc4-32-gfab04b2208dd
("intel_idle: Support Intel Atom Processor C2000 Product Family").

Even though a bisect leads here, this commit shouldn't be considered
in isolation however, since it depends on these earlier v3.12 commits:

commit v3.12-rc2-1-geba682a5aeb6
   "intel_idle: shrink states tables"

commit v3.12-rc2-2-g9d046ccb9808
   "intel_idle: mark states tables with __initdata tag"

..and then these v3.13 subsequent fixups;

commit v3.13-rc1-1-g22e580d07f65
   "intel_idle: Fixed C6 state on Avoton/Rangeley processors"

commit v3.13-rc7-1-gba0dc81ed5d9
   "Revert "intel_idle: mark states tables with __initdata tag""

commit v3.13-rc7-2-g88390996c95b
   "intel_idle: close avn_cstates array with correct marker"

However, even with all these present in v3.13-final, the board
still does the same thing as the bisected fab 04 commit.  Same
for v3.14-final and today's linux-next -- i.e. the regression
remains uninterrupted.

The interesting part is that a nearly identical board, but with
different (newer/faster) CPU and newer BIOS doesn't have the hang.

Hardware details:

board: intel Mohon Peak CRB GA-95PEV ALPHA2  rev0.3
BIOS: EDVLCRB1.86B.0010.R00.1303272109  03/27/2013
CPU (dmidecode):
        Family: Pentium 4
        ID: D0 06 04 00 FF FB EB 9F
        Signature: Type 0, Family 6, Model 77, Stepping 0
        Version: Genuine Intel(R) CPU   4000  @ 1.70GHz

The same board that doesn't hang, for comparison, has:

BIOS: EDVLCRB1.86B.0017.R00.1305271414  05/27/2013
CPU: (dmidecode):
        Family: Pentium 4
        ID: D0 06 04 00 FF FB EB 9F
        Signature: Type 0, Family 6, Model 77, Stepping 0
        Version: Genuine Intel(R) CPU   4000  @ 2.40GHz

Since it appears only the clock multiplier has changed, I'm
guessing we've hit a bug in the earlier BIOS.  These boards
don't have flash capable BIOS AFAICT -- looks like the little
trap-door socket style that houses a removable chip?

I have the full dmidecode files, dmesg from 3.11-distro kernel,
lspci, and /proc/cpuinfo from both boards, if that is needed.

Paul.
