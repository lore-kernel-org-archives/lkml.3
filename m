Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaHDSwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:52:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34826 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaHDSwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:52:32 -0400
Date: Mon, 4 Aug 2014 11:52:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding "Control Dependencies" in memory-barriers.txt
Message-ID: <20140804185226.GQ8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJhHMCADiEsUC7GsYF7=qMNEyRJerfhC5zh7WQPgkQ0gJn5=5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCADiEsUC7GsYF7=qMNEyRJerfhC5zh7WQPgkQ0gJn5=5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080418-3532-0000-0000-000003994CCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 01:07:47PM -0400, Pranith Kumar wrote:
> The section "Control Dependencies" in memory-barriers.txt has the
> following text:
> 
> 662 In addition, you need to be careful what you do with the local variable 'q',
> 663 otherwise the compiler might be able to guess the value and again remove
> 664 the needed conditional.  For example:
> 665
> 666         q = ACCESS_ONCE(a);
> 667         if (q % MAX) {
> 668                 barrier();
> 669                 ACCESS_ONCE(b) = p;
> 670                 do_something();
> 671         } else {
> 672                 barrier();
> 673                 ACCESS_ONCE(b) = p;
> 674                 do_something_else();
> 675         }
> 676
> 677 If MAX is defined to be 1, then the compiler knows that (q % MAX) is
> 678 equal to zero, in which case the compiler is within its rights to
> 679 transform the above code into the following:
> 680
> 681         q = ACCESS_ONCE(a);
> 682         ACCESS_ONCE(b) = p;
> 683         do_something_else();
> 
> Given that there is an explicit barrier() in both the branches of
> if/else statement, how can the above transformation happen? The
> compiler cannot just remove the barrier(), right?

No, the compiler cannot just remove the barrier().  However, it can
notice that "q % MAX" is always zero, which allows it to throw away
the then-clause entirely.

> I think it will transform to the following if MAX is defined to 1:
> 
> q = ACCESS_ONCE(a);
> barrier();
> ACCESS_ONCE(b) = p;
> do_something_else();

Good point, the "barrier()" must be retained, but...

> and hence the ordering will be preserved. What am I missing here?

Because the barrier() primitive affects only the compiler, the CPU
can still reorder things.

In contrast, in the original, the control dependency implied by the "if"
statement prevents the CPU from reordering.

I fixed the example to retain the barrier() with your Reported-by.

						Thanx, Paul

