Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaI2RZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:25:48 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:32184 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbaI2RZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:25:47 -0400
Message-ID: <54299618.2060408@hp.com>
Date: Mon, 29 Sep 2014 13:25:44 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 2/2] perf tool: improves DSO long names lookup speed
 with rbtree
References: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com> <1411573540-8765-3-git-send-email-Waiman.Long@hp.com> <20140926142234.GC3879@kernel.org> <87d2afhy54.fsf@sejong.aot.lge.com>
In-Reply-To: <87d2afhy54.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 12:02 AM, Namhyung Kim wrote:
> On Fri, 26 Sep 2014 11:22:34 -0300, Arnaldo Carvalho de Melo wrote:
>> Em Wed, Sep 24, 2014 at 11:45:40AM -0400, Waiman Long escreveu:
>>> +	/*
>>> +	 * Find node with the matching name
>>> +	 */
>>> +	while (*p) {
>>> +		struct dso *this = rb_entry(*p, struct dso, rb_node);
>>> +		long rc = (long)strcmp(name, this->long_name);
>>> +
>>> +		parent = *p;
>>> +		if (rc == 0) {
>>> +			/*
>>> +			 * In case the new DSO is a duplicate of an existing
>>> +			 * one, print an one-time warning&  sort the entry
>>> +			 * by its DSO address.
>>> +			 */
>>> +			if (!dso || (dso == this))
>>> +				return this;	/* Find matching dso */
>>> +			/*
>>> +			 * The kernel DSOs may have duplicated long name,
>>> +			 * so don't print warning for them.
>>> +			 */
>>> +			if (!warned&&  !strstr(name, "kernel.kallsyms")
>>> +				&&  !strstr(name, "/vmlinux")) {
>>> +				pr_warning("Duplicated dso long name: %s\n",
>>> +					   name);
>> Huh? Can you elaborate on this? Ho can we add multiple DSOs with the
>> exact same name into this tree? Have you actually seen this in practice?
>> I guess so, judging by the comment above ("may have").
> I guess it's because we split maps and dsos by section name (for kernel
> only).  Please look at dso__load_sym() - If map_groups__find_by_name()
> with short name + section name fails, it creates a new dso and map, and
> then curr_dso->long_name will be set as dso->long_name.
>
> Thanks,
> Namhyung
>

Yes, it is where I found that the different DSOs may have the same long 
name.

-Longman
