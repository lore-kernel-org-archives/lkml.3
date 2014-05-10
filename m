Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaEJPCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 11:02:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaEJPCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 11:02:05 -0400
Message-ID: <1399734119.3558.16.camel@localhost>
Subject: Re: [PATCH V2 1/6] namespaces: assign each namespace instance a
 serial number
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, arozansk@redhat.com,
        serge@hallyn.com, ebiederm@xmission.com, sgrubb@redhat.com
Date: Sat, 10 May 2014 11:01:59 -0400
In-Reply-To: <f34b584ffed2538176f9a366e25bb98c531fb70f.1399681022.git.rgb@redhat.com>
References: <cover.1399681022.git.rgb@redhat.com>
	 <f34b584ffed2538176f9a366e25bb98c531fb70f.1399681022.git.rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 20:27 -0400, Richard Guy Briggs wrote:
> Generate and assign a serial number per namespace instance since boot.
> 
> Use a serial number per namespace (unique across one boot of one kernel)
> instead of the inode number (which is claimed to have had the right to change
> reserved and is not necessarily unique if there is more than one proc fs) to
> uniquely identify it per kernel boot.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---

> +/**
> + * ns_serial - compute a serial number for the namespace
> + *
> + * Compute a serial number for the namespace to uniquely identify it in
> + * audit records.
> + */
> +unsigned long long ns_serial(void)
> +{
> +	static DEFINE_SPINLOCK(serial_lock);
> +	static unsigned long long serial = 4; /* reserved for IPC, UTS, user, PID */
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&serial_lock, flags);
> +	++serial;
> +	spin_unlock_irqrestore(&serial_lock, flags);
> +	BUG_ON(!serial);
> +
> +	return serial;
> +}
> +
>  static inline struct nsproxy *create_nsproxy(void)
>  {
>  	struct nsproxy *nsproxy;

atomic64_t instead of doing it yourself?

and why _irqsave() ?  Can we seriously create new namespaces in irq
context?  If you use the atomic though, you don't have to worry about
it...

