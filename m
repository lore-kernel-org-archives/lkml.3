Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3FXOpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab3FXOpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:45:53 -0400
Date: Mon, 24 Jun 2013 16:39:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130624143928.GA20659@redhat.com>
References: <20130620161652.GA4462@linux.vnet.ibm.com> <20130621151119.GA1596@redhat.com> <20130621195949.GA15519@redhat.com> <20130622013731.GA22918@redhat.com> <20130622173129.GA29375@redhat.com> <20130622215905.GA28238@redhat.com> <20130623143634.GA2000@redhat.com> <20130623150603.GA32313@redhat.com> <20130623160452.GA11740@redhat.com> <20130624020014.GB12811@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624020014.GB12811@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Dave Jones wrote:
>
> On Sun, Jun 23, 2013 at 06:04:52PM +0200, Oleg Nesterov wrote:
>
>  > Could you please do the following:
>  >
>  > 	1. # cd /sys/kernel/debug/tracing
>  > 	   # echo 0 >> options/function-trace
>  > 	   # echo preemptirqsoff >> current_tracer
>
> dammit.
>
> WARNING: at include/linux/list.h:385 rb_head_page_deactivate.isra.39+0x61/0x80()

Hmmm. which kernel do use use?

   380  #define list_for_each(pos, head) \
   381          for (pos = (head)->next; pos != (head); pos = pos->next)
   382
   383  /**
   384   * __list_for_each      -       iterate over a list
   385   * @pos:        the &struct list_head to use as a loop cursor.
   386   * @head:       the head for your list.
   387   *
   388   * This variant doesn't differ from list_for_each() any more.
   389   * We don't do prefetching in either case.
   390   */
   391  #define __list_for_each(pos, head) \
   392          for (pos = (head)->next; pos != (head); pos = pos->next)
   393
   394  /**
   395   * list_for_each_prev   -       iterate over a list backwards
   396   * @pos:        the &struct list_head to use as a loop cursor.
   397   * @head:       the head for your list.
   398   */
   399  #define list_for_each_prev(pos, head) \
   400          for (pos = (head)->prev; pos != (head); pos = pos->prev)

On 9e895ace5d8 (Linux 3.10-rc7).

>  check_list_nodes corruption. next->prev should be prev (ffff88023b8a1a08), but was 00ffff88023b8a1a. (next=ffff880243288001).

Can't find "check_list_nodes" in lib/list_debug.c or elsewhere...

>   [<ffffffff816e467d>] dump_stack+0x19/0x1b
>   [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
>   [<ffffffff8104a12c>] warn_slowpath_fmt+0x4c/0x50
>   [<ffffffff81112c61>] rb_head_page_deactivate.isra.39+0x61/0x80

How? rb_list_head_clear() just modifies list->next directly.

> hopefully despite that it'll actually function as intended.

Yes ;)

Oleg.

