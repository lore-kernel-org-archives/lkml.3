Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3CWRou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:44:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3CWRos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:44:48 -0400
Date: Sat, 23 Mar 2013 18:42:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 1/7] uretprobes: preparation patch
Message-ID: <20130323174223.GA2759@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-2-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-2-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Anton Arapov wrote:
>
> @@ -1488,10 +1496,14 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
>  {
>  	struct uprobe_consumer *uc;
>  	int remove = UPROBE_HANDLER_REMOVE;
> +	int rc = 0;
>  
>  	down_read(&uprobe->register_rwsem);
>  	for (uc = uprobe->consumers; uc; uc = uc->next) {
> -		int rc = uc->handler(uc, regs);
> +		if (uc->handler)
> +			rc = uc->handler(uc, regs);
> +		else
> +			remove = 0;

Well, this doesn't look good. Yes, we need to conditionalize uc->handler()
and rc checks, but the code looks ugly. We touch remove twice, and the value
of rc inside the loop is bogus if ->handler == NULL.

I wouldn't have argued, but, but 4/7 changes the "else" branch and this change
is wrong (I'll write another email). We do not need this "else" at all.

I'd suggest the patch below.

Oleg.

--- x/kernel/events/uprobes.c
+++ x/kernel/events/uprobes.c
@@ -1491,10 +1491,13 @@ static void handler_chain(struct uprobe 
 
 	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next) {
-		int rc = uc->handler(uc, regs);
+		int rc = 0;
 
-		WARN(rc & ~UPROBE_HANDLER_MASK,
-			"bad rc=0x%x from %pf()\n", rc, uc->handler);
+		if (uc->handler) {
+			rc = uc->handler(uc, regs);
+			WARN(rc & ~UPROBE_HANDLER_MASK,
+				"bad rc=0x%x from %pf()\n", rc, uc->handler);
+		}
 		remove &= rc;
 	}
 

