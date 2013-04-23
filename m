Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3DWOZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:25:56 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:13548
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755677Ab3DWOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:25:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLPPEW-02-OG1-02
X-M-MSG: 
Date: Tue, 23 Apr 2013 09:25:46 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130423142546.GA17021@jshin-Toonie>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
 <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
 <20130423131844.GA24467@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130423131844.GA24467@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 03:18:44PM +0200, Oleg Nesterov wrote:
> On 04/23, Jacob Shin wrote:
> >
> > +__weak int arch_validate_hwbkpt_addr_mask(struct perf_event *bp)
> > +{
> > +	return bp->attr.bp_addr_mask == 0;
> > +}
> > +
> >  static int validate_hw_breakpoint(struct perf_event *bp)
> >  {
> >  	int ret;
> > @@ -393,6 +398,10 @@ static int validate_hw_breakpoint(struct perf_event *bp)
> >  	if (ret)
> >  		return ret;
> >  
> > +	ret = arch_validate_hwbkpt_addr_mask(bp);
> > +	if (ret)
> > +		return ret;
> 
> Well, this looks obviously wrong?
> 
> arch_validate_hwbkpt_addr_mask() fails if bp_addr_mask == 0? and returns
> "1" as the error code.
> 
> Either it should returns something like "bp_addr_mask ? -ENOTSUPP : 0"
> or the caller should do "if (!validate_hw_breakpoint()) return -ERR".

You are absolutely right. I have mixed up "does this arch support address
masks?" vs "is this a valid address mask?" So sorry about that.

Here is the corrected patch:

>From f2054e8af979f024aa2da93f80646db18492479e Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Mon, 22 Apr 2013 17:02:37 -0500
Subject: [PATCH 1/4] perf: Add hardware breakpoint address mask

Some architectures (for us, AMD Family 16h) allow for "don't care" bit
mask to further qualify a hardware breakpoint address, in order to
trap on range of addresses. Update perf uapi to add bp_addr_mask field.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 include/uapi/linux/perf_event.h |    5 ++++-
 kernel/events/hw_breakpoint.c   |    9 +++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index fb104e5..e22e1d1 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -286,7 +286,10 @@ struct perf_event_attr {
 		__u64		config1; /* extension of config */
 	};
 	union {
-		__u64		bp_len;
+		struct {
+			__u32		bp_len;
+			__u32		bp_addr_mask;
+		};
 		__u64		config2; /* extension of config1 */
 	};
 	__u64	branch_sample_type; /* enum perf_branch_sample_type */
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index a64f8ae..dde8273 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -385,6 +385,11 @@ int dbg_release_bp_slot(struct perf_event *bp)
 	return 0;
 }
 
+__weak int arch_validate_hwbkpt_addr_mask(struct perf_event *bp)
+{
+	return bp->attr.bp_addr_mask ? -EOPNOTSUPP : 0;
+}
+
 static int validate_hw_breakpoint(struct perf_event *bp)
 {
 	int ret;
@@ -393,6 +398,10 @@ static int validate_hw_breakpoint(struct perf_event *bp)
 	if (ret)
 		return ret;
 
+	ret = arch_validate_hwbkpt_addr_mask(bp);
+	if (ret)
+		return ret;
+
 	if (arch_check_bp_in_kernelspace(bp)) {
 		if (bp->attr.exclude_kernel)
 			return -EINVAL;
-- 
1.7.9.5


