Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaJHK2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:28:09 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55112 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaJHK2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:28:06 -0400
Content-Type: text/plain; charset=UTF-8
From: Ian Munsie <imunsie@au1.ibm.com>
To: Michael Neuling <mikey@neuling.org>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>, mpe <mpe@ellerman.id.au>,
        benh <benh@kernel.crashing.org>, anton <anton@samba.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 13/16] cxl: Driver code for powernv PCIe based cards for userspace access
In-reply-to: <1412758505-23495-14-git-send-email-mikey@neuling.org>
References: <1412758505-23495-1-git-send-email-mikey@neuling.org> <1412758505-23495-14-git-send-email-mikey@neuling.org>
Date: Wed, 08 Oct 2014 21:28:05 +1100
Message-Id: <1412763264-sup-2737@delenn.ozlabs.ibm.com>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100810-1618-0000-0000-00000103060F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Michael Neuling's message of 2014-10-08 19:55:02 +1100:
> +static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
> +            loff_t *off)
...
> +    for (;;) {
> +        prepare_to_wait(&ctx->wq, &wait, TASK_INTERRUPTIBLE);
> +        if (ctx_event_pending(ctx))
> +            break;
> +
> +        spin_unlock_irqrestore(&ctx->lock, flags);
> +        if (file->f_flags & O_NONBLOCK)
> +            return -EAGAIN;
> +
> +        if (signal_pending(current))
> +            return -ERESTARTSYS;

Looks like I mucked this up while refactoring - these two cases no
longer call finish_wait() which can lead to a crash if something later
wakes up the ctx->wq... I'll post a fix in a separate patch shortly.

-Ian

