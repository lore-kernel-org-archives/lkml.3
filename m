Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaBRBlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:41:19 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58689 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaBRBlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:41:17 -0500
X-AuditID: 85900ec0-cff26b9000001514-35-5302ba3a7565
Message-ID: <5302BA3A.7000303@hitachi.com>
Date: Tue, 18 Feb 2014 10:41:14 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH -tip RESEND 2/2] ftrace: Introduce nr_saved_cmdlines
 I/F
References: <20140213012852.15283.50473.stgit@yunodevel> <20140213012858.15283.93302.stgit@yunodevel> <878utez4a1.fsf@sejong.aot.lge.com> <530196A9.5060304@hitachi.com> <87mwhqxlcc.fsf@sejong.aot.lge.com>
In-Reply-To: <87mwhqxlcc.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

(2014/02/17 16:13), Namhyung Kim wrote:
> Hi Yoshihiro,
> 
> On Mon, 17 Feb 2014 13:57:13 +0900, Yoshihiro YUNOMAE wrote:
>> Hi Namhyung,
>>
>> (2014/02/14 13:50), Namhyung Kim wrote:
>>> Hi Yoshihiro,
>>>
>>> On Thu, 13 Feb 2014 10:28:58 +0900, Yoshihiro YUNOMAE wrote:
>>>> Introduce nr_saved_cmdlines I/F for changing the number of pid-comm list.
>>>> saved_cmdlines can store 128 command names using SAVED_CMDLINES now, but
>>>> 'no-existing processes' names are often lost in saved_cmdlines when we
>>>> read trace data. So, by introducing nr_saved_cmdlines I/F, the rule storing
>>>> 128 command names is changed to the command numbers defined users.
>>>>
>>>> When we write a value to nr_saved_cmdlines, the number of the value will
>>>> be stored in pid-comm list:
>>>>
>>>> 	# echo 1024 > /sys/kernel/debug/tracing/nr_saved_cmdlines
>>>>
>>>> Here, 1024 command names are stored. The default number is 128 and the maximum
>>>> number is PID_MAX_DEFAULT (=32768 if CONFIG_BASE_SMALL is not set). So, if we
>>>> want to avoid to lose command names, we need to set 32768 to nr_saved_cmdlines.
>>>>
>>>> We can read the maximum number of the list:
>>>>
>>>> 	# cat /sys/kernel/debug/tracing/nr_saved_cmdlines
>>>> 	128
>>>
>>> [SNIP]
>>>> @@ -3685,7 +3760,8 @@ static void *saved_cmdlines_next(struct seq_file *m, void *v, loff_t *pos)
>>>>    
>>>>    	(*pos)++;
>>>>    
>>>> -	for (; ptr < &map_cmdline_to_pid[SAVED_CMDLINES]; ptr++) {
>>>> +	for (; ptr < &savedcmd->map_cmdline_to_pid[savedcmd->cmdline_num];
>>>> +	     ptr++) {
>>>>    		if (*ptr == -1 || *ptr == NO_CMDLINE_MAP)
>>>>    			continue;
>>>>    
>>>> @@ -3700,7 +3776,7 @@ static void *saved_cmdlines_start(struct seq_file *m, loff_t *pos)
>>>>    	void *v;
>>>>    	loff_t l = 0;
>>>>    
>>>> -	v = &map_cmdline_to_pid[0];
>>>> +	v = &savedcmd->map_cmdline_to_pid[0];
>>>>    	while (l <= *pos) {
>>>>    		v = saved_cmdlines_next(m, v, &l);
>>>>    		if (!v)
>>>
>>> Are you accessing the savecmd without trace_cmdline_lock?
>>
>> It does not need to get trace_cmdline_lock here.
>> The elements of map_pid_to_cmdline[] and saved_cmdlines[] are protected
>> by trace_cmdline_lock in trace_find_cmdline(), but on the other hand
>> map_cmdline_to_pid[] are not protected. There are no problems in
>> particular. This is because map_cmdline_to_pid[] always refers to a
>> valid process name or "<...>".
> 
> I don't get it.  What does protect the savedcmd from being changed
> during reading "saved_cmdlines" file with changing "nr_saved_cmdlines"?

Ah, that's true. As you say, this implementation can cause the
competition problem. I'll fix it in V2.

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


