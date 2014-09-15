Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaIOABO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 20:01:14 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:49253 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaIOABM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 20:01:12 -0400
Date: Mon, 15 Sep 2014 01:00:25 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Message-ID: <20140915010025.5940c946@alan.etchedpixels.co.uk>
In-Reply-To: <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
	<1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The base of the bounds directory is set into mm_struct during
> PR_MPX_REGISTER command execution. This member can be used to
> check whether one application is mpx enabled.

Not really because by the time you ask the question another thread might
have decided to unregister it.


> +int mpx_register(struct task_struct *tsk)
> +{
> +	struct mm_struct *mm = tsk->mm;
> +
> +	if (!cpu_has_mpx)
> +		return -EINVAL;
> +
> +	/*
> +	 * runtime in the userspace will be responsible for allocation of
> +	 * the bounds directory. Then, it will save the base of the bounds
> +	 * directory into XSAVE/XRSTOR Save Area and enable MPX through
> +	 * XRSTOR instruction.
> +	 *
> +	 * fpu_xsave() is expected to be very expensive. In order to do
> +	 * performance optimization, here we get the base of the bounds
> +	 * directory and then save it into mm_struct to be used in future.
> +	 */
> +	mm->bd_addr = task_get_bounds_dir(tsk);
> +	if (!mm->bd_addr)
> +		return -EINVAL;

What stops two threads calling this in parallel ?
> +
> +	return 0;
> +}
> +
> +int mpx_unregister(struct task_struct *tsk)
> +{
> +	struct mm_struct *mm = current->mm;
> +
> +	if (!cpu_has_mpx)
> +		return -EINVAL;
> +
> +	mm->bd_addr = NULL;

or indeed calling this in parallel

What are the semantics across execve() ?

Alan
