Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaB1Fwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:52:45 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:38198 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaB1Fwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:52:43 -0500
MIME-Version: 1.0
In-Reply-To: <1376507361-26907-1-git-send-email-galak@codeaurora.org>
References: <1376507361-26907-1-git-send-email-galak@codeaurora.org>
Date: Thu, 27 Feb 2014 21:52:43 -0800
Message-ID: <CAJAp7OhBxJme7BRMJL3G3ookES7=QOvQSakgHGkThU=Ykwx8+A@mail.gmail.com>
Subject: Re: [PATCH v3] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex block
From: Bjorn Andersson <bjorn@kryo.se>
To: Kumar Gala <galak@codeaurora.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

I pulled this in to my 3.14 tree and gave it a spin. But I keep
hitting the case of unlock below telling me that someone else is
holding the lock.

On Wed, Aug 14, 2013 at 12:09 PM, Kumar Gala <galak@codeaurora.org> wrote:
[...]
> +
> +static int msm_hwspinlock_trylock(struct hwspinlock *lock)
> +{
> +       void __iomem *lock_addr = lock->priv;
> +
> +       writel_relaxed(SPINLOCK_ID_APPS_PROC, lock_addr);

You need some sort of barrier here; the caf code have a smp_mb() here,
inserting that solves the problem.

> +
> +       return readl_relaxed(lock_addr) == SPINLOCK_ID_APPS_PROC;
> +}
> +
> +static void msm_hwspinlock_unlock(struct hwspinlock *lock)
> +{
> +       u32 lock_owner;
> +       void __iomem *lock_addr = lock->priv;
> +
> +       lock_owner = readl_relaxed(lock_addr);
> +       if (lock_owner != SPINLOCK_ID_APPS_PROC) {
> +               pr_err("%s: spinlock not owned by us (actual owner is %d)\n",
> +                               __func__, lock_owner);
> +       }
> +
> +       writel_relaxed(0, lock_addr);
> +}
> +

Part of this I think this driver looks good, it would be nice to get
the last details cleaned up so we could get it into the tree.

Regards,
Bjorn
