Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaHEMO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:14:28 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:49125 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaHEMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:14:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140805073237.GX3935@laptop>
References: <CAJhHMCADiEsUC7GsYF7=qMNEyRJerfhC5zh7WQPgkQ0gJn5=5A@mail.gmail.com>
 <20140804185226.GQ8101@linux.vnet.ibm.com> <CAJhHMCBEprK9hp786cwguJR=JW7Xxgt4GKX5=E0vikO-D4qmZg@mail.gmail.com>
 <20140805073237.GX3935@laptop>
From: Pranith Kumar <pranith@gatech.edu>
Date: Tue, 5 Aug 2014 08:13:54 -0400
X-Google-Sender-Auth: JpVsgl02aoQht37atE9f8E1Hr7s
Message-ID: <CAJhHMCBjub+_Gg_wC2EoR5OgzwT7JTHr-wzoGp_dePUBVwEG8g@mail.gmail.com>
Subject: Re: Question regarding "Control Dependencies" in memory-barriers.txt
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 3:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> 685 This transformation loses the ordering between the load from variable 'a'
>> 686 and the store to variable 'b'.  If you are relying on this ordering, you
>> 687 should do something like the following:
>> 688
>> 689         q = ACCESS_ONCE(a);
>> 690         BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
>> 691         if (q % MAX) {
>> 692                 ACCESS_ONCE(b) = p;
>> 693                 do_something();
>> 694         } else {
>> 695                 ACCESS_ONCE(b) = p;
>> 696                 do_something_else();
>> 697         }
>> 698
>>
>> How is the BUILD_BUG_ON(MAX <= 1) guaranteeing the ordering w.r.t 'a'
>> and 'b'. Shouldn't it have barrier() in both the legs of the if()
>> statement like follows:
>
> The BUILD_BUG_ON guarantees that 'q % MAX' isn't a constant, and
> therefore the compiler cannot take the conditional out.
>
> And no barrier() doesn't order anything except compiler output. The
> ordering here happens by the conditional, CPUs do not do speculative
> writes, this means it has to complete the load of q to compute the
> branch before it can execute the store of b.
>
>

I don't think the write to 'b' here is speculative since it is
happening in both the legs of the if() conditional. The write to b can
be pulled out to before the conditional. Without the barrier(), isn't
the following a valid transformation of the above?

BUILD_BUG_ON(MAX <= 1); /* this will be compiled out if MAX != 1*/
q = ACCESS_ONCE(a);
ACCESS_ONCE(b) = p; / *BUG: No ordering */
if (q % MAX) {
        do_something();
} else {
        do_something_else();
}

I don't see how it is preserving the ordering.

-- 
Pranith
