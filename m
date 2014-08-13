Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaHMQDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:03:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54948 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMQC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:02:59 -0400
Message-ID: <53EB8C2C.9030709@hitachi.com>
Date: Thu, 14 Aug 2014 01:02:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Naohiro Aota <naota@elisp.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [BUGFIX] perf probe: Fix --list option to show events
 only with uprobe events
References: <20140813005055.24360.73553.stgit@kbuild-fedora.novalocal> <87r40ldkv8.fsf@sejong.aot.lge.com> <53EB746E.1020904@hitachi.com> <20140813144801.GA2718@kernel.org>
In-Reply-To: <20140813144801.GA2718@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/13 23:48), Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 13, 2014 at 11:21:34PM +0900, Masami Hiramatsu escreveu:
>> (2014/08/13 14:22), Namhyung Kim wrote:
>>> On Wed, 13 Aug 2014 00:50:55 +0000, Masami Hiramatsu wrote:
>>>> +	if (kp_fd < 0 && up_fd < 0) {
>>>> +		/* Both kprobes and uprobes are disabled, warn it. */
>>>> +		if (kp_fd == -ENOTSUP && up_fd == -ENOTSUP)
>>>> +			pr_warning("Debugfs is not mounted.\n");
>>>> +		else if (kp_fd == -ENOENT && up_fd == -ENOENT)
>>>> +			pr_warning("Please rebuild kernel with "
>>>> +				   "CONFIG_KPROBE_EVENTS or/and "
>>>> +				   "CONFIG_UPROBE_EVENTS.\n");
>>>> +		else
>>>> +			pr_warning("Failed to open kprobe events: %s.\n" \
>>>> +				   "Failed to open uprobe events: %s.\n",
>>>> +				   strerror(-kp_fd), strerror(-up_fd));
>>>
>>> It seems the second strerror() might overwrite the message of the
>>> first.  You'd better using strerror_r() IMHO.
> 
> Well spotted!
>  
>> Oops, right, it must use the same buffer...
>> But instead of using strerror_r, we can call pr_warning twice. Or should we
>> better replace all strerror to strerror_r in perf? (it should be another series)
> 
> Well, don't introduce new strerror() uses, we have threads in perf
> already and if both try to use strerror() for different reasons, say the
> UI to print something to the user and some logging/debugging thread do
> it to the disk, we may race.

OK, I'll use strerror_r() in next version.

> So, in this case, please use strerror_r() and if you feel like
> contributing the changes to any other place where strerror() is still
> used, you are welcome to do so at a later patch :)

Yeah, I'll do that. :)

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


