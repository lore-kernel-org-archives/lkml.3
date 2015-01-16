Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbbAPBQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:16:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbbAPBQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:16:47 -0500
Date: Thu, 15 Jan 2015 17:16:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/2] mm/slub: optimize alloc/free fastpath by
 removing preemption on/off
Message-Id: <20150115171634.685237a4.akpm@linux-foundation.org>
In-Reply-To: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 16:40:32 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> We had to insert a preempt enable/disable in the fastpath a while ago
> in order to guarantee that tid and kmem_cache_cpu are retrieved on the
> same cpu. It is the problem only for CONFIG_PREEMPT in which scheduler
> can move the process to other cpu during retrieving data.
> 
> Now, I reach the solution to remove preempt enable/disable in the fastpath.
> If tid is matched with kmem_cache_cpu's tid after tid and kmem_cache_cpu
> are retrieved by separate this_cpu operation, it means that they are
> retrieved on the same cpu. If not matched, we just have to retry it.
> 
> With this guarantee, preemption enable/disable isn't need at all even if
> CONFIG_PREEMPT, so this patch removes it.
> 
> I saw roughly 5% win in a fast-path loop over kmem_cache_alloc/free
> in CONFIG_PREEMPT. (14.821 ns -> 14.049 ns)

I'm surprised.  preempt_disable/enable are pretty fast.  I wonder why
this makes a measurable difference.  Perhaps preempt_enable()'s call to
preempt_schedule() added pain?

