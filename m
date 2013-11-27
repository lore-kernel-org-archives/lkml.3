Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3K0IWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:22:25 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52984 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3K0IWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:22:24 -0500
Message-ID: <5295ABB9.7040207@hitachi.com>
Date: Wed, 27 Nov 2013 17:22:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Add $cpu and $current probe-vars
References: <20131123201543.GA22148@redhat.com> <20131125192926.GA9737@redhat.com> <20131125192952.GB9737@redhat.com> <529405AC.6090401@hitachi.com> <20131126172313.GA14028@redhat.com>
In-Reply-To: <20131126172313.GA14028@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/27 2:23), Oleg Nesterov wrote:
> On 11/26, Masami Hiramatsu wrote:
>>
>> (2013/11/26 4:29), Oleg Nesterov wrote:
>>> +#define PSEUDO_REG_OFFSET	4096	/* arbitrary value > MAX_REG_OFFSET */
>>> +
>>> +static unsigned long probe_get_register(struct pt_regs *regs, unsigned long offset)
>>> +{
>>> +	if (offset < PSEUDO_REG_OFFSET)
>>> +		return regs_get_register(regs, offset);
>>> +
>>> +	return pseudo_reg_table[offset - PSEUDO_REG_OFFSET].fetch();
>>> +}
>>
>>
>> Hmm, I don't like this, since fetch_reg is the most frequently
>> used fetch method, and it actually uses the offset in different
>> way.
> 
> Sure, this overloads the usage of FETCH_MTD_reg/offset.
> 
> And btw, yes, the naming is ugly (I mean pseudo_*). But why this
> is bad? This is cheap and simple.

I think it's not simple. The code looks short, but not well
self-described. It is "hidden" in the structure, and double-meaning.

> And,
> 
>> Why don't you make another fetch function for vars?
> 
> This is what I tried to avoid ;) I do not want to add another
> FETCH_MTD_. To me, this looks like unnecessary complication and
> bloat (but see below).

I see, perhaps, it is a time to introduce independent fetch
method implementation. Current one is not sophisticated
nor generic. We need a kind of "bytecode" implementation
for more complex expression, especially for the combination
of several registers/variables on stacks. This feature will
also be useful for some other scriptable tracers like ktap,
systemtap etc.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


