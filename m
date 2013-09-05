Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3IEWui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:50:38 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38847 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab3IEWuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:50:35 -0400
Message-Id: <20130905225032.879120272@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Sep 2013 17:50:32 -0500
From: Mike Travis <travis@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] x86/UV/KDB/NMI: Updates for NMI/KDB handler for SGI UV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


V2:  Split KDB updates from NMI updates.  Broke up the big patch to
     uv_nmi.c into smaller patches.  Updated to the latest linux
     kernel version.

The current UV NMI handler has not been updated for the changes in the
system NMI handler and the perf operations.  The UV NMI handler reads
an MMR in the UV Hub to check to see if the NMI event was caused by
the external 'system NMI' that the operator can initiate on the System
Mgmt Controller.

The problem arises when the perf tools are running, causing millions of
perf events per second on very large CPU count systems.  Previously this
was okay because the perf NMI handler ran at a higher priority on the
NMI call chain and if the NMI was a perf event, it would stop calling
other NMI handlers remaining on the NMI call chain.

Now the system NMI handler calls all the handlers on the NMI call
chain including the UV NMI handler.  This causes the UV NMI handler
to read the MMRs at the same millions per second rate.  This can lead
to significant performance loss and possible system failures.  It also
can cause thousands of 'Dazed and Confused' messages being sent to the
system console.  This effectively makes perf tools unusable on UV systems.

This patch set addresses this problem and allows the perf tools to run on
UV without impacting performance and causing system failures.

-- 
