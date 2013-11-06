Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3KFXD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:03:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3KFXDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:03:25 -0500
Date: Wed, 6 Nov 2013 15:03:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: micky <micky_ching@realsil.com.cn>
Cc: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <oakad@yahoo.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] memstick: rtsx: fix ms card data transfer bug
Message-Id: <20131106150323.8596052b0a9490e90db7f986@linux-foundation.org>
In-Reply-To: <52799813.9050302@realsil.com.cn>
References: <1383115216-11967-1-git-send-email-micky_ching@realsil.com.cn>
	<20131105131027.4ce3bc298266bd82104f5fce@linux-foundation.org>
	<52799813.9050302@realsil.com.cn>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 09:14:59 +0800 micky <micky_ching@realsil.com.cn> wrote:

> On 11/06/2013 05:10 AM, Andrew Morton wrote:
> > On Wed, 30 Oct 2013 14:40:16 +0800 <micky_ching@realsil.com.cn> wrote:
> >
> >> unlike mspro card, ms card use normal read/write mode for DMA
> >> data transfer.
> > What are the user-visible effects of this bug?
> >
> > Please always include this information when fixing bugs so that others
> > can decide whether they (or their customers) need the patch.
> >
>

(top-posting repaired - please don't top-post!)

> MS card can not use auto read/write mode, so it will fail at
> initialize and long data transfer. This patch is used to add
> support for ms card.
> 
> Shall I re-send this patch to add more info?

That's OK - I updated the changelog in-place and added cc:stable so it
gets backported.  But then I dropped the patch ;)

>From this info I assume that use of ms cards is very rare, otherwise
people would have complained.  What is the difference between an "ms
card" and an "mspro card"?  How common are each type and what is their
availability?

ms_transfer_data() and mspro_transfer_data() are very similar.  I think
it would be more maintainable if they were integrated into a single
function?

trans_done and timeleft could be made local to the code block where
they used.  This would be neater and more maintainable.

This code is troublesome:

: 	if (pcr->trans_result == TRANS_NOT_READY) {
: 		init_completion(&trans_done);
: 		timeleft = wait_for_completion_interruptible_timeout(
: 			&trans_done, 1000);
: 		if (timeleft < 0) {
: 			dev_dbg(ms_dev(host),
: 				"%s: timeout wait for ok interrupt.\n",
: 				__func__);
: 			return -ETIMEDOUT;
: 		}
: 	}

- Why does it exist?  Needs a comment explaining what it is trying to
  achieve.

- It should use DECLARE_COMPLETION_ONSTACK() for trans_done

- It uses wait_for_completion() but nothing ever calls complete() on
  the object!  That's just bizarre and more appropriate primitives
  should be used.

- The debug message is hard to understand and appears to be wrong. 
  Should be "interrupt received while waiting for <something?>".

- The code appears to be terminating a kernel IO transaction when the
  user hits ^C.  That's just not viable - the ^C could have been
  entered for other reasons and the IO will complete just fine.  Also
  no -EINTR is returned callers don't appear to be set up to handle it.

So shudder.  I'll drop the patch.  Please explain very carefully what
you're trying to achieve here and perhaps we can suggest a suitable
implementation approach.
