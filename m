Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3JIWdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:33:16 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753662Ab3JIWdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:33:15 -0400
Message-ID: <5255D9A6.3010208@nod.at>
Date: Thu, 10 Oct 2013 00:33:10 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        hannes@cmpxchg.org, darrick.wong@oracle.com,
        Michal Hocko <mhocko@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [uml-devel] BUG: soft lockup for a user mode linux image
References: <524DC675.4020201@gmx.de> <524E57BA.805@nod.at> <52517109.90605@gmx.de> <CAMuHMdXrU0e_6AxvdboMkDs+N+tSWD+b8ou92j28c0vsq2eQQA@mail.gmail.com> <5251C334.3010604@gmx.de> <CAMuHMdUo8dSd4s3089ZDEc485wL1sFxBKLeaExJuqNiQY+S-Lw@mail.gmail.com> <5251CF94.5040101@gmx.de> <CAMuHMdWs6Y7y12STJ+YXKJjxRF0k5yU9C9+0fiPPmq-GgeW-6Q@mail.gmail.com> <525591AD.4060401@gmx.de> <5255A3E6.6020100@nod.at> <20131009214733.GB25608@quack.suse.cz>
In-Reply-To: <20131009214733.GB25608@quack.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.10.2013 23:47, schrieb Jan Kara:
> On Wed 09-10-13 20:43:50, Richard Weinberger wrote:
>> CC'ing mm folks.
>> Please see below.
>   Added Fenguang to CC since he is the author of this code.

Thx, get_maintainer.pl didn't list him.

>> Am 09.10.2013 19:26, schrieb Toralf Förster:
>>> On 10/08/2013 10:07 PM, Geert Uytterhoeven wrote:
>>>> On Sun, Oct 6, 2013 at 11:01 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>>>> Hmm, now pages_dirtied is zero, according to the backtrace, but the BUG_ON()
>>>>>> asserts its strict positive?!?
>>>>>>
>>>>>> Can you please try the following instead of the BUG_ON():
>>>>>>
>>>>>> if (pause < 0) {
>>>>>>         printk("pages_dirtied = %lu\n", pages_dirtied);
>>>>>>         printk("task_ratelimit = %lu\n", task_ratelimit);
>>>>>>         printk("pause = %ld\n", pause);
>>>>>> }
>>>>>>
>>>>>> Gr{oetje,eeting}s,
>>>>>>
>>>>>>                         Geert
>>>>> I tried it in different ways already - I'm completely unsuccessful in getting any printk output.
>>>>> As soon as the issue happens I do have a
>>>>>
>>>>> BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:1521]
>>>>>
>>>>> at stderr of the UML and then no further input is accepted. With uml_mconsole I'm however able
>>>>> to run very basic commands like a crash dump, sysrq ond so on.
>>>>
>>>> You may get an idea of the magnitude of pages_dirtied by using a chain of
>>>> BUG_ON()s, like:
>>>>
>>>> BUG_ON(pages_dirtied > 2000000000);
>>>> BUG_ON(pages_dirtied > 1000000000);
>>>> BUG_ON(pages_dirtied > 100000000);
>>>> BUG_ON(pages_dirtied > 10000000);
>>>> BUG_ON(pages_dirtied > 1000000);
>>>>
>>>> Probably 1 million is already too much for normal operation?
>>>>
>>> period = HZ * pages_dirtied / task_ratelimit;
>>> 		BUG_ON(pages_dirtied > 2000000000);
>>> 		BUG_ON(pages_dirtied > 1000000000);      <-------------- this is line 1467
>>
>> Summary for mm people:
>>
>> Toralf runs trinty on UML/i386.
>> After some time pages_dirtied becomes very large.
>> More than 1000000000 pages in this case.
>   Huh, this is really strange. pages_dirtied is passed into
> balance_dirty_pages() from current->nr_dirtied. So I wonder how a value
> over 10^9 can get there. After all that is over 4TB so I somewhat doubt the
> task was ever able to dirty that much during its lifetime (but correct me
> if I'm wrong here, with UML and memory backed disks it is not totally
> impossible)... I went through the logic of handling ->nr_dirtied but
> I didn't find any obvious problem there. Hum, maybe one thing - what
> 'task_ratelimit' values do you see in balance_dirty_pages? If that one was
> huge, we could possibly accumulate huge current->nr_dirtied.

Toralf, you can try a snipplet like this one to get the values printed out:
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index f5236f8..a80e520 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1463,6 +1463,12 @@ static void balance_dirty_pages(struct address_space *mapping,
                        goto pause;
                }
                period = HZ * pages_dirtied / task_ratelimit;
+
+               {
+                       extern int printf(char *, ...);
+                       printf("---> task_ratelimit: %lu\n", task_ratelimit);
+               }
+
                pause = period;
                if (current->dirty_paused_when)
                        pause -= now - current->dirty_paused_when;


Yes, printf(), not printk().
Using this hack we print directly to host's stdout. :)

Thanks,
//richard
