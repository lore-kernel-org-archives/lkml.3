Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3L0GOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:14:44 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58314 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3L0GOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:14:42 -0500
Message-ID: <52BD1ACA.7030506@hitachi.com>
Date: Fri, 27 Dec 2013 15:14:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip v2 1/2] [CLEANUP] perf-probe: Expand given path to
 absolute path
References: <20131226054148.22364.25224.stgit@kbuild-fedora.novalocal> <20131226054150.22364.12187.stgit@kbuild-fedora.novalocal> <52BC39D6.3090908@gmail.com> <20131226142248.GE30980@ghostprotocols.net>
In-Reply-To: <20131226142248.GE30980@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/26 23:22), Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 26, 2013 at 09:14:46AM -0500, David Ahern escreveu:
>> On 12/26/13, 12:41 AM, Masami Hiramatsu wrote:
>>> @@ -180,7 +181,20 @@ static int opt_set_target(const struct option *opt, const char *str,
>>>  		else
>>>  			return ret;
>>>
>>> -		params.target = str;
>>> +		/* Expand given path to absolute path, except for modulename */
>>> +		if (params.uprobes || strchr(str, '/')) {
>>> +			tmp = realpath(str, NULL);
>>> +			if (!tmp) {
>>> +				pr_warning("Failed to find the path of %s.\n",
>>> +					   str);
>>
>> That error message will be misleading if it is generated. How about:
>>     Failed to get the absolute path of %s: %d\n", str, errno.
> 
> Changed it to:
> 
>  pr_warning("Failed to get the absolute path of %s: %m\n", str);

Thanks, that looks good to me.

>>> +				return ret;
>>> +			}
>>> +		} else {
>>> +			tmp = strdup(str);
>>> +			if (!tmp)
>>> +				return -ENOMEM;
>>> +		}
>>> +		params.target = tmp;
>>
>> When is params.target freed?

Nowhere, since there is no terminal code for user
command interface.

Those memories are released when the program terminated.
I think it is just a waste of the time to free the memory
pieces which are not used(and allocated) repeatedly.
Or, is there any chance to call this part directly from
other command?


Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


