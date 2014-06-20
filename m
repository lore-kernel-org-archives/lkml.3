Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbaFTCTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 22:19:40 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47316 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaFTCTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 22:19:39 -0400
Message-ID: <53A39A33.6020405@hitachi.com>
Date: Fri, 20 Jun 2014 11:19:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip v2 3/3] kprobes: Set IPMODIFY flag only if the probe
 can change regs->ip
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>  <20140617110456.15167.89566.stgit@kbuild-fedora.novalocal> <1403181271.1670.18.camel@leonhard>
In-Reply-To: <1403181271.1670.18.camel@leonhard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/19 21:34), Namhyung Kim wrote:
> Hi Masami,
> 
> 2014-06-17 (화), 11:04 +0000, Masami Hiramatsu:
>> +static int __ftrace_add_filter_ip(struct ftrace_ops *ops, unsigned long ip,
>> +				  int *ref)
>> +{
>> +	int ret;
>> +
>> +	/* Try to set given ip to filter */
>> +	ret = ftrace_set_filter_ip(ops, ip, 0, 0);
>> +	if (ret >= 0) {
> 
> Hmm.. this doesn't look comfortable.  What not using usual pattern?
> 
> 	if (ret < 0)
> 		return ret;
> 
> This way we can reduce a indent level.

OK, I'll do so :)

> 
> 
>> +		(*ref)++;
>> +		if (*ref == 1) {
>> +			ret = register_ftrace_function(ops);
>> +			if (ret < 0) {
>> +				/* Rollback refcounter and filter */
>> +				(*ref)--;
>> +				ftrace_set_filter_ip(ops, ip, 1, 0);
>> +			}
>> +		}
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int __ftrace_remove_filter_ip(struct ftrace_ops *ops, unsigned long ip,
>> +				     int *ref)
>> +{
>> +	int ret = 0;
>> +
>> +	(*ref)--;
>> +	if (*ref == 0)
>> +		ret = unregister_ftrace_function(ops);
>> +	if (ret >= 0)
>> +		/* Try to remove given ip to filter */
>> +		ret = ftrace_set_filter_ip(ops, ip, 1, 0);
> 
> I think any failure at this time can be problematic.  Since we already
> unregistered the ops but the refcount will get increased again, future
> attemp to register won't enable the ops anymore IMHO.

Agreed.

> I think it'd better just ignoring faiure of filter removal here.  We'll
> miss a filter entry but it'll be usable anyway.
> 
> What about this?

OK, I'll use your v2 code :)

Thank you for review!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


