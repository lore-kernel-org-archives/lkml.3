Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083Ab3HSPv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:51:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3HSPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:51:57 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=FhRC9Vwtdx4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=mmEQHNNGUxcA:10 a=VnNF1IyMAAAA:8 a=tEj9Vwj6nBLB2YuANe0A:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 19 Aug 2013 11:51:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RT 2/3] swait: Add memory barrier before checking list
 empty
Message-ID: <20130819115155.41f909fe@gandalf.local.home>
In-Reply-To: <20130819153618.983248997@goodmis.org>
References: <20130819153530.409041534@goodmis.org>
	<20130819153618.983248997@goodmis.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 11:35:32 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> There's a race condition with swait wakeups and adding to the list. The
> __swait_wake() does a check for swait_head_has_waiters(), and if it is
> empty it will exit without doing any wake ups. The problem is that the
> check does not include any memory barriers before it makes a decision
> to wake up or not.
> 
> 	CPU0				CPU1
> 	----				----
> 
>   condition = 1
> 
>   load h->list (is empty)
> 				    raw_spin_lock(hlist->lock)
> 				    hlist_add();
> 				    __set_current_state();
> 				    raw_spin_unlock(hlist->lock)
>   swait_wake()
>    swait_head_has_waiters()
>    (sees h->list as empty and returns)
> 

BTW, the race still exists if you move the raw_spin_unlock(hlist->lock)
above to here. That is:

   swait_wake()
    swait_head_has_waiters()
     (sees h->list as empty and returns)

				    raw_spin_unlock(hlist->lock)


Maybe this will help to understand it more.

-- Steve

> 				    check_condition (sees condition = 0)
> 
>    store condition = 1
> 
> 				    schedule()
> 
> Now the task on CPU1 has just missed its wakeup. By adding a memory
> barrier before the list empty check, we fix the problem of miss seeing
> the list not empty as well as pushing out the condition for the other
> task to see.
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
