Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036AbaICWvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:51:42 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57074 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934519AbaICWvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:51:40 -0400
Message-ID: <54079B70.4050200@hurleysoftware.com>
Date: Wed, 03 Sep 2014 18:51:28 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>
CC: Oleg Nesterov <oleg@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com>
In-Reply-To: <20140712181328.GA8738@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc linux-arch, Tony Luck, 

On 07/12/2014 02:13 PM, Oleg Nesterov wrote:
> Hello,
> 
> I am not sure I should ask here, but since Documentation/memory-barriers.txt
> mentions load/store tearing perhaps my question is not completely off-topic...
> 
> I am fighting with mysterious RHEL bug, it can be reproduced on ppc and s390
> but not on x86. Finally I seem to understand the problem, and I even wrote the
> stupid kernel module to ensure, see it below at the end.
> 
> It triggers the problem immediately, kt_2() sees the wrong value in freeze_stop.
> (If I turn ->freeze_stop int "long", the problem goes away).
> 
> So the question is: is this gcc bug or the code below is buggy?
> 
> If it is buggy, then probably memory-barriers.txt could mention that you should
> be carefull with bit fields, even ACCESS_ONCE() obviously can't help.
> 
> Or this just discloses my ignorance and you need at least aligned(long) after a
> bit field to be thread-safe ? I thought that compiler should take care and add
> the necessary alignment if (say) CPU can't update a single byte/uint.

Apologies for hijacking this thread but I need to extend this discussion
somewhat regarding what a compiler might do with adjacent fields in a structure.

The tty subsystem defines a large aggregate structure, struct tty_struct.
Importantly, several different locks apply to different fields within that
structure; ie., a specific spinlock will be claimed before updating or accessing
certain fields while a different spinlock will be claimed before updating or
accessing certain _adjacent_ fields.

What is necessary and sufficient to prevent accidental false-sharing?
The patch below was flagged as insufficient on ia64, and possibly ARM.

Regards,
Peter Hurley

--- >% ---
Subject: [PATCH 21/26] tty: Convert tty_struct bitfield to bools

The stopped, hw_stopped, flow_stopped and packet bits are smp-unsafe
and interrupt-unsafe. For example,

CPU 0                         | CPU 1
                              |
tty->flow_stopped = 1         | tty->hw_stopped = 0

One of these updates will be corrupted, as the bitwise operation
on the bitfield is non-atomic.

Ensure each flag has a separate memory location, so concurrent
updates do not corrupt orthogonal states.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1c3316a..7cf61cb 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -261,7 +261,10 @@ struct tty_struct {
 	unsigned long flags;
 	int count;
 	struct winsize winsize;		/* winsize_mutex */
-	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
+	bool stopped;
+	bool hw_stopped;
+	bool flow_stopped;
+	bool packet;
 	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */
 	int flow_change;
-- 
2.1.0

