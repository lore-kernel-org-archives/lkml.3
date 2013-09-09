Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3IIKb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:31:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:40128 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3IIKb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:31:26 -0400
X-IronPort-AV: E=Sophos;i="4.90,866,1371081600"; 
   d="scan'208";a="49544432"
Message-ID: <522DA37B.1070309@citrix.com>
Date: Mon, 9 Sep 2013 11:31:23 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefan.bader@canonical.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/5] xen/spinlock: Fix locking path engaging too soon
 under PVHVM.
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com> <1378561605-18998-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1378561605-18998-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/13 14:46, Konrad Rzeszutek Wilk wrote:
> The xen_lock_spinning has a check for the kicker interrupts
> and if it is not initialised it will spin normally (not enter
> the slowpath).
> 
> But for PVHVM case we would initialise the kicker interrupt
> before the CPU came online. This meant that if the booting
> CPU used a spinlock and went in the slowpath - it would
> enter the slowpath and block forever. The forever part b/c

b/c? Ewww.  Proper English please.

> during bootup the interrupts are disabled - so the CPU would
> never get an IPI kick and would stay stuck in the slowpath
> logic forever.

This description isn't right -- VCPUs blocked in SCHEDOP_poll can be
unblocked on the event they're waiting for even if local irq delivery is
disabled.

> Why would the booting CPU never get an IPI kick? B/c in both
> PV and PVHVM we consult the cpu_online_mask to determine whether
> the IPI should go to its CPU destination. Since the booting
> CPU has not yet finished and set that flag, it meant that
> if any spinlocks were taken before the booting CPU had gotten to:

I can't find where the online mask is being checked in
xen_send_IPI_one().  Is this really the reason why it didn't work?

This fix looks fine but both the description and the comment need to be
fixed/clarified.

David
