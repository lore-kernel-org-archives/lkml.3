Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab3IINHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:07:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24977 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3IINHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:07:39 -0400
Date: Mon, 9 Sep 2013 09:06:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Subject: Re: [PATCH 1/5] xen/spinlock: Fix locking path engaging too soon
 under PVHVM.
Message-ID: <20130909130654.GB21435@phenom.dumpdata.com>
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
 <1378561605-18998-2-git-send-email-konrad.wilk@oracle.com>
 <522DA37B.1070309@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522DA37B.1070309@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 11:31:23AM +0100, David Vrabel wrote:
> On 07/09/13 14:46, Konrad Rzeszutek Wilk wrote:
> > The xen_lock_spinning has a check for the kicker interrupts
> > and if it is not initialised it will spin normally (not enter
> > the slowpath).
> > 
> > But for PVHVM case we would initialise the kicker interrupt
> > before the CPU came online. This meant that if the booting
> > CPU used a spinlock and went in the slowpath - it would
> > enter the slowpath and block forever. The forever part b/c
> 
> b/c? Ewww.  Proper English please.
> 
> > during bootup the interrupts are disabled - so the CPU would
> > never get an IPI kick and would stay stuck in the slowpath
> > logic forever.
> 
> This description isn't right -- VCPUs blocked in SCHEDOP_poll can be
> unblocked on the event they're waiting for even if local irq delivery is
> disabled.
> 
> > Why would the booting CPU never get an IPI kick? B/c in both
> > PV and PVHVM we consult the cpu_online_mask to determine whether
> > the IPI should go to its CPU destination. Since the booting
> > CPU has not yet finished and set that flag, it meant that
> > if any spinlocks were taken before the booting CPU had gotten to:
> 
> I can't find where the online mask is being checked in
> xen_send_IPI_one().  Is this really the reason why it didn't work?

More details in fc78d343fa74514f6fd117b5ef4cd27e4ac30236
Author: Chuck Anderson <chuck.anderson@oracle.com>
Date:   Tue Aug 6 15:12:19 2013 -0700

    xen/smp: initialize IPI vectors before marking CPU online

I will add that part in.
> 
> This fix looks fine but both the description and the comment need to be
> fixed/clarified.

U r Right!

> 
> David
