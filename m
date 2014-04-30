Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbaD3O6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:58:47 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:35615 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255AbaD3O6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:58:46 -0400
Message-ID: <53610FA3.10205@suse.cz>
Date: Wed, 30 Apr 2014 16:58:43 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 01/16] ftrace: Add function to find fentry of function
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>	<1398868249-26169-2-git-send-email-jslaby@suse.cz> <20140430104856.272169be@gandalf.local.home>
In-Reply-To: <20140430104856.272169be@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 04:48 PM, Steven Rostedt wrote:
> On Wed, 30 Apr 2014 16:30:34 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -1495,6 +1495,35 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
>>  		}				\
>>  	}
>>  
>> +/**
>> + * ftrace_function_to_fentry -- lookup fentry location for a function
>> + * @addr: function address to find a fentry in
>> + *
>> + * Perform a lookup in a list of fentry callsites to find one that fits a
>> + * specified function @addr. It returns the corresponding fentry callsite or
>> + * zero on failure.
>> + */
>> +unsigned long ftrace_function_to_fentry(unsigned long addr)
>> +{
>> +	const struct dyn_ftrace *rec;
>> +	const struct ftrace_page *pg;
>> +	unsigned long ret = 0;
>> +
>> +	mutex_lock(&ftrace_lock);
>> +	do_for_each_ftrace_rec(pg, rec) {
> 
> The records are sorted within a pg. You can optimize this a lot if you
> just test the first and last record and see if it is in the range. If
> not, then skip to the next page. If it is, you can use a bsearch as
> well, to save on the lookups.

Yes, this is a KISS (and suboptimal) version as there is a slight issue
in your suggestion: if we pass addres of a function of which the fentry
is the first in pg, it would be out of range for the particular pg. What
should work is: check the first entry and then search binary...

thanks,
-- 
js
suse labs
